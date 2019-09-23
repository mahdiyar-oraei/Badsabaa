//
//  HomeInteractor.swift
//  Badesaba
//
//  Created by Mahdiyar Oraei on 8/27/19.
//  Copyright © 2019 Moj Hamrah. All rights reserved.
//
import Foundation


class HomeInteractor {
    weak var output: HomeInteractorOutput?
    var prayerTimesUserSettingRepository: PrayerTimesDataProvider!
    // Save requested days of months in formatt of [offset : timestamp] since get occasions of them
    var monthsDaysDictionary: [Int : [TimeInterval : Bool]] = [:]
    
    private let persianHolidays = [[1 : 1], [1 : 2], [1 : 3], [1 : 4], [1 : 12], [1 : 13], [3 : 14], [3 : 15], [11 : 22], [12 : 29]]
    private var islamicHolidays: [[Int : Int]] {
        get {
            let islamicCalender = Calendar(identifier: .islamic)
            let startOfCurrentMonth = islamicCalender.date(from: islamicCalender.dateComponents([.year, .month], from: islamicCalender.startOfDay(for: Date())))!
            let startOfSafar = islamicCalender.date(bySetting: .month, value: 2, of: startOfCurrentMonth)!
            let endOfSafar = islamicCalender.date(byAdding: DateComponents(month: 1, day: -1), to: startOfSafar)!
            
            let safarMonthLength = islamicCalender.dateComponents([.day], from: startOfSafar, to: endOfSafar).day!
            
            let holidays = [[1 : 9], [1 : 10], [2 : 20], [2 : 28], [2: safarMonthLength], [3 : 8], [3 : 17], [6 : 3], [7 : 13], [7 : 27], [8 : 15], [9 : 21], [10 : 1], [10 : 2], [10 : 25], [12 : 10], [12 : 18]]
            
            return holidays
        }
    }
}

extension HomeInteractor: LoadMonthUseCase {
    func loadMonths(_ monthOffsets: [Int]) {
        monthOffsets.forEach { (monthOffset) in
            loadMonth(monthOffset)
        }
    }
    
    func loadMonth(_ monthOffset: Int) {
        let persianCalendar = Calendar(identifier: .persian)
        let today = persianCalendar.startOfDay(for: Date())
        let startOfMonth = persianCalendar.date(from: persianCalendar.dateComponents([.year, .month], from: today))!
        
        let startOfOffsetedMonthDate = persianCalendar.date(byAdding: .month, value: monthOffset, to: startOfMonth)!
        let endOfOffsetedMonthDate = persianCalendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfOffsetedMonthDate)!
        
        let islamicCalendar = Calendar(identifier: .islamic)
        
        var daysTimestamp: [TimeInterval : Bool] = [:]
        
        let distanceInDays = persianCalendar.dateComponents([.day], from: startOfOffsetedMonthDate, to: endOfOffsetedMonthDate).day!
        
        for i in 0...Int(distanceInDays) {
            let timestamp = startOfOffsetedMonthDate.timeIntervalSince1970 + Double(i * (24 * 60 * 60))
            
            let persianDateComponents = persianCalendar.dateComponents([.month, .day], from: Date(timeIntervalSince1970: timestamp))
            let persianMonthAndDay = [persianDateComponents.month! : persianDateComponents.day!]
            
            let islamicDateComponents = islamicCalendar.dateComponents([.month, .day], from: Date(timeIntervalSince1970: timestamp))
            let islamicMonthAndDay = [islamicDateComponents.month! : islamicDateComponents.day!]
            
            daysTimestamp[timestamp] = persianHolidays.contains(persianMonthAndDay) || islamicHolidays.contains(islamicMonthAndDay)
        }
        
        monthsDaysDictionary[monthOffset] = daysTimestamp
    }
}

extension HomeInteractor: SelectADayUseCase {
    func selectDay(timestamp: Double) {
        do {
            let selectedDay = Date(timeIntervalSince1970: timestamp)
            let selectedSetting = try prayerTimesUserSettingRepository.getUserSelectedSetting()
            
            let prayerTime = AKPrayerTime(lat: selectedSetting.latLong[0], lng: selectedSetting.latLong[1])
            prayerTime.calculationMethod = AKPrayerTime.CalculationMethod(rawValue: selectedSetting.algorithm)!
            prayerTime.calcDate = selectedDay
            
            let prayerTimes = prayerTime.getPrayerTimes()
            
            self.output?.prayerTimesForSelectedDay(prayerTimes: prayerTimes!)
        } catch {
            self.output?.couldNotFindAnySelectedLatLong()
        }
    }
}
