//
//  StandingsTeamView.swift
//  NBAStats
//
//  Created by President Raindas on 10/07/2021.
//

import SwiftUI

struct StandingsTeamView: View {
    
    let teamID: Int
    let teamName: String
    let W: Int
    let L: Int
    let backgroundColor: Color
    let foregroundColor: Color
    
    @EnvironmentObject var vm:ViewModel
    
    @State var standingTeamlogoURL = ""
    
    var body: some View {
        HStack {
            if standingTeamlogoURL == "" {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 25, height: 25, alignment: .center).padding(.leading)
            } else {
                SVGLogo(SVGUrl: standingTeamlogoURL, frameWidth: 25, frameHeight: 25)
//                    .scaleEffect(CGSize(width: (1.0/7), height: (1.0/7)))
                    .frame(width: 25, height: 25, alignment: .center).padding(.leading)
            }
            
            Text(teamName).foregroundColor(foregroundColor).padding(.leading)
            Spacer()
            Text("\(W)-\(L)").foregroundColor(foregroundColor)
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(15)
        .onAppear {
            fetchStandingTeamLogoURL(teamID: teamID)
        }
    }
    // get standing team logo URL
    func fetchStandingTeamLogoURL(teamID: Int) {
        let urlString = "\(vm.APIBaseURL)teams?key=\(vm.APIKey)"
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
                    DispatchQueue.main.async {
                        vm.teams = filteredDecodedResponse
                        for team in vm.teams {
                            self.standingTeamlogoURL = team.WikipediaLogoUrl
                        }
                    }
                } catch {
                    print("Unable to fetch team logo URL")
                }
            }
        }.resume()
    }
}

struct StandingsTeamView_Previews: PreviewProvider {
    static var previews: some View {
        StandingsTeamView(teamID: 0, teamName: "__", W: 49, L: 23, backgroundColor: Color(.systemGray6),foregroundColor: Color.black)
            .environmentObject(ViewModel())
    }
}
