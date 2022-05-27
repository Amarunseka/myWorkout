//
//  DateExtension.swift
//  myWorkout
//
//  Created by Миша on 14.04.2022.
//

import Foundation

extension Date {

    // нам нужно создать локально время, потому, как просто Date() дает время по гринвичу
    func localDate() -> Date {
        // получаем количество секунд отличное от гринвича
        let offSetTimeZone = Double(TimeZone.current.secondsFromGMT(for: self))
        // получаем текущее время путем добавления, разницы от гринвича к текущей дате
        let localDate = Calendar.current.date(byAdding: .second, value: Int(offSetTimeZone), to: self) ?? Date()
        return localDate
    }
    
    
    // получение дней недели с номерами
    func getWeekDaysArray() -> [[String]] {
        let timeZone = TimeZone(abbreviation: "UTC") ?? .current
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.timeZone = timeZone
        // формат отображения дней недели
        formatter.dateFormat = "EEEEEEE"
        
        var weekDaysArray: [[String]] = [[],[]]
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        
        for index in -6...0 {
            let date = calendar.date(byAdding: .day, value: index, to: self) ?? Date()
            let day = calendar.component(.day, from: date)
            weekDaysArray[1].append("\(day)")
            let weekDay = formatter.string(from: date)
            weekDaysArray[0].append(weekDay)
        }
        return weekDaysArray
    }
    
    
    // получаем начало и конец даты при выборе на календаре
    func startEndDate() -> (Date, Date) {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        let calendar = Calendar.current

        let year = calendar.component(.year, from: self)
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        let dateStart = formatter.date(from: "\(year)/\(month)/\(day)") ?? Date()
        
        let localDateStart = dateStart
        
        let dateEnd: Date = {
            let components = DateComponents(hour: 23, minute: 59, second: 59, nanosecond: 99999999)
//            let components = DateComponents(day: 1)

            return calendar.date(byAdding: components, to: localDateStart) ?? Date()
        }()
        return (localDateStart, dateEnd)
    }
    
    
    // метод получения дня недели из переданной даты
    func getWeekdayNumber() -> Int {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC") ?? .current
        let weekday = calendar.component(.weekday, from: self)
        return weekday
    }
    

    // получаем предыдущую дату при выборе на календаре
    func offsetDays(days: Int) -> Date {
        let offsetDays = Calendar.current.date(byAdding: .day, value: -days, to: self) ?? Date()
        return offsetDays
    }
    
    
    // получаем предыдущий месяц
    func offsetMonths(month: Int) -> Date {
        let offsetMonths = Calendar.current.date(byAdding: .month, value: -month, to: self) ?? Date()
        return offsetMonths
    }
    
    
    func ddMMyyyyFromDate() -> String {
        let formater = DateFormatter()
        formater.dateFormat = "yyyy/MM/dd"
        let date = formater.string(from: self)
        return date
    }
}







/*
 func getWeekDaysDictionary() -> [String: Int] {
     
     let formater = DateFormatter()
     formater.locale = Locale(identifier: "en_US")
     formater.dateFormat = "EEEEEE"
     
     var weekDaysDictionary = [String: Int]()
     var calendar = Calendar.current
     calendar.timeZone = TimeZone(abbreviation: "UTC") ?? .current
     
     for index in -6...0 {
         let date = calendar.date(byAdding: .day, value: index, to: self) ?? Date()
         let weekDay = formater.string(from: date)
         let day = calendar.component(.day, from: date)
         weekDaysDictionary[weekDay] = day
     }
     return weekDaysDictionary
 }
 */
