//
//  PreferencesView.swift
//  NBAStats
//
//  Created by President Raindas on 07/07/2021.
//

import SwiftUI

struct PreferencesView: View {
    
    @State var teams = [Teams]()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.teams, id: \.TeamID) {
                    team in
                    Text(team.Name)
                }
            }.navigationTitle("Preferences")
            
        }.onAppear(perform: fetchTeams)
    }
    // fetch teams
    func fetchTeams() {
        let urlString = "https://fly.sportsdata.io/v3/nba/scores/json/teams?key=d8f7758d1d7a444097f1cf0b06e018a5"
        
        // define URL
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        // create URL Request
        let request = URLRequest(url: url)
        // create and start a networking task with the URL request
        // URL Session is the iOS class responsible for managing network requests
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
//                do {
//                                let decodedResponse = try JSONDecoder().decode([MarketNews].self, from: data)
//                    self.marketNews = decodedResponse
//                            } catch {
//                                print("Unable to decode JSON -> \(error)")
//                            }
                let decodedResponse = try? JSONDecoder().decode([Teams].self, from: data)
                if let decodedResponse = decodedResponse {
                    //print(decodedResponse)
                    DispatchQueue.main.async {
                        self.teams = decodedResponse
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

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
