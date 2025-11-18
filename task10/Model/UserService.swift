//
//  UserService.swift
//  task10
//
//  Created by akote on 10.11.25.
//

import Foundation
import CoreData

protocol UserServiceProtocol {
    func fetchUsers() -> [UserModel]
    func createUser(_ user: UserModel) -> Bool
    func updateUser(_ user: UserModel) -> Bool
    func deleteUser(with id: UUID) -> Bool
    func fetchUsersSortedByScore() -> [UserModel]
    func fetchUsersSortedByOrder() -> [UserModel]
    func reorderAllUsers(_ users: [UserModel])
}

class UserService: UserServiceProtocol {
    enum Constants {
        static let orderIncrement: Int32 = 1000
    }
    
    func fetchUsers() -> [UserModel] {
        let context = CoreDataManager.shared.viewContext
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        
        do {
            let users = try context.fetch(fetchRequest)
            return users.map { UserModel(from: $0) }
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    func createUser(_ user: UserModel) -> Bool {
        let context = CoreDataManager.shared.viewContext
        
        let newUser = UserEntity(context: context)
        newUser.id = user.id
        newUser.name = user.name
        newUser.score = user.score
        newUser.order = getMaxOrder() + Constants.orderIncrement
        
        do {
            try context.save()
            return true
        } catch {
            print("Create error: \(error)")
            context.rollback()
            return false
        }
    }
    
    func updateUser(_ user: UserModel) -> Bool {
        let context = CoreDataManager.shared.viewContext
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", user.id as CVarArg)
        
        do {
            let users = try context.fetch(fetchRequest)
            guard let userToUpdate = users.first else { return false }
            
            userToUpdate.name = user.name
            userToUpdate.score = user.score
            userToUpdate.order = user.order
            
            try context.save()
            return true
        } catch {
            print("Update error: \(error)")
            context.rollback()
            return false
        }
    }
    
    func deleteUser(with id: UUID) -> Bool {
        let context = CoreDataManager.shared.viewContext
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let users = try context.fetch(fetchRequest)
            guard let userToDelete = users.first else { return false }
            
            context.delete(userToDelete)
            try context.save()
            return true
        } catch {
            print("Delete error: \(error)")
            context.rollback()
            return false
        }
    }
    
    func fetchUsersSortedByScore() -> [UserModel] {
        let context = CoreDataManager.shared.viewContext
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        
        let scoreSort = NSSortDescriptor(key: "score", ascending: false)
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [scoreSort, nameSort]
        
        do {
            let users = try context.fetch(fetchRequest)
            return users.map { UserModel(from: $0) }
        } catch {
            print("Fetch sorted error: \(error)")
            return []
        }
    }
    
    func fetchUsersSortedByOrder() -> [UserModel] {
        let context = CoreDataManager.shared.viewContext
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            let users = try context.fetch(fetchRequest)
            return users.map { UserModel(from: $0) }
        } catch {
            print("Fetch by order error: \(error)")
            return []
        }
    }
    
    func reorderAllUsers(_ users: [UserModel]) {
        for (index, user) in users.enumerated() {
            updateUser(user.withOrder(Int32(index) * Constants.orderIncrement))
        }
    }
}

// MARK: - Private Methods
private extension UserService {
    func getMaxOrder() -> Int32 {
       let context = CoreDataManager.shared.viewContext
       let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
       
       let sortDescriptor = NSSortDescriptor(key: "order", ascending: false)
       fetchRequest.sortDescriptors = [sortDescriptor]
       fetchRequest.fetchLimit = 1
       
       do {
           let users = try context.fetch(fetchRequest)
           return users.first?.order ?? 0
       } catch {
           print("Error getting max order: \(error)")
           return 0
       }
    }
}
