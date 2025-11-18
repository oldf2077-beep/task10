//
//  TurnTableViewCell.swift
//  task10
//
//  Created by akote on 8.11.25.
//

import UIKit

class TurnTableViewCell: UITableViewCell {
    static let identifier = "TurnTableViewCell"
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.nunito(20, .extraBold)
        label.textColor = .white
        return label
    }()
    
    lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.nunito(20, .extraBold)
        label.textColor = .white
        return label
    }()
    
    func configure(name: String, score: Int) {
        nameLabel.text = name
        scoreLabel.text = String(score)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup() {
        selectionStyle = .none
        backgroundColor = .clear
        let horizontalStack = UIStackView()
        horizontalStack.spacing = 10
        horizontalStack.axis = .horizontal
        horizontalStack.isLayoutMarginsRelativeArrangement = true
        horizontalStack.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 0,
            leading: 16,
            bottom: 0,
            trailing: 0
        )
      
        horizontalStack.addArrangedSubview(nameLabel)
        horizontalStack.addArrangedSubview(scoreLabel)
        contentView.addSubview(horizontalStack)
        
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            horizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            horizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
