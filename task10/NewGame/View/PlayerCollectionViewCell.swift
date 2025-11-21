//
//  PlayerCollectionViewCell.swift
//  task10
//
//  Created by akote on 5.11.25.
//

import UIKit

class PlayerCollectionViewCell: UICollectionViewCell {
    static let identifier = "PlayerCollectionViewCell"
    
    var deleteAction: (() -> Void)?
    
    private let view = UIView()
    private let dividerView = UIView()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        button.tintColor = .vineRed
        return button
    }()
    
    private lazy var playerName: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.nunito(20, .extraBold)
        return label
    }()
    
    private lazy var sortButton: DragButton = {
        let button = DragButton()
        button.setBackgroundImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.isLayoutMarginsRelativeArrangement = true
        verticalStack.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 0,
            leading: 16,
            bottom: 0,
            trailing: 0
        )
        verticalStack.spacing = 10
        
        let horizontalStack = UIStackView()
        horizontalStack.spacing = 10
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.isLayoutMarginsRelativeArrangement = true
        horizontalStack.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 16
        )

        dividerView.backgroundColor = .systemGray2
        
        horizontalStack.addArrangedSubview(deleteButton)
        horizontalStack.addArrangedSubview(playerName)
        horizontalStack.addArrangedSubview(sortButton)
        
        verticalStack.addArrangedSubview(horizontalStack)
        verticalStack.addArrangedSubview(dividerView)
        contentView.addSubview(view)
        contentView.addSubview(verticalStack)
        
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        playerName.translatesAutoresizingMaskIntoConstraints = false
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            verticalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            deleteButton.widthAnchor.constraint(equalToConstant: 25),
            deleteButton.heightAnchor.constraint(equalToConstant: 25),

            sortButton.widthAnchor.constraint(equalToConstant: 25),
            sortButton.heightAnchor.constraint(equalToConstant: 25),

            dividerView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    func configure(with name: String, dragHandler: @escaping (UILongPressGestureRecognizer) -> Void) {
        playerName.text = name
        sortButton.dragHandler = dragHandler
    }
    
    @objc private func deleteButtonTapped() {
        deleteAction?()
    }
    
    func startDragAnimation() {
        UIView.animate(withDuration: 0.2) { [self] in
            dividerView.layer.opacity = 0
            view.transform = CGAffineTransform(scaleX: 1, y: 1.05)
            view.backgroundColor = .lightBlack
        }
    }
   
   func endDragAnimation() {
       UIView.animate(withDuration: 0.2) { [self] in
            dividerView.layer.opacity = 1
            view.transform = .identity
            view.backgroundColor = .clear
        }
    }
}
