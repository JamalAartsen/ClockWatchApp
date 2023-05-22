//
//  ClockTimer.swift
//  ClockWatchApp
//
//  Created by Jamal Aartsen on 17/05/2023.
//

import Foundation

class ClockTimer: ObservableObject {
    
    private var timer: Timer?
    @Published var currentTime: [Int]?
    
    init() {
        getCurrentTime()
    }
}

extension ClockTimer {
    
    private func createTimeAsArray() -> [Int] {
        let currentDate = Date()
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents([.month, .day, .hour, .minute, .second], from: currentDate)
        
        let hourArray = (dateComponents.hour ?? 0).digitArray()
        let minuteArray = (dateComponents.minute ?? 0).digitArray()
        let secondArray = (dateComponents.second ?? 0).digitArray()
        let monthArray = (dateComponents.month ?? 0).digitArray()
        let dayArray = (dateComponents.day ?? 0).digitArray()
        
        return (hourArray + minuteArray + secondArray + dayArray + monthArray)
    }
    
    func getCurrentTime() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.currentTime = self?.createTimeAsArray()
        }
    }
    
    func stopClockTimer() {
        timer?.invalidate()
        timer = nil
    }
}
