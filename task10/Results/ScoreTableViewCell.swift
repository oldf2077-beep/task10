//
//  ScoreTableViewCell.swift
//  task10
//
//  Created by akote on 6.11.25.
//

import UIKit

class ScoreTableViewCell: UITableViewCell {
    static let identifier = "ScoreTableViewCell"
    
    lazy var positionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.nunito(28, .extraBold)
        label.textColor = .white
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.nunito(28, .extraBold)
        label.textColor = .lightOrange
        return label
    }()
    
    lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.nunito(28, .extraBold)
        label.textColor = .white
        return label
    }()
    
    func configure(position: Int, name: String, score: Int) {
        positionLabel.text = "#" + String(position)
        nameLabel.text = name
        scoreLabel.text = String(score)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup() {
        selectionStyle = .none
        backgroundColor = .clear
        let horizontalStack = UIStackView()
        horizontalStack.spacing = 10
        horizontalStack.axis = .horizontal

        horizontalStack.addArrangedSubview(positionLabel)
        horizontalStack.addArrangedSubview(nameLabel)
        horizontalStack.addArrangedSubview(scoreLabel)
        contentView.addSubview(horizontalStack)
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        positionLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            horizontalStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            horizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            horizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            positionLabel.widthAnchor.constraint(equalToConstant: 35)
        ])
    }
}
