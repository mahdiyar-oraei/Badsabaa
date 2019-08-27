//
//  StringExtension.swift
//  Badesaba
//
//  Created by Mahdiyar Oraei on 8/27/19.
//  Copyright © 2019 Moj Hamrah. All rights reserved.
//
import Foundation

extension String {
    func localized() -> String {
        if let path = Bundle.main.path(forResource: AppDelegate.language, ofType: "lproj") {
            if let bundle = Bundle(path: path) {
                return NSLocalizedString(self, tableName: "Localized", bundle: bundle, comment: "")
            }
        }
        // TODO: Should tell someone that this string hadn't any localized value
        return ""
    }
}
