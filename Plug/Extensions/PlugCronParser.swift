//
//  PlugCronParser.swift
//  Plug
//
//  Created by changmin lee on 31/12/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import Foundation


let kDays = ["월", "화", "수", "목", "금", "토", "일"]
class Schedule: NSObject {
    var sMin: String
    var sHour: String
    var eMin: String
    var eHour: String
    var days: String
    //"0-30 9-18 1,3,5,7"
    
    var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    public init(schedule: String) {
        self.sMin = String(schedule.split(separator: " ")[0].split(separator: "-")[0])
        self.sHour = String(schedule.split(separator: " ")[1].split(separator: "-")[0])
        self.eMin = String(schedule.split(separator: " ")[0].split(separator: "-")[1])
        self.eHour = String(schedule.split(separator: " ")[1].split(separator: "-")[1])
        self.days = String(schedule.split(separator: " ")[2])
    }
    
    func toString() -> String {
        return "\(sMin)-\(eMin) \(sHour)-\(eHour) \(days)"
    }
    
    func getStartDate() -> Date? {
        return formatter.date(from: "\(sHour):\(sMin)")
    }
    
    func getEndDate() -> Date? {
        return formatter.date(from: "\(eHour):\(eMin)")
    }
    
    func setStartDate(with date: Date) {
        self.sHour = String(Calendar.current.component(.hour, from: date))
        self.sMin = String(Calendar.current.component(.minute, from: date))
    }
    
    func setEndDate(with date: Date) {
        self.eHour = String(Calendar.current.component(.hour, from: date))
        self.eMin = String(Calendar.current.component(.minute, from: date))
    }
    
    func getDaysString() -> String {
        let arr = days.split(separator: ",")
        let arr2 = arr.map({ kDays[Int($0)! - 1] })
        return arr2.joined(separator: " ")
    }
    
    func setDaysby(arr: [Int]) {
        self.days = arr.map({ "\($0)" }).joined(separator: ",")
    }
}
