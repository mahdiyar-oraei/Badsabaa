//
//  UserSettingInteractorTest.swift
//  BadesabaTests
//
//  Created by Macintosh on 9/19/19.
//  Copyright © 2019 Moj Hamrah. All rights reserved.
//

import Quick
import Nimble
@testable import Badesaba

class UserSettingInteractorTest: QuickSpec {
    private var sut: UserSettingInteractor!
    private var locationRepositoryMock: RepositoryMock!
    private var interactorOutputMock: InteractorOutputMock!
    
    override func spec() {
        beforeSuite {
            self.locationRepositoryMock = RepositoryMock()
            self.interactorOutputMock = InteractorOutputMock()
            self.sut = UserSettingInteractor()
            
            self.sut.locationRepository = self.locationRepositoryMock
            self.sut.output = self.interactorOutputMock
        }
        
        describe("Get selected cities history") {
            context("When didn't throw any error") {
                beforeEach {
                    self.locationRepositoryMock.throwError = false
                    let _ = self.sut.getCities()
                }
                
                it("Should request cities from repository") {
                    expect(self.locationRepositoryMock.isGetSelectedCitiesHistoryCalled)
                        .to(beTrue())
                }
                
                it("Should pass fetched cities to output") {
                    expect(self.interactorOutputMock.isPassCitiesToOutput)
                        .to(beTrue())
                }
            }
            
            context("When throw an error") {
                beforeEach {
                    self.locationRepositoryMock.throwError = true
                    let _ = self.sut.getCities()
                }
                
                it("Should tell presenter that database error occured") {
                    expect(self.interactorOutputMock.isErrorPassedToOutput)
                        .to(beTrue())
                }
            }
        }
        
        afterSuite {
            self.sut = nil
        }
    }
}

fileprivate class RepositoryMock: LocationDataProvider {
    var isGetSelectedCitiesHistoryCalled = false
    var throwError = false
    
    func getSelectedCitiesHistory() throws -> [CityModel] {
        isGetSelectedCitiesHistoryCalled = true
        
        if throwError {
            throw GeneralError.notNil
        }
        
        return []
    }
}

fileprivate class InteractorOutputMock: UserSettingInteractorOutput {
    var isPassCitiesToOutput = false
    var isErrorPassedToOutput = false
    
    func citiesDidLoad(_ models: [CityModel]) {
        isPassCitiesToOutput = true
    }
    
    func citiesLoadFailed(_ error: Error) {
        isErrorPassedToOutput = true
    }
}
