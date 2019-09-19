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
    
    override func spec() {
        beforeSuite {
            self.sut = UserSettingInteractor()
        }
        
        
        
        afterSuite {
            self.sut = nil
        }
    }
}
