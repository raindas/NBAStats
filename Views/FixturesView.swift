//
//  ContentView.swift
//  NBAStats
//
//  Created by President Raindas on 07/07/2021.
//

import SwiftUI

struct FixturesView: View {
    
    @EnvironmentObject var preferences:Preferences
    
    @State var fixtureDaySelection = "today"
    @State var fixtures = [Fixtures]()
    @State var teams = [Teams]()
    
    init() {
        //this changes the "thumb" that selects between items
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Preferences().selectedAccentColor)
        //and this changes the color for the whole "bar" background
       // UISegmentedControl.appearance().backgroundColor = .purple

        //this will change the font size
        //UISegmentedControl.appearance().setTitleTextAttributes([.font : UIFont.preferredFont(forTextStyle: .largeTitle)], for: .normal)

        //these lines change the text color for various states
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.white], for: .selected)
        //UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.blue], for: .normal)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Fixture day", selection: $fixtureDaySelection) {
                    Text("Yesterday").tag("yesterday")
                    Text("Today").tag("today")
                    Text("Tomorrow").tag("tomorrow")
                }
                .pickerStyle(SegmentedPickerStyle())
                .cornerRadius(8)
                .padding(.horizontal)
                .onChange(of: self.fixtureDaySelection) { fixtureDay in
                    fetchFixtures(when: fixtureDay)
                    print(fixtureDay)
                }
                
                
                ScrollView {
                    if self.fixtures.count == 0 {
                        Text("No games \(fixtureDaySelection)")
                    } else {
                        ForEach(self.fixtures, id: \.GameID) {
                            fixture in
                            FixtureCard(fixtureDaySelection: $fixtureDaySelection, homeTeam: fixture.HomeTeam, awayTeam: fixture.AwayTeam, homeTeamScore: fixture.HomeTeamScore ?? 0, awayTeamScore: fixture.AwayTeamScore ?? 0, gameTime: fixture.DateTime, gameStatus: fixture.Status, awayTeamID: fixture.AwayTeamID, homeTeamID: fixture.HomeTeamID)
                        }
                    }
                }.padding()
                
            }.navigationTitle("Fixtures")
        }.onAppear {
            fetchFixtures(when: fixtureDaySelection)
        }
        .accentColor(preferences.selectedAccentColor)
    }
    
    // fet fixtures
    func fetchFixtures(when: String) {
        var date = Date()
        
        if when == "yesterday" {
            date = date.addingTimeInterval(-86400) // Yesterday -> minus 1 day (86400 seconds)
        } else if when == "tomorrow" {
            date = date.addingTimeInterval(86400) // Tomorrow -> plus 1 day (86400 seconds)
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MMM-dd"
        
        // Since Nigeria (West African Time) is five hours ahead of the API's default US Eastern time, we'll have to set the date back to 5 hours before, hence, we need to subtract the value of 5 hours from the current date (in West African Time)
        let fixtureDate = formatter.string(from: date.addingTimeInterval(-(3600 * 5)))// <-- 1 hour = 3600 seconds, thus 5 hours = 3600 seconds x 5
        
        print("Fixture date -> \(fixtureDate)")
        
        let urlString = "https://fly.sportsdata.io/v3/nba/scores/json/GamesByDate/\(fixtureDate)?key=d8f7758d1d7a444097f1cf0b06e018a5"
        
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
                do {
                    let decodedResponse = try JSONDecoder().decode([Fixtures].self, from: data)
                   // print(decodedResponse)
                    self.fixtures = decodedResponse
                    return
                } catch {
                    print("Unable to decode JSON -> \(error)")
                }
                //                let decodedResponse = try? JSONDecoder().decode([Fixtures].self, from: data)
                //                if let decodedResponse = decodedResponse {
                //                    print(decodedResponse)
                //                    DispatchQueue.main.async {
                //                        self.fixtures = decodedResponse
                //                    }
                //                    return
                //                }
            }
            print("Fixtures fetch request failed: \(error?.localizedDescription ?? "Unknown Error")")
            //            alertMsg = error?.localizedDescription ?? "Unknown Error"
            //            alertTrigger.toggle()
        }.resume()
    }
    
    func teamFullName(teamShortName: String) -> (city: String, name: String) {
        return ("","")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FixturesView()
            .environmentObject(Preferences())
    }
}
