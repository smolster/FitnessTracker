//
//  DateCacher.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/19/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation

public enum DateFormat: Hashable {
    /// M/dd/yyyy
    case mDDYYYY(TimeZone)
    
    /// h:mm a
    case hMMA(TimeZone)
    
    /// M/dd/yyyy h:mm a
    case dateTime(TimeZone)
    
    var formatString: String {
        switch self {
        case .mDDYYYY:  return "M/dd/yyyy"
        case .hMMA:     return "h:mm a"
        case .dateTime: return "M/dd/yyyy h:mm a"
            
        }
    }
    
    var components: Set<Calendar.Component> {
        switch self {
        case .mDDYYYY:  return [.day, .month, .year]
        case .hMMA:     return [.minute, .hour]
        case .dateTime: return [.minute, .hour, .day, .month, .year]
        }
    }
    
    var timeZone: TimeZone {
        switch self {
        case .mDDYYYY(let timeZone):    return timeZone
        case .hMMA(let timeZone):       return timeZone
        case .dateTime(let timeZone):   return timeZone
        }
    }
}

open class DateCacher {
    public static let shared = DateCacher(calendar: .current)
    
    public typealias FormatterCache = [DateFormat: DateFormatter]
    public typealias ResultCache = [DateFormat: (stringCache: [Date: String], dateCache: [String: Date])]
    
    /// Keys are date format strings.
    internal private(set) var formatterCache: FormatterCache = [:]
    internal private(set) var resultCache: ResultCache = [:]
    
    private let calendar: Calendar
    
    public init(calendar: Calendar = .current) {
        self.calendar = calendar
    }
    
    open func date(from string: String, using format: DateFormat) -> Date? {
        if let cachedResult = resultCache[format]?.dateCache[string] {
            return cachedResult
        }
        
        guard let date = formatter(for: format).date(from: string) else {
            return nil
        }
        
        let dateToReturn = simplifiedDate(for: date, using: format)
        cache((string, dateToReturn), for: format)
        
        return dateToReturn
    }
    
    open func string(from date: Date, using format: DateFormat) -> String {
        let date = simplifiedDate(for: date, using: format)
        
        if let cachedResult = resultCache[format]?.stringCache[date] {
            return cachedResult
        }
        
        let string = formatter(for: format).string(from: date)
        cache((string, date), for: format)
        return string
    }
    
    internal func formatter(for format: DateFormat) -> DateFormatter {
        if formatterCache[format] == nil {
            formatterCache[format] = DateFormatter(format: format)
        }
        return formatterCache[format]!
    }
    
    internal func simplifiedDate(for date: Date, using format: DateFormat) -> Date {
        let dateComponents = calendar.dateComponents(format.components, from: date)
        return calendar.date(from: dateComponents)!
    }
    
    internal func cache(_ pair: (string: String, date: Date), for format: DateFormat) {
        if resultCache[format] == nil {
            resultCache[format] = ([:], [:])
        }
        resultCache[format]!.dateCache[pair.string] = pair.date
        resultCache[format]!.stringCache[pair.date] = pair.string
    }
}

private extension DateFormatter {
    convenience init(format: DateFormat) {
        self.init()
        self.dateFormat = format.formatString
        self.timeZone = format.timeZone
    }
}
