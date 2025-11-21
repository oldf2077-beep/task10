//
//  AddPlayerCell.swift
//  task10
//
//  Created by akote on 6.11.25.
//

import Foundation
import UIKit

class AddPlayerCell: UIView {
    lazy var addPlayerButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = .grayGreen
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let horizontalStack = UIStackView()
        horizontalStack.spacing = 10
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .leading
        
        let title = UILabel()
        title.font = UIFont.nunito(16, .semiBold)
        title.text = "Add player"
        title.textColor = .grayGreen
        
        horizontalStack.addArrangedSubview(addPlayerButton)
        horizontalStack.addArrangedSubview(title)
        
        addSubview(horizontalStack)
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        addPlayerButton.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStack.topAnchor.constraint(equalTo: topAnchor),
            horizontalStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            horizontalStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            horizontalStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            addPlayerButton.widthAnchor.constraint(equalToConstant: 25),
            addPlayerButton.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}
