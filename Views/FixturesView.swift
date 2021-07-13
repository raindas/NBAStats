//
//  ContentView.swift
//  NBAStats
//
//  Created by President Raindas on 07/07/2021.
//

import SwiftUI

struct FixturesView: View {
    
    @EnvironmentObject var preferences:Preferences
    @EnvironmentObject var vm:ViewModel
    
    init() {
        //this changes the "thumb" that selects between items
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Preferences().selectedAccentColor)
        //and this changes the color for the whole "bar" background
       // UISegmentedControl.appearance().backgroundColor = .purple

        //this will change the font size
        //UISegmentedControl.appearance().setTitleTextAttributes([.font : UIFont.preferredFont(forTextStyle: .largeTitle)], for: .normal)

        //these lines change the text color for various states
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : Preferences().SegmentedPickerTextColor], for: .selected)
        //UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.blue], for: .normal)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Fixture day", selection: self.$vm.fixtureDaySelection) {
                    Text("Yesterday").tag("yesterday")
                    Text("Today").tag("today")
                    Text("Tomorrow").tag("tomorrow")
                }
                .pickerStyle(SegmentedPickerStyle())
                .cornerRadius(8)
                .padding(.horizontal)
                .onChange(of: vm.fixtureDaySelection) { fixtureDay in
                    vm.fetchFixtures(when: fixtureDay)
                    print(fixtureDay)
                }
                
                
                ScrollView {
                    if vm.fixtures.count == 0 {
                        Text("No games \(vm.fixtureDaySelection)")
                    } else {
                        ForEach(vm.fixtures, id: \.GameID) {
                            fixture in
                            FixtureCard(fixtureDaySelection: self.$vm.fixtureDaySelection, homeTeam: fixture.HomeTeam, awayTeam: fixture.AwayTeam, homeTeamScore: fixture.HomeTeamScore ?? 0, awayTeamScore: fixture.AwayTeamScore ?? 0, gameTime: fixture.DateTime, gameStatus: fixture.Status, awayTeamID: fixture.AwayTeamID, homeTeamID: fixture.HomeTeamID)
                        }
                    }
                }.padding()
                
            }.navigationTitle("Fixtures")
        }.onAppear {
            vm.fetchFixtures(when: vm.fixtureDaySelection)
        }
        .accentColor(preferences.selectedAccentColor)
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FixturesView()
            .environmentObject(Preferences())
            .environmentObject(ViewModel())
    }
}
