//
//  UserModel.swift
//  task10
//
//  Created by akote on 10.11.25.
//

import Foundation

struct UserModel {
    let id: UUID
    let name: String
    let score: Int32
    let order: Int32
    
    init(from user: UserEntity) {
        self.id = user.id ?? UUID()
        self.name = user.name ?? ""
        self.score = user.score
        self.order = user.order
    }
    
    init(id: UUID?, name: String, score: Int32, order: Int32) {
        self.id = id ?? UUID()
        self.name = name
        self.score = score
        self.order = order
    }
    
    func withOrder(_ newOrder: Int32) -> UserModel {
        return UserModel(id: self.id, name: self.name, score: self.score, order: newOrder)
    }
}
