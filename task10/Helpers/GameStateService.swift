//
//  GameStateService.swift
//  task10
//
//  Created for MVVM architecture improvement
//

import Foundation

protocol GameStateServiceProtocol {
    func saveCurrentPlayerIndex(_ index: Int)
    func getCurrentPlayerIndex() -> Int
    func clearGameState()
}

class GameStateService: GameStateServiceProtocol {
    enum UserDefaultsKeys {
        static let currentPlayerIndex = "gameCurrentPlayerIndex"
        static let timerSecondsElapsed = "gameTimerSecondsElapsed"
        static let timerIsRunning = "gameTimerIsRunning"
    }
    
    private let userDefaults = UserDefaults.standard
    
    func saveCurrentPlayerIndex(_ index: Int) {
        userDefaults.set(index, forKey: UserDefaultsKeys.currentPlayerIndex)
        userDefaults.synchronize()
    }
    
    func getCurrentPlayerIndex() -> Int {
        return userDefaults.integer(forKey: UserDefaultsKeys.currentPlayerIndex)
    }
    
    func clearGameState() {
        userDefaults.removeObject(forKey: UserDefaultsKeys.currentPlayerIndex)
        userDefaults.removeObject(forKey: UserDefaultsKeys.timerSecondsElapsed)
        userDefaults.removeObject(forKey: UserDefaultsKeys.timerIsRunning)
        userDefaults.synchronize()
    }
}
