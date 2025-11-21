//
//  NewGameViewModel.swift
//  task10
//
//  Created by akote on 10.11.25.
//

import Foundation

enum ValidationError: Error {
    case emptyPlayersList
    case duplicatePlayerNames
    
    var message: String {
        switch self {
        case .emptyPlayersList:
            return "Empty players list"
        case .duplicatePlayerNames:
            return "Adding players with the same name is prohibited"
        }
    }
}

class NewGameViewModel {
    private var users: [UserModel] = []
    private var turns: [TurnModel] = []
    
    private let userService: UserServiceProtocol
    private let turnService: TurnServiceProtocol
    private let gameStateService: GameStateServiceProtocol
    
    init(
        userService: UserServiceProtocol = UserService(),
        turnService: TurnServiceProtocol = TurnService(),
        gameStateService: GameStateServiceProtocol = GameStateService()
    ) {
        self.userService = userService
        self.turnService = turnService
        self.gameStateService = gameStateService
        loadUsers()
        loadTurns()
    }
    
    func getUser(at index: Int) -> UserModel? {
        guard isValidIndex(index) else { return nil }
        return users[index]
    }
    
    func getUserName(at index: Int) -> String? {
        return getUser(at: index)?.name
    }
    
    func getTotalUsers() -> Int {
        return users.count
    }
    
    func hasUsers() -> Bool {
        return getTotalUsers() > 0
    }
    
    func isValidIndex(_ index: Int) -> Bool {
        return index >= 0 && index < getTotalUsers()
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
        }
    }
    
    func moveUser(at index: Int, to destinationIndex: Int) {
        guard isValidIndex(index) && isValidIndex(destinationIndex) else { return }
        
        let movedItem = users.remove(at: index)
        users.insert(movedItem, at: destinationIndex)
        
        userService.reorderAllUsers(users)
        loadUsers()
    }
    
    func deleteUser(at index: Int) {
        guard isValidIndex(index) else { return }
        let user = users[index]
        
        if userService.deleteUser(with: user.id) && turnService.deleteTurnsForUser(name: user.name) {
            loadUsers()
        }
    }
    
    func validateGameStart() -> ValidationError? {
        guard hasUsers() else {
            return .emptyPlayersList
        }
        
        let playerNames = users.map { $0.name }
        if Set(playerNames).count != playerNames.count {
            return .duplicatePlayerNames
        }
        
        return nil
    }
    
    func clearGameState() {
        gameStateService.clearGameState()
    }
}
