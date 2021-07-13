//
//  DateController.swift
//  NBAStats
//
//  Created by President Raindas on 08/07/2021.
//

import Foundation

final class DateController {
    
    public func to12HoursWAT(USEasternDateTime: String) -> String {
        // datetime format -> 2021-07-08T21:00:00
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        // split datetime into two parts
        let datetimeParts = USEasternDateTime.components(separatedBy: "T")
        // isolate time from the datetime
        let USEasternTime = datetimeParts[1]
        // split time
        let USEasternTimeParts = USEasternTime.components(separatedBy: ":")
        
        // hour value
        var USEasternTimeHour = Int(USEasternTimeParts[0])
        
        // convert hour value to 12 hours
        if USEasternTimeHour! > 12 {
            USEasternTimeHour = (USEasternTimeHour! - 12) + 5
        }
        
        // check if it exceeds 24 hours due to the fact that we added 5 hours
        if USEasternTimeHour! > 12 {
            USEasternTimeHour = USEasternTimeHour! - 12
        }
        
        // decide when
        var when = "today"
        // compare dates
        if formatter.string(from: Date().addingTimeInterval(-(3600 * 5))) != datetimeParts[0] { when = "tomorrow" }
        
        return "\(USEasternTimeHour!):\(USEasternTimeParts[1]) \(USEasternTimeHour! > 12 ? "pm" : "am") \(when) (West African Time)"
        
    }
    
    public func to12HoursEST(USEasternDateTime: String) -> String {
        // datetime format -> 2021-07-08T21:00:00
        
        // split datetime into two parts
        let datetimeParts = USEasternDateTime.components(separatedBy: "T")
        // isolate time from the datetime
        let USEasternTime = datetimeParts[1]
        // split time
        let USEasternTimeParts = USEasternTime.components(separatedBy: ":")
        
        // hour value
        var USEasternTimeHour = Int(USEasternTimeParts[0])
        
        // convert hour value to 12 hours
        if USEasternTimeHour! > 12 {
            USEasternTimeHour = USEasternTimeHour! - 12
        }
        
        return "\(USEasternTimeHour!):\(USEasternTimeParts[1]) \(Int(USEasternTimeParts[0])! > 12 ? "pm" : "am") today (Eastern Standard Time)"
    }
}
