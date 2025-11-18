//
//  BaseViewController.swift
//  task10
//
//  Created by akote on 6.11.25.
//

import UIKit

class BaseViewController: UIViewController {
    lazy var pageTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.nunito(36, .extraBold)
        title.text = ""
        title.textColor = .white
        return title
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightBlack
        view.addSubview(pageTitle)
        pageTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
    }
}
