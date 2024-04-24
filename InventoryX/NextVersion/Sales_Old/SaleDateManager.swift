////
////  OldModels.swift
////  InventoryX
////
////  Created by Smetana, Ryan on 4/27/23.
////
//
//import SwiftUI
//import RealmSwift
//
//enum DateRanges: String, CaseIterable, Identifiable {
//    var id: UUID {
//        return UUID()
//    }
//    
//    case today = "Today"
//    case yesterday = "Yesterday"
//    case thisWeek = "This Week"
//    case lastWeek = "Last Week"
//    
//    var calendar: Calendar {
//        var calendar = Calendar.current
//        calendar.timeZone = TimeZone(abbreviation: "EDT")!
//        calendar.firstWeekday = 1
//        return calendar
//    }
//
//    var startOfToday: Date {
//        return calendar.startOfDay(for: Date())
//    }
//    
//    var endOfToday: Date {
//        return calendar.date(bySettingHour: 23, minute: 59, second: 59, of: Date())!
//    }
//    
//    var yesterday: Date {
//        return calendar.date(byAdding: .day, value: -1 , to: Date())!
//    }
//    
//    var startOfYesterday: Date {
//        return calendar.startOfDay(for: yesterday)
//    }
//    
//    var endOfYesterday: Date {
//        return self.calendar.date(bySettingHour: 23, minute: 59, second: 59, of: self.yesterday)!
//    }
//    
//    var thisWeek: [Date] {
//        var week: [Date] = []
//        if let weekInterval = self.calendar.dateInterval(of: .weekOfYear, for: Date()) {
//            for i in 0...6 {
//                if let day = self.calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
//                    week.append(day)
//                }
//            }
//        }
//        return week
//    }
//    
//    var startOfThisWeek: Date {
//        return self.thisWeek[0]
//    }
//    
//    var endOfThisWeek: Date {
//        let lastDay = self.thisWeek[self.thisWeek.count - 1]
//        return self.calendar.date(bySettingHour: 23, minute: 59, second: 59, of: lastDay)!
//    }
//    
//    var lastWeek: [Date] {
//        let oneWeekAgo: Date = calendar.date(byAdding: .weekOfYear, value: -1, to: Date())!
//        var week: [Date] = []
//        if let weekInterval = self.calendar.dateInterval(of: .weekOfYear, for: oneWeekAgo) {
//            for i in 0...6 {
//                if let day = self.calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
//                    week.append(day)
//                }
//            }
//        }
//        return week
//    }
//    
//    var startOfLastWeek: Date {
//        return self.lastWeek[0]
//    }
//    
//    var endOfLastWeek: Date {
//        let lastDay = self.lastWeek[self.lastWeek.count - 1]
//        return self.calendar.date(bySettingHour: 23, minute: 59, second: 59, of: lastDay)!
//    }
//
//    var realmPredicateForRange: NSPredicate {
//        switch self {
//        case .today:
//            return NSPredicate(format: "timestamp BETWEEN {%@, %@}", startOfToday as NSDate, endOfToday as NSDate)
//        case .yesterday:
//            return NSPredicate(format: "timestamp BETWEEN {%@, %@}", startOfYesterday as NSDate, endOfYesterday as NSDate)
//        case .lastWeek:
//            return NSPredicate(format: "timestamp BETWEEN {%@, %@}", startOfLastWeek as NSDate, endOfLastWeek as NSDate)
//        case .thisWeek:
//            return NSPredicate(format: "timestamp BETWEEN {%@, %@}", startOfThisWeek as NSDate, endOfThisWeek as NSDate)
//        }
//    }
//}
