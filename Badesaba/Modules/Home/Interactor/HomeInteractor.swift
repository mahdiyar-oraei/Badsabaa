//
//  HomeInteractor.swift
//  Badesaba
//
//  Created by Mahdiyar Oraei on 8/27/19.
//  Copyright © 2019 Moj Hamrah. All rights reserved.
//
import Foundation


class HomeInteractor {
    typealias Timestamp = Double
    
    // Save requested days of months in formatt of [offset : timestamp] since get occasions of them
    var monthsDaysDictionary: [Int : [Timestamp : Bool]] = [:]
}

extension HomeInteractor: LoadMonthUseCase {
    func loadMonths(_ monthOffsets: Int...) {
        monthOffsets.forEach { (monthOffset) in
            loadMonth(monthOffset)
        }
    }
    
    func loadMonth(_ monthOffset: Int) {
        let calendar = Calendar(identifier: .persian)
        let today = calendar.startOfDay(for: Date())
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: today)))!
        
        let startOfOffsetedMonthDate = calendar.date(byAdding: .month, value: monthOffset, to: startOfMonth)!
        let endOfOffsetedMonthDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
        
        var daysTimestamp: [Timestamp : Bool] = [:]
        for timestamp in stride(from: startOfOffsetedMonthDate.timeIntervalSince1970, to: endOfOffsetedMonthDate.timeIntervalSince1970, by: (24 * 60 * 60)) {
            daysTimestamp[timestamp] = false
        }
        
        monthsDaysDictionary[monthOffset] = daysTimestamp
    }
}
