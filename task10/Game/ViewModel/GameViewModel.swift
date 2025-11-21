//
//  GameViewModel.swift
//  task10
//
//  Created by akote on 12.11.25.
//

import Foundation

class GameViewModel {
    enum Constants {
        static let minScore: Int32 = 0
    }
    
    private var users: [UserModel] = []
    private var turns: [TurnModel] = []
    
    private let userService: UserServiceProtocol
    private let turnService: TurnServiceProtocol
    private let gameStateService: GameStateServiceProtocol
    let timerService: TimerService

    init(
        userService: UserServiceProtocol = UserService(),
        turnService: TurnServiceProtocol = TurnService(),
        gameStateService: GameStateServiceProtocol = GameStateService(),
        timerService: TimerService = TimerService()
    ) {
        self.userService = userService
        self.turnService = turnService
        self.gameStateService = gameStateService
        self.timerService = timerService
        
        setupTimerService()
        loadUsers()
        loadTurns()
    }
    
    deinit {
        timerService.stop()
    }
    
    private func setupTimerService() {
        timerService.delegate = nil
        timerService.stop()
    }
    
    func startTimer() {
        timerService.start()
    }
    
    func pauseTimer() {
        timerService.pause()
    }
    
    func resetTimer() {
        timerService.reset()
        timerService.clearSavedState()
    }
    
    func getTimerSecondsElapsed() -> Int {
        return timerService.secondsElapsed
    }
    
    func getTimerIsRunning() -> Bool {
        return timerService.isRunning
    }
    
    func saveCurrentPlayerIndex(_ index: Int) {
        guard isValidIndex(index) else { return }
        gameStateService.saveCurrentPlayerIndex(index)
    }
    
    func getCurrentPlayerIndex() -> Int {
        let index = gameStateService.getCurrentPlayerIndex()
        return isValidIndex(index) ? index : 0
    }
    
    func clearGameState() {
        gameStateService.clearGameState()
    }
    
    func getUser(at index: Int) -> UserModel? {
        guard isValidIndex(index) else { return nil }
        return users[index]
    }
    
    func getUserName(at index: Int) -> String? {
        return getUser(at: index)?.name
    }
    
    func getUserScore(at index: Int) -> Int32? {
        return getUser(at: index)?.score
    }
    
    func getUserFirstLetter(at index: Int) -> String? {
        return getUser(at: index)?.name.first.map { String($0) }
    }
    
    func getTotalUsers() -> Int {
        return users.count
    }
    
    func getTotalTurns() -> Int {
        return turns.count
    }
    
    func hasUsers() -> Bool {
        return getTotalUsers() > 0
    }
    
    func isValidIndex(_ index: Int) -> Bool {
        return index >= 0 && index < getTotalUsers()
    }
    
    func getNextPlayerIndex(from currentIndex: Int, offset: Int) -> Int? {
        guard hasUsers() else { return nil }
        guard isValidIndex(currentIndex) else { return nil }
        
        let totalUsers = getTotalUsers()
        let newIndex: Int
        if offset > 0 {
            newIndex = (currentIndex + offset) % totalUsers
        } else {
            newIndex = (currentIndex + offset + totalUsers) % totalUsers
        }
        
        return isValidIndex(newIndex) ? newIndex : nil
    }
    
    
    func loadUsers() {
        users = userService.fetchUsersSortedByOrder()
    }
    
    func loadTurns() {
        turns = turnService.fetchTurns()
    }
    
    func updateUser(user: UserModel, newName: String? = nil, newScore: Int32? = nil) {
        let updatedUser = UserModel(
            id: user.id,
            name: newName ?? user.name,
            score: newScore ?? user.score,
            order: user.order
        )
        
        if userService.updateUser(updatedUser) {
            loadUsers()
        }
    }
    
    func increaseScore(for userIndex: Int, on points: Int) {
        guard let user = getUser(at: userIndex) else { return }
        increaseScore(for: user, on: points)
    }
    
    func increaseScore(for user: UserModel, on argument: Int) {
        if user.score + Int32(argument) >= Constants.minScore {
            updateUser(user: user, newScore: user.score + Int32(argument))
            addTurn(name: user.name, score: Int32(argument))
        }
    }
    
    func incrementScore(for userIndex: Int) {
        guard let user = getUser(at: userIndex) else { return }
        incrementScore(for: user)
    }
    
    func incrementScore(for user: UserModel) {
        updateUser(user: user, newScore: user.score + 1)
        addTurn(name: user.name, score: 1)
    }
    
    func undoTurn() -> Int? {
        guard let turn = turns.first else { return nil }
        guard let userIndex = users.firstIndex(where: { $0.name == turn.name }) else { return nil }
        
        guard let user = getUser(at: userIndex) else { return nil }
        updateUser(user: user, newScore: max(Constants.minScore, user.score - turn.score))
        
        if turnService.deleteTurn(with: turn.id) {
            loadTurns()
        }
        return userIndex
    }
    
    func addTurn(name: String, score: Int32) {
        let newTurn = TurnModel(id: nil, name: name, score: score)
        
        if turnService.createTurn(newTurn) {
            loadTurns()
        }
    }
}
