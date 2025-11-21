//
//  AddPointsCollectionViewCell.swift
//  task10
//
//  Created by akote on 9.11.25.
//

import UIKit

class AddPointsCollectionViewCell: UICollectionViewCell {
    static let identifier = "AddPointsCollectionViewCell"
    
    weak var delegate: CollectionViewCellDelegate?
    
    lazy var incrementButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
        button.tintColor = .grayGreen
        button.titleLabel?.font = UIFont.nunito(24, .extraBold)
        button.titleLabel?.textColor = .white
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with value: String) {
        incrementButton.setTitle(value, for: .normal)
    }
    
    func setup() {
        contentView.addSubview(incrementButton)
       
        incrementButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        incrementButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            incrementButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            incrementButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            incrementButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            incrementButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    @objc private func buttonTapped() {
        delegate?.didTapButton(in: self)
    }
}
