//
//  HomeProtocols.swift
//  Badesaba
//
//  Created by Mahdiyar Oraei on 8/27/19.
//  Copyright © 2019 Moj Hamrah. All rights reserved.
//

protocol LoadMonthUseCase: class {
    func loadMonths(_ monthOffsets: [Int])
    func loadMonth(_ monthOffset: Int)
}

protocol SelectADayUseCase {
    func selectDay(timestamp: Double)
}

protocol HomeInteractorOutput: class {
    func couldNotFindAnySelectedLatLong()
    func prayerTimesForSelectedDay(prayerTimes: [AKPrayerTime.TimeNames : Any])
}

