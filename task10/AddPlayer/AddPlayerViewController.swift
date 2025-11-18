//
//  AddPlayerViewController.swift
//  task10
//
//  Created by akote on 6.11.25.
//

import UIKit

class AddPlayerViewController: BaseViewController {
    enum LayoutConstants {
        static let textFieldTopMargin: CGFloat = 16
        static let textFieldHeight: CGFloat = 60
        static let textFieldLeftPadding: CGFloat = 16
    }
    
    lazy var leftNavigationButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.nunito(17, .extraBold)
        button.setTitle("Back", for: .normal)
        button.tintColor = .grayGreen
        
        return button
    }()

    lazy var rightNavigationButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.nunito(17, .extraBold)
        button.setTitle("Add", for: .normal)
        button.tintColor = .gray
        
        return button
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .blackOlive
        textField.placeholder = "Player Name"
        textField.font = UIFont.nunito(20, .extraBold)
        textField.tintColor = .white
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: LayoutConstants.textFieldLeftPadding, height: 1))
        textField.leftViewMode = .always
        textField.autocorrectionType = .no
        textField.becomeFirstResponder()
        return textField
    }()
    
    let viewModel = AddPlayerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        setupViews()
        setupConstraints()
        setupNavigationBar()
        setupPageTitle()
    }
    
    func setupPageTitle() {
        pageTitle.text = "Add Player"
    }
    
    func setupNavigationBar() {
        leftNavigationButton.addTarget(self, action: #selector(navigateBack(_:)), for: .touchUpInside)
        rightNavigationButton.addTarget(self, action: #selector(addPlayerNavigateBack(_:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftNavigationButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightNavigationButton)
    }
    
    @objc func navigateBack(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addPlayerNavigateBack(_ sender: UIBarButtonItem) {
        addPlayer()
    }
}

private extension AddPlayerViewController {
    func setupActions() {
        textField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
    }
    
    func setupViews() {
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: LayoutConstants.textFieldTopMargin),
            textField.heightAnchor.constraint(equalToConstant: LayoutConstants.textFieldHeight),
            textField.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    @objc func textChanged(_ sender: UITextField) {
        let isEmpty = sender.text?.isEmpty == true
        rightNavigationButton.isEnabled = !isEmpty
        rightNavigationButton.tintColor = isEmpty ? .gray : .grayGreen
    }
    
    func addPlayer() {
        guard let name = textField.text, !name.isEmpty else { return }
        viewModel.addUser(name: name.capitalized, score: 0)
        navigationController?.popViewController(animated: true)
    }
}
