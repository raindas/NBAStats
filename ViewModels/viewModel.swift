//
//  viewModel.swift
//  NBAStats
//
//  Created by President Raindas on 13/07/2021.
//

import Foundation

final class ViewModel: ObservableObject {
    let APIBaseURL = "https://fly.sportsdata.io/v3/nba/scores/json/"
    let APIKey = ""//<-- insert API key here
    private var dateController = DateController()
    @Published var fixtureDaySelection = "today"
    @Published var fixtures = [Fixtures]()
    @Published var teams = [Teams]()
    @Published var allTeams = [Teams]()
    @Published var homeTeamCity = "--"
    @Published var homeTeamName = "--"
    @Published var awayTeamCity = "--"
    @Published var awayTeamName = "--"
    @Published var homeTeamLogoUrl = ""
    @Published var awayTeamLogoUrl = ""
    @Published var conferenceSelection = "Eastern"
    @Published var standings = [Standings]()
    @Published var CurrentFavouriteTeamIndex = Preferences().favouriteTeamIndex
    @Published var CurrentAccentColor = Preferences().accentColor
    
    // fet fixtures
    func fetchFixtures(when: String) {
        var date = Date()
        
        if when == "yesterday" {
            date = date.addingTimeInterval(-86400) // Yesterday -> minus 1 day (86400 seconds)
        } else if when == "tomorrow" {
            date = date.addingTimeInterval(86400) // Tomorrow -> plus 1 day (86400 seconds)
        }
        
        let fixtureDate = dateController.toEST(date)
        
        //print("Fixture date -> \(fixtureDate)")
        
        let urlString = "\(APIBaseURL)GamesByDate/\(fixtureDate)?key=\(APIKey)"
        
        // define URL
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode([Fixtures].self, from: data)
                    DispatchQueue.main.async {
                        self.fixtures = decodedResponse
                    }
                    return
                } catch {
                    print("Unable to decode JSON -> \(error)")
                }
            }
            print("Fixtures fetch request failed: \(error?.localizedDescription ?? "Unknown Error")")
            //            alertMsg = error?.localizedDescription ?? "Unknown Error"
            //            alertTrigger.toggle()
        }.resume()
    }
    
    // fetch teams full details
    func fetchTeamDetails(homeTeamID: Int, awayTeamID: Int) {
        fetchHomeTeamFullDetails(teamID: homeTeamID)
        fetchAwayTeamFullDetails(teamID: awayTeamID)
    }
    
    func fetchHomeTeamFullDetails(teamID: Int) {
        let urlString = "\(APIBaseURL)teams?key=\(APIKey)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode([Teams].self, from: data)
                    let filteredDecodedResponse = decodedResponse.filter { $0.TeamID == teamID }
                    DispatchQueue.main.async {
                        self.teams = filteredDecodedResponse
                        for team in self.teams {
                            self.homeTeamCity = team.City
                            self.homeTeamName = team.Name
                            self.homeTeamLogoUrl = team.WikipediaLogoUrl
                        }
                    }
                    return
                } catch {
                    print("Unable to filter home team")
                }
            }
            print("Home Team fetch request failed: \(error?.localizedDescription ?? "Unknown Error")")
        }.resume()
    }
    
    func fetchAwayTeamFullDetails(teamID: Int) {
        let urlString = "\(APIBaseURL)teams?key=\(APIKey)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode([Teams].self, from: data)
                    let filteredDecodedResponse = decodedResponse.filter { $0.TeamID == teamID }
                    DispatchQueue.main.async {
                        self.teams = filteredDecodedResponse
                        for team in self.teams {
                            self.awayTeamCity = team.City
                            self.awayTeamName = team.Name
                            self.awayTeamLogoUrl = team.WikipediaLogoUrl
                        }
                    }
                    return
                } catch {
                    print("Unable to filter away team")
                }
            }
            print("Away Team fetch request failed: \(error?.localizedDescription ?? "Unknown Error")")
        }.resume()
    }
    
    // fetch standings
    func fetchStandings() {
        let urlString = "\(APIBaseURL)Standings/2021?key=\(APIKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode([Standings].self, from: data)
                    //print("Teams decoded response -> \(decodedResponse)")
                    let filteredDecodedResponse = decodedResponse.filter { $0.Conference == self.conferenceSelection }
                    DispatchQueue.main.async {
                        self.standings = filteredDecodedResponse
                    }
                    return
                } catch {
                    print("Unable to fetch team logo URL")
                }
            }
        }.resume()
    }
    
    // fetch all teams
    func fetchTeams() {
        let urlString = "\(APIBaseURL)teams?key=\(APIKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decodedResponse = try? JSONDecoder().decode([Teams].self, from: data)
                if let decodedResponse = decodedResponse {
                    //print(decodedResponse)
                    DispatchQueue.main.async {
                        self.allTeams = decodedResponse
                    }
                    return
                }
            }
            print("Teams fetch request failed: \(error?.localizedDescription ?? "Unknown Error")")
//            alertMsg = error?.localizedDescription ?? "Unknown Error"
//            alertTrigger.toggle()
        }.resume()
    }
}
