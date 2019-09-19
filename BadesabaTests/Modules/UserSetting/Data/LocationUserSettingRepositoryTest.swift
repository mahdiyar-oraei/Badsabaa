//
//  LocationUserSettingRepositoryTest.swift
//  BadesabaTests
//
//  Created by Macintosh on 9/19/19.
//  Copyright © 2019 Moj Hamrah. All rights reserved.
//

import Quick
import Nimble
@testable import Badesaba

class LocationUserSettingRepositoryTest: QuickSpec {
    private var sut: LocationUserSettingRepository!
    private var locationUserSettingLocalService: LocationUserSettingLocalServiceMock!
        
    override func spec() {
        beforeSuite {
            self.locationUserSettingLocalService = LocationUserSettingLocalServiceMock()
            self.sut = LocationUserSettingRepository()
            self.sut.localService = self.locationUserSettingLocalService
        }
        
        describe("Request selected cities history") {
            context("When local service didn't throw any error") {
                beforeEach {
                    self.locationUserSettingLocalService.throwError = false
                    let _ = try! self.sut.getSelectedCitiesHistory()
                }
                
                it("Should request cities from local data manager") {
                    expect(self.locationUserSettingLocalService.isGetSelectedCitiesHistoryCalled)
                        .to(beTrue())
                }
            }
            
            context("When local service throw an error") {
                beforeEach {
                    self.locationUserSettingLocalService.throwError = true
                }
                
                it("Should throw errpr") {
                    expect{ try self.sut.getSelectedCitiesHistory() }
                        .to(throwError(GeneralError.notNil))
                }
            }

        }
        
        afterSuite {
            self.sut = nil
            self.locationUserSettingLocalService = nil
        }
    }
}

class LocationUserSettingLocalServiceMock: LocationUserSettingLocalService {
    var isGetSelectedCitiesHistoryCalled = false
    var throwError = false
    
    func getSelectedCitiesHistory() throws -> [City] {
        isGetSelectedCitiesHistoryCalled = true
        
        if throwError {
            throw GeneralError.notNil
        }
        
        return []
    }
}
