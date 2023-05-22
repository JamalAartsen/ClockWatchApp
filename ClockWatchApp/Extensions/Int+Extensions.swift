//
//  Int+Extensions.swift
//  ClockWatchApp
//
//  Created by Jamal Aartsen on 17/05/2023.
//

import Foundation

extension Int {
    func digitArray() -> [Int] {
        let paddedString = String(format: "%02d", self)
        return Array(paddedString).compactMap{ Int(String($0)) }
    }
}
