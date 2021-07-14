//
//  DateController.swift
//  NBAStats
//
//  Created by President Raindas on 08/07/2021.
//

import Foundation

final class DateController {
    
    let dateFormatter = DateFormatter()
    
    public func toEST(_ currentDate: Date) -> String {
        dateFormatter.timeZone = TimeZone(abbreviation: "EST")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: currentDate)
    }
    
    public func DateTimeStringToDate(dateTime: String) -> Date {
        let isoFormatter = ISO8601DateFormatter()
        return isoFormatter.date(from: "\(dateTime)+01:00")!
    }
    
    public func DateTimeToCurrentTimeZone(dateTime: String) -> Date {
        let formattedDate = DateTimeStringToDate(dateTime: dateTime)
        //dateFormatter.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation()!)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateInCurretTimeZone = dateFormatter.string(from: formattedDate.addingTimeInterval((3600 * 5)))//<-- 5 hours was added (West African Time)
        return dateFormatter.date(from: dateInCurretTimeZone)!
    }
    
    public func gameDay(dateTime: String) -> String {
        // split datetime into two parts
        let datetimeParts = dateTime.components(separatedBy: "T")
        // isolate time from the datetime
        let USEasternTime = datetimeParts[1]
        // split time
        let USEasternTimeParts = USEasternTime.components(separatedBy: ":")
        // hour value
        let USEasternTimeHour = Int(USEasternTimeParts[0])!
        
        if USEasternTimeHour >= 19 {
            return "tomorrow"
        } else {
            return "today"
        }
    }
    
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
