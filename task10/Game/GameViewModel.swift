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
    
    var users: [UserModel] = []
    var turns: [TurnModel] = []
    var errorMessage: String? = nil
    
    private let userService: UserServiceProtocol
    private let turnService: TurnServiceProtocol

    init(userService: UserServiceProtocol = UserService(), turnService: TurnServiceProtocol = TurnService()) {
        self.userService = userService
        self.turnService = turnService
        loadUsers()
        loadTurns()
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
            errorMessage = nil
        } else {
            errorMessage = "Failed to update user"
        }
    }
    
    func addTurn(name: String, score: Int32) {
        let newTurn = TurnModel(id: nil, name: name, score: score)
        
        if turnService.createTurn(newTurn) {
            loadTurns()
            errorMessage = nil
        } else {
            errorMessage = "Failed to create turn"
        }
    }
    
    func undoTurn() -> Int {
        guard let turn = turns.first else { return 0}
        guard let userIndex = users.firstIndex(where: { $0.name == turn.name }) else { return 0}
        
        updateUser(user: users[userIndex], newScore: max(Constants.minScore, users[userIndex].score - turn.score))
        if turnService.deleteTurn(with: turn.id) {
            loadTurns()
            
            errorMessage = nil
        } else {
            errorMessage = "Failed to delete turn"
        }
        return userIndex
    }
    
    func increaseScore(for user: UserModel, on argument: Int) {
        if user.score + Int32(argument) >= Constants.minScore {
            updateUser(user: user, newScore: user.score + Int32(argument))
            addTurn(name: user.name, score: Int32(argument))
        }
    }
    
    func incrementScore(for user: UserModel) {
        updateUser(user: user, newScore: user.score + 1)
        addTurn(name: user.name, score: 1)
    }
    
    var totalUsers: Int {
        return users.count
    }
}

extension GameViewModel {
    var hasUsers: Bool {
        return totalUsers > 0
    }
    
    func isValidIndex(_ index: Int) -> Bool {
        return index >= 0 && index < totalUsers
    }
}
