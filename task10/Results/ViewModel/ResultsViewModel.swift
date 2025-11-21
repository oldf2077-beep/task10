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
    
    private var topUsers: [UserModel] = []
    private var turns: [TurnModel] = []

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
    
    func getTopUser(at index: Int) -> UserModel? {
        guard index >= 0 && index < topUsers.count else { return nil }
        return topUsers[index]
    }
    
    func getTopUserName(at index: Int) -> String? {
        return getTopUser(at: index)?.name
    }
    
    func getTopUserScore(at index: Int) -> Int32? {
        return getTopUser(at: index)?.score
    }
    
    func getTurn(at index: Int) -> TurnModel? {
        guard index >= 0 && index < turns.count else { return nil }
        return turns[index]
    }
    
    func getTurnName(at index: Int) -> String? {
        return getTurn(at: index)?.name
    }
    
    func getTurnScore(at index: Int) -> Int32? {
        return getTurn(at: index)?.score
    }
    
    func getTotalUsers() -> Int {
        return topUsers.count
    }
    
    func getTotalTurns() -> Int {
        return turns.count
    }
}

