//
//  PrayerTimesUserSettingLocalServiceTesft.swift
//  BadesabaTests
//
//  Created by Mahdiyar Oraei on 8/31/19.
//  Copyright © 2019 Moj Hamrah. All rights reserved.
//
@testable import Badesaba
import Quick
import Nimble

class PrayerTimesUserSettingLocalServiceTest: QuickSpec {
    private var sut: IPrayerTimesUserSettingLocalService!
    
    override func spec() {
        beforeSuite {
            self.sut = IPrayerTimesUserSettingLocalService()
        }
        
        describe("Save selected lat, long") {
            beforeEach {
                self.sut.saveSelectedLatLong(latLong: [1, 21])
            }
            
            it("Should save lat, long to user defaut") {
                expect(UserDefaults.standard.array(forKey: Constants.UserDefaults.userSelectedLatLong) as! [Double])
                    .to(equal([1, 21]))
            }
            
        }
        
        describe("Save user selected algorithm") {
            beforeEach {
                self.sut.saveSelectedAlgorithm(.ISNA)
            }
            
            it("Should save algorithm to user default") {
                expect(UserDefaults.standard.string(forKey: Constants.UserDefaults.userSelectedAlgorithm))
                    .to(equal("ISNA"))
            }
        }
        
        describe("Get selected algorithm") {
            context("When saved algorithm before get") {
                let selectedAlgorithm = AKPrayerTime.CalculationMethod.ISNA
                var selectedAlgorithmString: String!
                
                beforeEach {
                    self.sut.saveSelectedAlgorithm(selectedAlgorithm)
                    selectedAlgorithmString = self.sut.getSelectedAlgorithm()
                }
                
                it("Should get saved algorithm data") {
                    expect(selectedAlgorithmString)
                        .to(equal(selectedAlgorithm.rawValue))
                }
            }
            
            context("When load default value") {
                var selectedAlgorithmString: String!
                
                beforeEach {
                    UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.userSelectedAlgorithm)
                    selectedAlgorithmString = self.sut.getSelectedAlgorithm()
                }
                
                it("Should get saved algorithm data") {
                    expect(selectedAlgorithmString)
                        .to(equal(AKPrayerTime.CalculationMethod.Tehran.rawValue))
                }
            }
        }
        
        describe("Get selected lat, long") {
            context("When saved lat, long before get") {
                var selectedLatLong: [Double]!
                
                beforeEach {
                    self.sut.saveSelectedLatLong(latLong: [1, 21])
                    selectedLatLong = try! self.sut.getSelectedLatLong()
                }
                
                it("Should get saved algorithm data") {
                    expect(selectedLatLong)
                        .to(equal([1, 21]))
                }
            }
            
            context("When load default value") {
                beforeEach {
                    UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.userSelectedLatLong)
                }
                
                it("Should throw error") {
                    expect{ try self.sut.getSelectedLatLong() }.to(throwError())
                }
            }
        }
        
        afterSuite {
            self.sut = nil
        }
    }
}
