//
//  TurnService.swift
//  task10
//
//  Created by akote on 13.11.25.
//

import Foundation
import CoreData

protocol TurnServiceProtocol {
    func fetchTurns() -> [TurnModel]
    func createTurn(_ turn: TurnModel) -> Bool
    func deleteTurn(with id: UUID) -> Bool
    func deleteTurnsForUser(name: String) -> Bool
}

class TurnService: TurnServiceProtocol {
    func fetchTurns() -> [TurnModel] {
        let context = CoreDataManager.shared.viewContext
        let fetchRequest: NSFetchRequest<TurnEntity> = TurnEntity.fetchRequest()
        
        do {
            let turns = try context.fetch(fetchRequest)
            return turns.map { TurnModel(from: $0) }.reversed()
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    func createTurn(_ turn: TurnModel) -> Bool {
        let context = CoreDataManager.shared.viewContext
        
        let newTurn = TurnEntity(context: context)
        newTurn.id = turn.id
        newTurn.name = turn.name
        newTurn.score = turn.score
        
        do {
            try context.save()
            return true
        } catch {
            print("Create error: \(error)")
            context.rollback()
            return false
        }
    }
    
    func deleteTurnsForUser(name: String) -> Bool {
        let context = CoreDataManager.shared.viewContext
        let fetchRequest: NSFetchRequest<TurnEntity> = TurnEntity.fetchRequest()
        
        do {
            let turns = try context.fetch(fetchRequest)
            let turnsToDelete = turns.filter { $0.name == name }
            for turn in turnsToDelete {
                context.delete(turn)
            }
            
            try context.save()
            return true
        } catch {
            print("Delete error: \(error)")
            context.rollback()
            return false
        }
    }
    
    func deleteTurn(with id: UUID) -> Bool {
        let context = CoreDataManager.shared.viewContext
        let fetchRequest: NSFetchRequest<TurnEntity> = TurnEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let turns = try context.fetch(fetchRequest)
            guard let turnToDelete = turns.first else { return false }
            
            context.delete(turnToDelete)
            try context.save()
            return true
        } catch {
            print("Delete error: \(error)")
            context.rollback()
            return false
        }
    }
}
