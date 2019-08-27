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
    
    override func spec() {
        beforeSuite {
            self.sut = HomeInteractor()
        }
        
        describe("Load month(s) use case") {
            let monthOffset = 0
            let monthOffsets = [monthOffset - 1, monthOffset, monthOffset + 1]
            
            beforeEach {
                self.sut.loadMonths(monthOffset - 1, monthOffset, monthOffset + 1)
            }
            
            it("Should save this month days to dictionary") {
                monthOffsets.forEach({ (monthOffset) in
                    let calendar = Calendar(identifier: .persian)
                    let today = calendar.startOfDay(for: Date())
                    let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: today)))!
                    
                    let startOfOffsetedMonthDate = calendar.date(byAdding: .month, value: monthOffset, to: startOfMonth)!
                    let endOfOffsetedMonthDate = calendar.date(byAdding: DateComponents(month: 1), to: startOfMonth)!
                    let daysInMonths = calendar.dateComponents([.day], from: startOfOffsetedMonthDate, to: endOfOffsetedMonthDate).day!
                    
                    expect(self.sut.monthsDaysDictionary[monthOffset]!.count)
                        .to(equal(daysInMonths))
                })
            }
        }
        
        afterSuite {
            self.sut = nil
        }
    }
}
