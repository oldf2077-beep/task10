//
//  NewGameViewModel.swift
//  task10
//
//  Created by akote on 10.11.25.
//

import Foundation

class NewGameViewModel {
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
    
    func addUser(name: String, score: Int32) {
        let newUser = UserModel(id: nil, name: name, score: score, order: 0)
        
        if userService.createUser(newUser) {
            loadUsers()
            errorMessage = nil
        } else {
            errorMessage = "Failed to create user"
        }
    }
    
    func moveUser(at index: Int, to destinationIndex: Int) {
        let movedItem = users.remove(at: index)
        users.insert(movedItem, at: destinationIndex)
        
        userService.reorderAllUsers(users)
        loadUsers()
    }
    
    func deleteUser(at index: Int) {
        guard index < users.count else { return }
        let user = users[index]
        
        if userService.deleteUser(with: user.id) && turnService.deleteTurnsForUser(name: user.name) {
            loadUsers()
            errorMessage = nil
        } else {
            errorMessage = "Failed to delete user"
        }
    }
    
    var totalUsers: Int {
        return users.count
    }
}

extension NewGameViewModel {
    var hasUsers: Bool {
        return totalUsers > 0
    }
    
    func isValidIndex(_ index: Int) -> Bool {
        return index >= 0 && index < totalUsers
    }
}
