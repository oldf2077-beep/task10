//
//  +UIColor.swift
//  task10
//
//  Created by akote on 5.11.25.
//

import Foundation
import UIKit

extension UIColor {
    static let lightBlack: UIColor = UIColor(named: "lightBlack") ?? UIColor.white
    static let grayGreen: UIColor = UIColor(named: "grayGreen") ?? UIColor.white
    static let blackOlive: UIColor = UIColor(named: "blackOlive") ?? UIColor.white
    static let vineRed: UIColor =  UIColor(named: "vineRed") ?? UIColor.white
    static let darkMint: UIColor =  UIColor(named: "darkMint") ?? UIColor.white
    static let lightOrange: UIColor =  UIColor(named: "lightOrange") ?? UIColor.white
}

extension UIFont {
    enum Prettiness: String {
        case regular
        case semiBold
        case extraBold
    }
    
    static func nunito(_ size: CGFloat, _ type: Prettiness) -> UIFont {
        UIFont(name: "Nunito-\(type.rawValue.capitalized)", size: size) ?? .systemFont(ofSize: size)
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
