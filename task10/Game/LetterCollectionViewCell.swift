//
//  LetterCollectionViewCell.swift
//  task10
//
//  Created by akote on 13.11.25.
//

import Foundation
import UIKit

class LetterCollectionViewCell: UICollectionViewCell {
    static let identifier = "LetterCollectionViewCell"
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.font = UIFont.nunito(20, .extraBold)
        title.textColor = .blackOlive
        title.textAlignment = .center
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with value: String) {
        title.text = value
    }
    
    func setup() {
        contentView.addSubview(title)
        contentView.backgroundColor = .clear
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
