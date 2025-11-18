//
//  NavigationStackManager.swift
//  task10
//
//  Created by akote on 6.11.25.
//

import UIKit

enum ViewControllerType: String {
    case newGame = "NewGameViewController"
    case game = "GameViewController"
    case results = "ResultsViewController"
    case addPlayer = "AddPlayerViewController"
}

class NavigationStackManager {
    static let shared = NavigationStackManager()
    
    private let navigationStackKey = "savedNavigationStack"
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    private func getViewControllerType(_ viewController: UIViewController) -> ViewControllerType? {
        switch viewController {
        case is NewGameViewController:
            return .newGame
        case is GameViewController:
            return .game
        case is ResultsViewController:
            return .results
        case is AddPlayerViewController:
            return .addPlayer
        default:
            return nil
        }
    }
    
    func saveNavigationStack(_ viewControllers: [UIViewController]) {
        let stackTypes = viewControllers.compactMap { getViewControllerType($0) }
        let stackStrings = stackTypes.map { $0.rawValue }
        userDefaults.set(stackStrings, forKey: navigationStackKey)
        userDefaults.synchronize()
    }
    
    func getSavedNavigationStack() -> [ViewControllerType]? {
        guard let stackStrings = userDefaults.array(forKey: navigationStackKey) as? [String] else {
            return nil
        }
        let stackTypes = stackStrings.compactMap { ViewControllerType(rawValue: $0) }
        return stackTypes.isEmpty ? nil : stackTypes
    }
    
    func clearSavedStack() {
        userDefaults.removeObject(forKey: navigationStackKey)
        userDefaults.synchronize()
    }
    
    func createViewController(for type: ViewControllerType) -> UIViewController? {
        switch type {
        case .newGame:
            let newGameViewController = NewGameViewController()
            newGameViewController.isFirstTimePresented = false
            return newGameViewController
        case .game:
            let userService = UserService()
            let users = userService.fetchUsersSortedByOrder()
            guard !users.isEmpty else {
                return nil
            }
            return GameViewController()
        case .results:
            let userService = UserService()
            let users = userService.fetchUsersSortedByOrder()
            guard !users.isEmpty else {
                return nil
            }
            return ResultsViewController()
        case .addPlayer:
            return AddPlayerViewController()
        }
    }
    
    func restoreNavigationStack() -> [UIViewController]? {
        guard let stackTypes = getSavedNavigationStack() else {
            return nil
        }
        
        var restoredStack: [UIViewController] = []
        
        for type in stackTypes {
            if let viewController = createViewController(for: type) {
                restoredStack.append(viewController)
            } else {
                return [NewGameViewController()]
            }
        }
        
        return restoredStack.isEmpty ? nil : restoredStack
    }
}


