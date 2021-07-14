//
//  test.swift
//  NBAStats
//
//  Created by President Raindas on 14/07/2021.
//

import SwiftUI

struct test: View {
    
    @State private var testVal = "__"
    @State private var testVal2 = "__"
    @State private var testVal3 = Date()
    @State private var testVal4 = "__"
    @State private var testVal5 = "__"
    
    var body: some View {
        VStack {
            Text(testVal3, style: .time)
            Text(testVal).font(.title.bold())
            Divider()
            Text(testVal2).font(.title.bold())
            Divider()
            Text(testVal4).font(.title.bold())
            Divider()
            Text(testVal5).font(.title.bold())
            Divider()
            Button("Load Date"){
                loadDate()
            }
        }
    }
    
    private func loadDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd H:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "WAT")
        let date = Date()
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.timeZone = TimeZone(abbreviation: "EST") //TimeZone(abbreviation: TimeZone.current.abbreviation()!)
        dateFormatter2.dateFormat = "yyyy-MM-dd 'T' H:mm:ss"
        
        let timestamp = "2021-07-08T21:00:00"
        let isoFormatter = ISO8601DateFormatter()
        self.testVal3 = isoFormatter.date(from: "\(timestamp)+01:00")!
        
        self.testVal = "W.A.T: \(dateFormatter.string(from: date))"
        self.testVal2 = "E.S.T: \(dateFormatter2.string(from: date))"
        
        let poo = isoFormatter.date(from: "\(timestamp)+01:00")!
        
        self.testVal4 = "WAT: \(dateFormatter.string(from: poo.addingTimeInterval((3600 * 5))))"
        
    }
}

struct test_Previews: PreviewProvider {
    static var previews: some View {
        test()
    }
}
