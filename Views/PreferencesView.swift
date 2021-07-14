//
//  PreferencesView.swift
//  NBAStats
//
//  Created by President Raindas on 07/07/2021.
//

import SwiftUI

struct PreferencesView: View {
    
    @EnvironmentObject var preferences:Preferences
    @EnvironmentObject var vm:ViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        Picker("Favourite team", selection: self.$vm.CurrentFavouriteTeamIndex, content: {
                            ForEach(vm.allTeams, id: \.TeamID) {
                                team in
                                HStack {
                                        SVGLogo(SVGUrl: team.WikipediaLogoUrl, frameWidth: 25, frameHeight: 25)
                                            .frame(width: 25, height: 25, alignment: .center).padding(.leading)
                                        Text("\(team.City) \(team.Name)")
                                    }
                            }
                        }).onChange(of: vm.CurrentFavouriteTeamIndex, perform: { _ in
                            let FavTeamID = vm.allTeams[vm.CurrentFavouriteTeamIndex-1].TeamID
                            preferences.saveFavouriteTeam(teamIndex: vm.CurrentFavouriteTeamIndex, teamID: FavTeamID)
                        })
                        
                        Picker("Accent color", selection: self.$vm.CurrentAccentColor, content: {
                            ForEach(preferences.colorListKeys, id:\.self) {
                                colorName in
                                HStack {
                                    Circle()
                                        .fill(preferences.colorList[colorName] ?? Color.blue)
                                        .frame(width: 25, height: 25, alignment: .center)
                                    Text(colorName)
                                }
                            }
                        }).onChange(of: vm.CurrentAccentColor, perform: { _ in
                            preferences.saveAccentColor(colorName: vm.CurrentAccentColor)
                        })
                    }
                }
            }.navigationTitle("Preferences")
            
        }.onAppear(perform: vm.fetchTeams).accentColor(preferences.selectedAccentColor)
    }
    
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
            .environmentObject(Preferences())
            .environmentObject(ViewModel())
    }
}
