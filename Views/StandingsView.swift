//
//  StandingsView.swift
//  NBAStats
//
//  Created by President Raindas on 07/07/2021.
//

import SwiftUI

struct StandingsView: View {
    
    @EnvironmentObject var preferences:Preferences
    @EnvironmentObject var vm:ViewModel
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Preferences().selectedAccentColor)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : Preferences().SegmentedPickerTextColor], for: .selected)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Conference", selection: self.$vm.conferenceSelection) {
                    Text("Eastern").tag("Eastern")
                    Text("Western").tag("Western")
                }
                .pickerStyle(SegmentedPickerStyle())
                .cornerRadius(8)
                .padding(.horizontal)
                .onChange(of: vm.conferenceSelection) { conference in
                    vm.fetchStandings()
                }
                
                HStack {
                    Text("Team")
                    Spacer()
                    Text("W-L")
                }.padding()
                .padding(.horizontal)
                
                ScrollView {
                    ForEach(vm.standings, id:\.TeamID) {
                        team in
                        StandingsTeamView(teamID: team.TeamID, teamName: team.Name, W: team.Wins, L: team.Losses, backgroundColor: preferences.favouriteTeamID == team.TeamID ? preferences.selectedAccentColor : Color(.systemGray6), foregroundColor: preferences.favouriteTeamID == team.TeamID ? preferences.teamCardTextColor : Color.primary)
                    }
                }.padding(.horizontal)
                
            }.navigationTitle("Standings").onAppear {
                vm.fetchStandings()
            }
        }.accentColor(preferences.selectedAccentColor)
    }
    
}

struct StandingsView_Previews: PreviewProvider {
    static var previews: some View {
        StandingsView()
            .environmentObject(Preferences())
            .environmentObject(ViewModel())
    }
}
