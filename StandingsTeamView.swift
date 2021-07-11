//
//  StandingsTeamView.swift
//  NBAStats
//
//  Created by President Raindas on 10/07/2021.
//

import SwiftUI

struct StandingsTeamView: View {
    
    @State var teams = [Teams]()
    
   // let teamPosition: Int
    let teamID: Int
    let teamName: String
    let W: Int
    let L: Int
    let backgroundColor: Color
    
    @State var logoURL = ""
    
    var body: some View {
        HStack {
            if logoURL == "" {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 25, height: 25, alignment: .center).padding(.leading)
            } else {
                SVGLogo(SVGUrl: logoURL, frameWidth: 25, frameHeight: 25)
//                    .scaleEffect(CGSize(width: (1.0/7), height: (1.0/7)))
                    .frame(width: 25, height: 25, alignment: .center).padding(.leading)
            }
            
            Text(teamName).padding(.leading)
            Spacer()
            Text("\(W)-\(L)")
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(15)
        .onAppear {
            fetchTeamLogoURL(teamID: teamID)
        }
    }
    // get team logo URL
    func fetchTeamLogoURL(teamID: Int) {
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
                        self.logoURL = team.WikipediaLogoUrl
                    }
                    return
                } catch {
                    print("Unable to fetch team logo URL")
                }
            }
        }.resume()
    }
}

struct StandingsTeamView_Previews: PreviewProvider {
    static var previews: some View {
        StandingsTeamView(teamID: 0, teamName: "__", W: 49, L: 23, backgroundColor: Color(.systemGray6))
    }
}
