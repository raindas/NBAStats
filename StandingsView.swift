//
//  StandingsView.swift
//  NBAStats
//
//  Created by President Raindas on 07/07/2021.
//

import SwiftUI

struct StandingsView: View {
    
    @State var conferenceSelection = "Eastern"
    @State var standings = [Standings]()
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Conference", selection: $conferenceSelection) {
                    Text("Eastern").tag("Eastern")
                    Text("Western").tag("Western")
                }
                .pickerStyle(SegmentedPickerStyle())
                .cornerRadius(8)
                .padding(.horizontal)
                .onChange(of: self.conferenceSelection) { conference in
                    fetchStandings(conference: conference)
                }
                
                HStack {
                    Text("Team")
                    Spacer()
                    Text("W-L")
                }.padding()
                .padding(.horizontal)
                
                ScrollView {
                    ForEach(standings, id:\.TeamID) {
                        team in
                        StandingsTeamView(teamID: team.TeamID, teamName: team.Name, W: team.Wins, L: team.Losses, backgroundColor: Color(.systemGray6))
                    }
                }.padding(.horizontal)
                
            }.navigationTitle("Standings").onAppear {
                fetchStandings(conference: conferenceSelection)
            }
        }
    }
    // fetch standings
    func fetchStandings(conference: String) {
        let urlString = "https://fly.sportsdata.io/v3/nba/scores/json/Standings/2021?key=d8f7758d1d7a444097f1cf0b06e018a5"
        
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
                    let filteredDecodedResponse = decodedResponse.filter { $0.Conference == conference }
                    self.standings = filteredDecodedResponse
                    return
                } catch {
                    print("Unable to fetch team logo URL")
                }
            }
        }.resume()
    }
}

struct StandingsView_Previews: PreviewProvider {
    static var previews: some View {
        StandingsView()
    }
}
