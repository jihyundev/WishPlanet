//
//  DateHelper.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/05/16.
//

import Foundation

public class DateHelper {
    
    public static let dateformatter: DateFormatter = {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        return dateformatter
    }()
    
    public class func date(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, seconds: Int = 0) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: "\(year)-\(month)-\(day) \(hour):\(minute):\(seconds)")
    }
    
    public class func dateAfter(years: Int, from baseDate: Date) -> Date? {
        let yearsToAdd = years
        var dateComponents = DateComponents()
        dateComponents.year = yearsToAdd
        return Calendar.current.date(byAdding: dateComponents, to: baseDate)
    }
    
    public class func switchDateformat(dateString: String) -> String {
        let date = self.dateformatter.date(from: dateString) ?? Date()
        let newDateformatter = DateFormatter()
        newDateformatter.dateFormat = "yyyy.MM.dd"
        return newDateformatter.string(from: date)
    }
    
    
    public class func numberOfDaysBetween(fromDateString: String, toDateString: String) -> Int {
        let fromDate = self.dateformatter.date(from: fromDateString) ?? Date()
        let toDate = self.dateformatter.date(from: toDateString)
        if let interval = toDate?.timeIntervalSince(fromDate) {
            return Int(interval / 86400)
        } else {
            return 0
        }
    }
    
}
