//
//  TurnModel.swift
//  task10
//
//  Created by akote on 13.11.25.
//

import Foundation

struct TurnModel {
    let id: UUID
    let name: String
    let score: Int32
    
    init(from turn: TurnEntity) {
        self.id = turn.id ?? UUID()
        self.name = turn.name ?? ""
        self.score = turn.score
    }
    
    init(id: UUID?, name: String, score: Int32) {
        self.id = id ?? UUID()
        self.name = name
        self.score = score
    }
}
