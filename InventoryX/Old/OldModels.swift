//
//  OldModels.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/27/23.
//

import SwiftUI
import RealmSwift

class SaleDateManager {
    var calendar: Calendar {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        calendar.firstWeekday = 1
        return calendar
    }
        
    var today: Date {
        return Date()
    }
    
    var startOfToday: Date {
        return self.calendar.startOfDay(for: self.today)
    }
    
    var endOfToday: Date {
        return self.calendar.date(bySettingHour: 23, minute: 59, second: 59, of: self.today)!
    }
    
    var yesterday: Date {
        return self.calendar.date(byAdding: .day, value: -1 , to: self.today)!
    }
    
    var startOfYesterday: Date {
        return self.calendar.startOfDay(for: self.yesterday)
    }
    
    var endOfYesterday: Date {
        return self.calendar.date(bySettingHour: 23, minute: 59, second: 59, of: self.yesterday)!
    }
    
    var thisWeek: [Date] {
        var week: [Date] = []
        if let weekInterval = self.calendar.dateInterval(of: .weekOfYear, for: self.today) {
            for i in 0...6 {
                if let day = self.calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                    week.append(day)
                }
            }
        }
        return week
    }
    
    var startOfThisWeek: Date {
        return self.thisWeek[0]
    }
    
    var endOfThisWeek: Date {
        let lastDay = self.thisWeek[self.thisWeek.count - 1]
        return self.calendar.date(bySettingHour: 23, minute: 59, second: 59, of: lastDay)!
    }
    
    var lastWeek: [Date] {
        let oneWeekAgo: Date = calendar.date(byAdding: .weekOfYear, value: -1, to: self.today)!
        var week: [Date] = []
        if let weekInterval = self.calendar.dateInterval(of: .weekOfYear, for: oneWeekAgo) {
            for i in 0...6 {
                if let day = self.calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                    week.append(day)
                }
            }
        }
        return week
    }
    
    var startOfLastWeek: Date {
        return self.lastWeek[0]
    }
    
    var endOfLastWeek: Date {
        let lastDay = self.lastWeek[self.lastWeek.count - 1]
        return self.calendar.date(bySettingHour: 23, minute: 59, second: 59, of: lastDay)!
    }
}

class Sale: Object {
    @objc dynamic var timestamp: Date = Date()
    var items = RealmSwift.List<SaleItem>()
    @objc dynamic var total: Double = 0.00
}
