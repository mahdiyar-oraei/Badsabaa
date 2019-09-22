//
//  UserSettingPresenterTest.swift
//  BadesabaTests
//
//  Created by Macintosh on 9/19/19.
//  Copyright © 2019 Moj Hamrah. All rights reserved.
//

import Quick
import Nimble
@testable import Badesaba

class UserSettingPresenterTest: QuickSpec {
    private var sut: UserSettingPresenter!
    private var viewMock: ViewMock!
    private var interactorMock: InteractorMock!
    
    override func spec() {
        beforeSuite {
            self.sut = UserSettingPresenter()
            self.viewMock = ViewMock()
            self.interactorMock = InteractorMock()
            
            self.sut.view = self.viewMock
            self.sut.interactor = self.interactorMock
        }
        
        describe("Selected cities history") {
            beforeEach {
                self.sut.citiesDidLoad([])
            }
            
            it("Should tell view to show cities") {
                expect(self.viewMock.isShowSelectedCitiesHistoryCalled)
                    .to(beTrue())
            }
        }
        
        describe("When get selected cities failed") {
            beforeEach {
                self.sut.citiesLoadFailed(GeneralError.notNil)
            }
            
            it("Should show error alert") {
                expect(self.viewMock.isErrorHasShown)
                    .to(beTrue())
            }
        }
        
        describe("View did load") {
            beforeEach {
                self.sut.viewDidLoad()
            }
            
            it("Should request cities from interactor") {
                expect(self.interactorMock.isGetCitiesCalled)
                    .to(beTrue())
            }
        }
        
        afterSuite {
            self.sut = nil
            self.viewMock = nil
        }
    }
}

fileprivate class ViewMock: UserSettingLocationView {
    var isShowSelectedCitiesHistoryCalled = false
    var isErrorHasShown = false
    
    func showSelectedCitiesHistory(_ cities: [CityModel]) {
        isShowSelectedCitiesHistoryCalled = true
    }
    
    func showErrorAlert(message: String) {
        isErrorHasShown = true
    }
}

fileprivate class InteractorMock: UserSettingInteractorType {
    var isGetCitiesCalled = false
    
    func getCities() {
        isGetCitiesCalled = true
    }
}
