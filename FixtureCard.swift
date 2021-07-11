//
//  FixtureCard.swift
//  NBAStats
//
//  Created by President Raindas on 07/07/2021.
//

import SwiftUI

struct FixtureCard: View {
    
    var dateController = DateController()
    @State var teams = [Teams]()
    
    @Binding var fixtureDaySelection: String
    
    let homeTeam: String
    let awayTeam: String
    let homeTeamScore: Int
    let awayTeamScore: Int
    let gameTime: String
    let gameStatus: String
    let awayTeamID: Int
    let homeTeamID: Int
    
    @State var homeTeamCity = "--"
    @State var homeTeamName = "--"
    
    @State var awayTeamCity = "--"
    @State var awayTeamName = "--"
    
    @State var homeTeamLogoUrl = ""
    @State var awayTeamLogoUrl = ""
    
    var body: some View {
        VStack {
            HStack {
                
                Spacer()
                
                VStack {
                    if homeTeamLogoUrl == "" {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 50, height: 50, alignment: .center)
                    } else {
                        //RemoteImage(url: homeTeamLogoUrl)
                        SVGLogo(SVGUrl: homeTeamLogoUrl, frameWidth: 50, frameHeight: 50)
                            .frame(width: 50, height: 50, alignment: .center)
                    }
                    //Image(systemName: "photo")
                    
                    Text(gameStatus == "Scheduled" ? "" : String(homeTeamScore))
                        .font(.title.bold())
                    Text(homeTeamCity)
                        .font(.title3)
                    Text(homeTeamName)
                        .font(.title3)
                }
                
                Spacer()
                
                Text("VS")
                    .font(.largeTitle.bold())
                    .foregroundColor(.secondary)
                
                Spacer()
                
                VStack {
                    if awayTeamLogoUrl == "" {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 50, height: 50, alignment: .center)
                    } else {
                        //RemoteImage(url: homeTeamLogoUrl)
                        SVGLogo(SVGUrl: awayTeamLogoUrl, frameWidth: 50, frameHeight: 50)
                            .frame(width: 50, height: 50, alignment: .center)
                    }
                    
                    Text(gameStatus == "Scheduled" ? "" : String(awayTeamScore))
                        .font(.title.bold())
                    Text(awayTeamCity)
                        .font(.title3)
                    Text(awayTeamName)
                        .font(.title3)
                }
                Spacer()
                
            }.padding(.vertical)
            Text(dateController.to12HoursEST(USEasternDateTime: gameTime))
                .foregroundColor(.secondary)
            Text(dateController.to12HoursWAT(USEasternDateTime: gameTime))
                .foregroundColor(.secondary)
        }.padding()
        .background(Color(.systemGray6))
        .cornerRadius(25)
        .onAppear {
            fetchTeamDetails(homeTeamID: homeTeamID, awayTeamID: awayTeamID)
        }
    }
    // fetch teams full details
    func fetchTeamDetails(homeTeamID: Int, awayTeamID: Int) {
        fetchHomeTeamFullDetails(teamID: homeTeamID)
        fetchAwayTeamFullDetails(teamID: awayTeamID)
    }
    
    func fetchHomeTeamFullDetails(teamID: Int) {
        let urlString = "https://fly.sportsdata.io/v3/nba/scores/json/teams?key=d8f7758d1d7a444097f1cf0b06e018a5"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode([Teams].self, from: data)
                    //print("Teams decoded response -> \(decodedResponse)")
                    let filteredDecodedResponse = decodedResponse.filter { $0.TeamID == teamID }
                    self.teams = filteredDecodedResponse
                    for team in teams {
                        self.homeTeamCity = team.City
                        self.homeTeamName = team.Name
                        self.homeTeamLogoUrl = team.WikipediaLogoUrl
                    }
                    //print("Filterd team ID (\(teamID)) -> \(filteredDecodedResponse)")
                    return
                } catch {
                    print("Unable to filter home team")
                }
            }
            print("Home Team fetch request failed: \(error?.localizedDescription ?? "Unknown Error")")
        }.resume()
    }
    
    func fetchAwayTeamFullDetails(teamID: Int) {
        let urlString = "https://fly.sportsdata.io/v3/nba/scores/json/teams?key=d8f7758d1d7a444097f1cf0b06e018a5"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode([Teams].self, from: data)
                    //print("Teams decoded response -> \(decodedResponse)")
                    let filteredDecodedResponse = decodedResponse.filter { $0.TeamID == teamID }
                    self.teams = filteredDecodedResponse
                    for team in teams {
                        self.awayTeamCity = team.City
                        self.awayTeamName = team.Name
                        self.awayTeamLogoUrl = team.WikipediaLogoUrl
                    }
                    //print("Filterd team ID (\(teamID)) -> \(filteredDecodedResponse)")
                    return
                } catch {
                    print("Unable to filter away team")
                }
            }
            print("Away Team fetch request failed: \(error?.localizedDescription ?? "Unknown Error")")
        }.resume()
    }
}

struct FixtureCard_Previews: PreviewProvider {
    static var previews: some View {
        FixtureCard(fixtureDaySelection: .constant(""), homeTeam: "--", awayTeam: "--", homeTeamScore: 0, awayTeamScore: 0, gameTime: "2021-07-08T21:00:00", gameStatus: "--", awayTeamID: 0, homeTeamID: 0)
    }
}
