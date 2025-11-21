//
//  AddPlayerViewModel.swift
//  task10
//
//  Created by akote on 10.11.25.
//

import Foundation

class AddPlayerViewModel {
    private var users: [UserModel] = []

    private let userService: UserServiceProtocol

    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
        loadUsers()
    }

    func loadUsers() {
        users = userService.fetchUsersSortedByOrder()
    }

    func addUser(name: String, score: Int32) {
        let newUser = UserModel(id: nil, name: name, score: score, order: 0)
        
        if userService.createUser(newUser) {
            loadUsers()
        }
    }
}

