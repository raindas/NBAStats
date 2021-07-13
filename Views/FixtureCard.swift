//
//  FixtureCard.swift
//  NBAStats
//
//  Created by President Raindas on 07/07/2021.
//

import SwiftUI

struct FixtureCard: View {
    
    @EnvironmentObject var preferences:Preferences
    
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
    
    // check if team fixture contains user's favourite team
    // if it does, change the background color to accent color to signify
    var cardBackgroundColor: Color {
        let favTeamID = Preferences().favouriteTeamID
        let accentColor = Preferences().selectedAccentColor
        if favTeamID == homeTeamID {
            return accentColor
        } else if favTeamID == awayTeamID {
            return accentColor
        } else {
            return Color(.systemGray6)
        }
    }
    
    var textForegroundColor: Color {
        let favTeamID = Preferences().favouriteTeamID
        let textColor = Preferences().teamCardTextColor
        if favTeamID == homeTeamID {
            return textColor
        } else if favTeamID == awayTeamID {
            return textColor
        } else {
            return Color.primary
        }
    }
    
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
                    
                    Group {
                        Text(gameStatus == "Scheduled" ? "" : String(homeTeamScore))
                            .font(.title.bold())
                        Text(homeTeamCity)
                            .font(.title3)
                        Text(homeTeamName)
                            .font(.title3)
                    }.foregroundColor(self.textForegroundColor)
                }
                
                Spacer()
                
                Text("VS")
                    .font(.largeTitle.bold())
                    .foregroundColor(self.textForegroundColor)
                
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
                    
                    Group {
                        Text(gameStatus == "Scheduled" ? "" : String(awayTeamScore))
                            .font(.title.bold())
                        Text(awayTeamCity)
                            .font(.title3)
                        Text(awayTeamName)
                            .font(.title3)
                    }.foregroundColor(self.textForegroundColor)
                }
                Spacer()
                
            }.padding(.vertical)
            Text(dateController.to12HoursEST(USEasternDateTime: gameTime))
                .foregroundColor(self.textForegroundColor)
            Text(dateController.to12HoursWAT(USEasternDateTime: gameTime))
                .foregroundColor(self.textForegroundColor)
        }.padding()
        .background(self.cardBackgroundColor)
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
                    let filteredDecodedResponse = decodedResponse.filter { $0.TeamID == teamID }
                    self.teams = filteredDecodedResponse
                    for team in teams {
                        self.homeTeamCity = team.City
                        self.homeTeamName = team.Name
                        self.homeTeamLogoUrl = team.WikipediaLogoUrl
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
                    let filteredDecodedResponse = decodedResponse.filter { $0.TeamID == teamID }
                    self.teams = filteredDecodedResponse
                    for team in teams {
                        self.awayTeamCity = team.City
                        self.awayTeamName = team.Name
                        self.awayTeamLogoUrl = team.WikipediaLogoUrl
                    }
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
        FixtureCard(fixtureDaySelection: .constant(""), homeTeam: "--", awayTeam: "--", homeTeamScore: 0, awayTeamScore: 0, gameTime: "2021-07-08T21:00:00", gameStatus: "--", awayTeamID: 0, homeTeamID: 0).environmentObject(Preferences())
    }
}
