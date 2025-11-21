//
//  GamePlayerTableViewCell.swift
//  task10
//
//  Created by akote on 9.11.25.
//

import UIKit

class GamePlayerViewCell: UICollectionViewCell {
    static let identifier = "GamePlayerViewCell"
    
    private lazy var playerName: UILabel = {
        let label = UILabel()
        label.textColor = .lightOrange
        label.font = UIFont.nunito(28, .extraBold)
        return label
    }()
    
    private lazy var playerScore: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.nunito(100, .extraBold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        contentView.backgroundColor = .blackOlive
        contentView.layer.cornerRadius = 10
        contentView.addSubview(playerName)
        contentView.addSubview(playerScore)
        playerName.translatesAutoresizingMaskIntoConstraints = false
        playerScore.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            playerName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            
            playerScore.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            playerScore.topAnchor.constraint(equalTo: playerName.bottomAnchor, constant: 48)
        ])
    }
    
    func configure(with name: String, score: Int) {
        playerName.text = name
        playerScore.text = String(score)
    }
}
