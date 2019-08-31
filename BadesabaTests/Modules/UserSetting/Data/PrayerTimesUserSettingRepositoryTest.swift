//
//  PrayerTimesUserSettingRepositoryTest.swift
//  BadesabaTests
//
//  Created by Mahdiyar Oraei on 8/31/19.
//  Copyright © 2019 Moj Hamrah. All rights reserved.
//
@testable import Badesaba
import Quick
import Nimble

class PrayerTimesUserSettingRepositoryTest : QuickSpec {
    private var sut: PrayerTimesUserSettingRepository!
    private var localServiceMock: LocalServiceMock!
    
    override func spec() {
        beforeSuite {
            self.sut = PrayerTimesUserSettingRepository()
            self.localServiceMock = LocalServiceMock()
            
            self.sut.localService = self.localServiceMock
        }
        
        describe("Get setting") {
            context("Without throwing error") {
                beforeEach {
                    try! self.sut.getUserSelectedSetting()
                }
                
                it("Should get selected lat, long from local data service") {
                    expect(self.localServiceMock.isGetSelectedLatLong)
                        .to(beTrue())
                }
                
                it("Should get selected algorithm") {
                    expect(self.localServiceMock.isGetSelectedAlgoritm)
                        .to(beTrue())
                }
            }
            
            context("With throwing error") {
                beforeEach {
                    self.localServiceMock.throwError = true
                }
                
                it("Should get selected lat, long from local data service") {
                    expect {try self.sut.getUserSelectedSetting() }                        .to(throwError())
                }
            }
        }
        
        afterSuite {
            self.sut = nil
        }
    }
}

fileprivate class LocalServiceMock: IPrayerTimesUserSettingLocalService {
    var throwError = false
    
    var isGetSelectedLatLong = false
    var isGetSelectedAlgoritm = false
    
    func saveSelectedAlgorithm(_ algorithm: AKPrayerTime.CalculationMethod) {
        
    }
    
    func saveSelectedLatLong(latLong: [Double]) {
        
    }
    
    func getSelectedLatLong() throws -> [Double] {
        if throwError {
            throw FakeError.fake
        }
        
        isGetSelectedLatLong = true
        
        return []
    }
    
    func getSelectedAlgorithm() -> String {
        isGetSelectedAlgoritm = true
        
        return ""
    }
    
    enum FakeError: Error {
        case fake
    }
}
