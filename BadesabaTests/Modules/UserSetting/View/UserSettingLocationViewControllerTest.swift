//
//  UserSettingLocationViewControllerTest.swift
//  BadesabaTests
//
//  Created by Macintosh on 9/22/19.
//  Copyright © 2019 Moj Hamrah. All rights reserved.
//

import Quick
import Nimble
@testable import Badesaba

class UserSettingLocationViewControllerTest: QuickSpec {
    
    private var sut: UserSettingLocationViewController!
    private var presenter: PresenterMock!
    
    override func spec() {
        beforeSuite {
            self.presenter = PresenterMock()
            
            self.sut = UserSettingLocationViewController()
            self.sut.presenter = self.presenter
        }
        
        describe("View did load") {
            beforeEach {
                self.sut.viewDidLoad()
            }
            
            it("Should tell presenter about view load has finish") {
                expect(self.presenter.isViewDidLoad)
                    .to(beTrue())
            }
        }
        
        describe("On add city tapped") {
            beforeEach {
                self.sut.onAddTapped()
            }
            
            it("Should tell presenter that add city tapped") {
                expect(self.presenter.isOnAddCityTappedCalled)
                    .to(beTrue())
            }
        }
        
        afterSuite {
            self.sut = nil
        }
    }
}

fileprivate class PresenterMock: UserSettingLocationPresentation {
    var isViewDidLoad = false
    var isOnAddCityTappedCalled = false
    
    func onAddCityTapped() {
        self.isOnAddCityTappedCalled = true
    }
    
    func viewDidLoad() {
        self.isViewDidLoad = true
    }
}
