//
//  Models.swift
//  NBAStats
//
//  Created by President Raindas on 08/07/2021.
//

import Foundation

struct Teams: Decodable {
    var TeamID: Int
    var Key: String
    var City: String
    var Name: String
    var WikipediaLogoUrl: String
}

struct Fixtures: Decodable {
    var GameID: Int
    var DateTime: String
    var AwayTeam: String
    var HomeTeam: String
    var AwayTeamScore: Int?
    var HomeTeamScore: Int?
    var Status: String
    var AwayTeamID: Int
    var HomeTeamID: Int
}

struct Standings: Decodable {
    var TeamID: Int
    var Name: String
    var Conference: String
    var Wins: Int
    var Losses: Int
}
