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
    
    var body: some View {
        HStack {
            if vm.standingTeamlogoURL == "" {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 25, height: 25, alignment: .center).padding(.leading)
            } else {
                SVGLogo(SVGUrl: vm.standingTeamlogoURL, frameWidth: 25, frameHeight: 25)
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
            vm.fetchStandingTeamLogoURL(teamID: teamID)
        }
    }
    
}

struct StandingsTeamView_Previews: PreviewProvider {
    static var previews: some View {
        StandingsTeamView(teamID: 0, teamName: "__", W: 49, L: 23, backgroundColor: Color(.systemGray6),foregroundColor: Color.black)
            .environmentObject(ViewModel())
    }
}
