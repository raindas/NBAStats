//
//  PreferencesView.swift
//  NBAStats
//
//  Created by President Raindas on 07/07/2021.
//

import SwiftUI

struct PreferencesView: View {
    
    @EnvironmentObject var preferences:Preferences
    
    @State var teams = [Teams]()
    @State var CurrentFavouriteTeamIndex = Preferences().favouriteTeamIndex
    @State private var CurrentAccentColor = Preferences().accentColor
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        Picker("Favourite team", selection: $CurrentFavouriteTeamIndex, content: {
                            ForEach(self.teams, id: \.TeamID) {
                                team in
                                HStack {
                                        SVGLogo(SVGUrl: team.WikipediaLogoUrl, frameWidth: 25, frameHeight: 25)
                                            .frame(width: 25, height: 25, alignment: .center).padding(.leading)
                                        Text("\(team.City) \(team.Name)")
                                    }
                            }
                        }).onChange(of: CurrentFavouriteTeamIndex, perform: { _ in
                            let FavTeamID = teams[CurrentFavouriteTeamIndex-1].TeamID
                            preferences.saveFavouriteTeam(teamIndex: CurrentFavouriteTeamIndex, teamID: FavTeamID)
                        })
                        
                        Picker("Accent color", selection: $CurrentAccentColor, content: {
                            ForEach(preferences.colorListKeys, id:\.self) {
                                colorName in
                                HStack {
                                    Circle()
                                        .fill(preferences.colorList[colorName] ?? Color.blue)
                                        .frame(width: 25, height: 25, alignment: .center)
                                    Text(colorName)
                                }
                            }
                        }).onChange(of: CurrentAccentColor, perform: { _ in
                            preferences.saveAccentColor(colorName: CurrentAccentColor)
                        })
                    }
                }
            }.navigationTitle("Preferences")
            
        }.onAppear(perform: fetchTeams).accentColor(preferences.selectedAccentColor)
    }
    // fetch teams
    func fetchTeams() {
        let urlString = "https://fly.sportsdata.io/v3/nba/scores/json/teams?key=d8f7758d1d7a444097f1cf0b06e018a5"
        
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
        PreferencesView().environmentObject(Preferences())
    }
}
