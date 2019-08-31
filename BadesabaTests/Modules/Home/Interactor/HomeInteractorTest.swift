//
//  HomeInteractorTest.swift
//  BadesabaTests
//
//  Created by Mahdiyar Oraei on 8/27/19.
//  Copyright © 2019 Moj Hamrah. All rights reserved.
//

@testable import Badesaba
import Quick
import Nimble

class HomeInteractorTest: QuickSpec {
    
    private var sut: HomeInteractor!
    private var mockRepository: PrayerTimesUserSettingRepositoryMock!
    private var mockInteractorOutput: InteractorOutputMock!
    
    override func spec() {
        beforeSuite {
            self.mockRepository = PrayerTimesUserSettingRepositoryMock()
            self.mockInteractorOutput = InteractorOutputMock()
            self.sut = HomeInteractor()
            
            self.sut.prayerTimesUserSettingRepository = self.mockRepository
            self.sut.output = self.mockInteractorOutput
        }
        
        describe("Load month(s) use case") {
            let monthOffset = 0
            let monthOffsets = [monthOffset - 2, monthOffset - 1, monthOffset, monthOffset + 1, monthOffset + 2, monthOffset + 3, monthOffset + 4, monthOffset + 5, monthOffset + 6]
            
            let islamicCalender = Calendar(identifier: .islamic)
            let startOfCurrentMonth = islamicCalender.date(from: islamicCalender.dateComponents([.year, .month], from: islamicCalender.startOfDay(for: Date())))!
            let startOfSafar = islamicCalender.date(bySetting: .month, value: 2, of: startOfCurrentMonth)!
            let endOfSafar = islamicCalender.date(byAdding: DateComponents(month: 1, day: -1), to: startOfSafar)!
            
            let safarMonthLength = islamicCalender.dateComponents([.day], from: startOfSafar, to: endOfSafar).day!
            
            let persianHolidays = [[1 : 1], [1 : 2], [1 : 3], [1 : 4], [1 : 12], [1 : 13], [3 : 14], [3 : 15], [11 : 22], [12 : 29]]
            let islamicHolidays = [[1 : 9], [1 : 10], [2 : 20], [2 : 28], [2: safarMonthLength], [3 : 8], [3 : 17], [6 : 3], [7 : 13], [7 : 27], [8 : 15], [9 : 21], [10 : 1], [10 : 2], [10 : 25], [12 : 10], [12 : 18]]
            
            beforeEach {
                self.sut.loadMonths(monthOffsets)
            }
            
            afterEach {
                self.sut.monthsDaysDictionary = [:]
            }
            
            it("Should save this month days to dictionary") {
                monthOffsets.forEach({ (monthOffset) in
                    let calendar = Calendar(identifier: .persian)
                    let today = calendar.startOfDay(for: Date())
                    let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!
                    
                    let startOfOffsetedMonthDate = calendar.date(byAdding: .month, value: monthOffset, to: startOfMonth)!
                    let endOfOffsetedMonthDate = calendar.date(byAdding: DateComponents(month: 1), to: startOfOffsetedMonthDate)!
                    let daysInMonths = calendar.dateComponents([.day], from: startOfOffsetedMonthDate, to: endOfOffsetedMonthDate).day!
                    
                    expect(self.sut.monthsDaysDictionary[monthOffset]!.count)
                        .to(equal(abs(daysInMonths)), description: "Month offset: \(monthOffset), expect did \(abs(daysInMonths)) but is \(self.sut.monthsDaysDictionary[monthOffset]!.count)")
                })
            }
            
            it("Should specify holidays") {
                let persianCalendar = Calendar(identifier: .persian)
                let islamicCalendar = Calendar(identifier: .islamic)
                
                self.sut.monthsDaysDictionary.values.forEach ({ monthsDays in
                    let containingHolidays = monthsDays.keys.filter({ (timestamp) -> Bool in
                        let persianDateComponents = persianCalendar.dateComponents([.month, .day], from: Date(timeIntervalSince1970: timestamp))
                        let persianMonthAndDay = [persianDateComponents.month! : persianDateComponents.day!]
                        
                        let islamicDateComponents = islamicCalendar.dateComponents([.month, .day], from: Date(timeIntervalSince1970: timestamp))
                        let islamicMonthAndDay = [islamicDateComponents.month! : islamicDateComponents.day!]
                        
                        return persianHolidays.contains(persianMonthAndDay) || islamicHolidays.contains(islamicMonthAndDay)
                    })
                    
                    containingHolidays.forEach({ (timestamp) in
                        expect(monthsDays[timestamp])
                            .to(beTrue())
                    })
                    
                    monthsDays.filter({ !containingHolidays.contains($0.key) }).forEach({ (item) in
                        expect(item.value)
                            .to(beFalse())
                    })
                })
            }
        }
        
        describe("Select a day in calendar") {
            context("When user selected a lat, long") {
                var expectedPrayerTimes: [AKPrayerTime.TimeNames : Any]!
                beforeEach {
                    let today = Calendar(identifier: .persian).startOfDay(for: Date())

                    let selectedSetting = try! self.mockRepository.getUserSelectedSetting()
                    let prayerTime = AKPrayerTime(lat: selectedSetting.latLong[0], lng: selectedSetting.latLong[1])
                    prayerTime.calculationMethod = AKPrayerTime.CalculationMethod(rawValue: selectedSetting.algorithm)!
                    prayerTime.calcDate = today
                    
                    expectedPrayerTimes = prayerTime.getPrayerTimes()
                    self.mockInteractorOutput.expectedPrayerTimes = expectedPrayerTimes
                    
                    self.sut.selectDay(timestamp: today.timeIntervalSince1970)
                }
                
                it("Should get user setting from user defaults") {
                    expect(self.mockRepository.isGetUserSelectedSetting)
                        .to(beTrue())
                }
                
                it("Should send computed prayer times to presenter") {
                    expect(self.mockInteractorOutput.isPrayerTimesForSelectedDayCalled)
                        .to(beTrue())
                }
            }
            
            context("When user didn't select any lat, long") {
                beforeEach {
                    self.mockRepository.isShouldThrowError = true
                    let today = Calendar(identifier: .persian).startOfDay(for: Date())
                    
                    self.sut.selectDay(timestamp: today.timeIntervalSince1970)
                }
                
                it("Should tell presenter that couldn't find any selected lat, long") {
                    expect(self.mockInteractorOutput.isCouldNotFindAnySelectedLatLongCalled)
                        .to(beTrue())
                }
            }
        }
        
        afterSuite {
            self.sut = nil
            self.mockRepository = nil
            self.mockInteractorOutput = nil
        }
    }
}

fileprivate class PrayerTimesUserSettingRepositoryMock: PrayerTimesDataProvider {
    var isShouldThrowError = false
    var isGetUserSelectedSetting = false
    
    func getUserSelectedSetting() throws -> PrayerTimesSetting {
        if isShouldThrowError {
            throw FakeError.fake
        }
        
        isGetUserSelectedSetting = true
        
        return PrayerTimesSetting(latLong: [1, 21], algorithm: "ISNA")
    }
    
    func saveSetting(latLong: [Double]) {
        
    }
    
    func saveSetting(algorithm: String) {
        
    }
}

fileprivate class InteractorOutputMock: HomeInteractorOutput {
    var isCouldNotFindAnySelectedLatLongCalled = false
    var isPrayerTimesForSelectedDayCalled = false
    
    var expectedPrayerTimes: [AKPrayerTime.TimeNames : Any]!
    
    func couldNotFindAnySelectedLatLong() {
        isCouldNotFindAnySelectedLatLongCalled = true
    }
    
    func prayerTimesForSelectedDay(prayerTimes: [AKPrayerTime.TimeNames : Any]) {
        isPrayerTimesForSelectedDayCalled = false
        prayerTimes.forEach { (prayTime) in
            isPrayerTimesForSelectedDayCalled = expectedPrayerTimes.filter({ (expectedPrayTime) -> Bool in
                expectedPrayTime.key == prayTime.key
            }).first?.value as! String == prayTime.value as! String
        }
    }
}
