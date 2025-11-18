//
//  TimerService.swift
//  task10
//
//  Created by akote on 6.11.25.
//

import Foundation

protocol TimerServiceDelegate: AnyObject {
    func timerDidUpdate(secondsElapsed: Int)
    func timerDidChangeState(isRunning: Bool)
}

class TimerService {
    weak var delegate: TimerServiceDelegate?
    
    private var timer: Timer?
    private(set) var secondsElapsed = 0
    private(set) var isRunning = false
    
    private let userDefaults = UserDefaults.standard
    
    enum UserDefaultsKeys {
        static let secondsElapsed = "gameTimerSecondsElapsed"
        static let isRunning = "gameTimerIsRunning"
    }
    
    init() {
        loadState()
    }
    
    func start() {
        guard !isRunning else { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.secondsElapsed += 1
            self.saveState()
            self.delegate?.timerDidUpdate(secondsElapsed: self.secondsElapsed)
        }
        
        isRunning = true
        saveState()
        delegate?.timerDidChangeState(isRunning: true)
    }
    
    func pause() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        saveState()
        delegate?.timerDidChangeState(isRunning: false)
    }
    
    func reset() {
        pause()
        secondsElapsed = 0
        saveState()
        delegate?.timerDidUpdate(secondsElapsed: 0)
    }
    
    func stop() {
        pause()
    }
    
    private func saveState() {
        userDefaults.set(secondsElapsed, forKey: UserDefaultsKeys.secondsElapsed)
        userDefaults.set(isRunning, forKey: UserDefaultsKeys.isRunning)
        userDefaults.synchronize()
    }
    
    private func loadState() {
        secondsElapsed = userDefaults.integer(forKey: UserDefaultsKeys.secondsElapsed)
        isRunning = userDefaults.bool(forKey: UserDefaultsKeys.isRunning)
    }
    
    func clearSavedState() {
        userDefaults.removeObject(forKey: UserDefaultsKeys.secondsElapsed)
        userDefaults.removeObject(forKey: UserDefaultsKeys.isRunning)
        userDefaults.synchronize()
    }
    
    deinit {
        timer?.invalidate()
    }
}

