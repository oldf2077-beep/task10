//
//  ResultsViewModel.swift
//  task10
//
//  Created by akote on 12.11.25.
//

import Foundation

class ResultsViewModel {
    enum Constants {
        static let topUsersLimit = 3
    }
    
    var topUsers: [UserModel] = []
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
        topUsers = Array(userService.fetchUsersSortedByScore().prefix(Constants.topUsersLimit))
    }

    func loadTurns() {
        turns = turnService.fetchTurns()
    }
    
    var totalUsers: Int {
        return topUsers.count
    }
    
    var totalTurns: Int {
        return turns.count
    }
}

