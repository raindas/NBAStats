//
//  FixtureCard.swift
//  NBAStats
//
//  Created by President Raindas on 07/07/2021.
//

import SwiftUI

struct FixtureCard: View {
    
    @EnvironmentObject var preferences:Preferences
    @EnvironmentObject var vm:ViewModel
    
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
                    if vm.homeTeamLogoUrl == "" {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 50, height: 50, alignment: .center)
                    } else {
                        //RemoteImage(url: homeTeamLogoUrl)
                        SVGLogo(SVGUrl: vm.homeTeamLogoUrl, frameWidth: 50, frameHeight: 50)
                            .frame(width: 50, height: 50, alignment: .center)
                    }
                    //Image(systemName: "photo")
                    
                    Group {
                        Text(gameStatus == "Scheduled" ? "" : String(homeTeamScore))
                            .font(.title.bold())
                        Text(vm.homeTeamCity)
                            .font(.title3)
                        Text(vm.homeTeamName)
                            .font(.title3)
                    }.foregroundColor(self.textForegroundColor)
                }
                
                Spacer()
                
                Text("VS")
                    .font(.largeTitle.bold())
                    .foregroundColor(self.textForegroundColor)
                
                Spacer()
                
                VStack {
                    if vm.awayTeamLogoUrl == "" {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 50, height: 50, alignment: .center)
                    } else {
                        //RemoteImage(url: homeTeamLogoUrl)
                        SVGLogo(SVGUrl: vm.awayTeamLogoUrl, frameWidth: 50, frameHeight: 50)
                            .frame(width: 50, height: 50, alignment: .center)
                    }
                    
                    Group {
                        Text(gameStatus == "Scheduled" ? "" : String(awayTeamScore))
                            .font(.title.bold())
                        Text(vm.awayTeamCity)
                            .font(.title3)
                        Text(vm.awayTeamName)
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
            vm.fetchTeamDetails(homeTeamID: homeTeamID, awayTeamID: awayTeamID)
        }
    }
}

struct FixtureCard_Previews: PreviewProvider {
    static var previews: some View {
        FixtureCard(fixtureDaySelection: .constant(""), homeTeam: "--", awayTeam: "--", homeTeamScore: 0, awayTeamScore: 0, gameTime: "2021-07-08T21:00:00", gameStatus: "--", awayTeamID: 0, homeTeamID: 0)
            .environmentObject(Preferences())
            .environmentObject(ViewModel())
    }
}
