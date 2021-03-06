//
//  Preferences.swift
//  NBAStats
//
//  Created by President Raindas on 12/07/2021.
//

import SwiftUI

class Preferences: ObservableObject {
    let colorList = [
        "Blue" : Color(.systemBlue),
        "Brown" : Color(.brown),
        "Green" : Color(.systemGreen),
        "Indigo" : Color(.systemIndigo),
        "Orange" : Color(.systemOrange),
        "Pink" : Color(.systemPink),
        "Purple" : Color(.systemPurple),
        "Red" : Color(.systemRed),
        "Teal" : Color(.systemTeal),
        "Yellow" : Color(.systemYellow),
        "Gray" : Color(.systemGray),
        "Gray 2" : Color(.systemGray2),
        "Gray 3" : Color(.systemGray3),
        "Gray 4" : Color(.systemGray4),
        "Gray 5" : Color(.systemGray5),
        "Gray 6" : Color(.systemGray6)
    ]
    
    let colorListKeys = [
        "Blue","Brown","Green","Indigo","Orange","Pink","Purple","Red","Teal","Yellow","Gray","Gray 2","Gray 3","Gray 4","Gray 5", "Gray 6"
    ]
    
    @Published var favouriteTeamIndex = UserDefaults.standard.integer(forKey: "FavouriteTeamIndex")
    @Published var favouriteTeamID = UserDefaults.standard.integer(forKey: "FavouriteTeamID")
    @Published var accentColor = UserDefaults.standard.string(forKey: "AccentColor") ?? "Gray" //<-- default accent color
    
    var selectedAccentColor: Color {
        return self.colorList[self.accentColor]!
    }
    
    var SegmentedPickerTextColor: UIColor {
        let colors = ["Blue","Brown","Green","Indigo","Orange","Pink","Purple","Red","Teal","Yellow","Gray","Gray 2","Gray 3"]
        if colors.contains(self.accentColor) {
            return UIColor.white
        } else {
            return UIColor.black
        }
    }
    
    var teamCardTextColor: Color {
        let colors = ["Blue","Brown","Green","Indigo","Orange","Pink","Purple","Red","Teal","Yellow","Gray","Gray 2"]
        if colors.contains(self.accentColor) {
            return Color.white
        } else {
            return Color.black
        }
    }
    
    func saveFavouriteTeam(teamIndex: Int, teamID: Int) {
        self.favouriteTeamIndex = teamIndex
        self.favouriteTeamID = teamID
        UserDefaults.standard.set(self.favouriteTeamIndex, forKey: "FavouriteTeamIndex")
        UserDefaults.standard.set(self.favouriteTeamID, forKey: "FavouriteTeamID")
    }
    
    func saveAccentColor(colorName: String) {
        self.accentColor = colorName
        UserDefaults.standard.set(self.accentColor, forKey: "AccentColor")
    }
    
}
