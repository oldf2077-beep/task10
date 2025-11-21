//
//  ResultsViewController.swift
//  task10
//
//  Created by akote on 6.11.25.
//

import UIKit

class ResultsViewController: BaseViewController {
    enum LayoutConstants {
        static let scoreTableTopMargin: CGFloat = 4
        static let horizontalMargin: CGFloat = 16
        static let scoreTableRowHeight: CGFloat = 50
        static let turnsViewTopMargin: CGFloat = 16
        static let turnsViewBottomMargin: CGFloat = 16
        static let turnsViewCornerRadius: CGFloat = 10
        static let turnsViewTitleTopMargin: CGFloat = 14
        static let turnsViewTitleLeadingMargin: CGFloat = 16
        static let turnsTableTrailingMargin: CGFloat = 16
        static let turnsTableRowHeight: CGFloat = 45
    }
    
    lazy var leftNavigationButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.nunito(17, .extraBold)
        button.setTitle("New Game", for: .normal)
        button.tintColor = .grayGreen
        return button
    }()

    lazy var rightNavigationButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.nunito(17, .extraBold)
        button.setTitle("Resume", for: .normal)
        button.tintColor = .grayGreen
        return button
    }()
    
    private lazy var turnsView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = LayoutConstants.turnsViewCornerRadius
        view.backgroundColor = .blackOlive
        return view
    }()
    
    private lazy var turnsViewTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.nunito(16, .semiBold)
        title.text = "Turns"
        title.textColor = .gray
        return title
    }()
    
    lazy var scoreTable = UITableView()
    
    lazy var turnsTable = UITableView()
    
    var viewModel = ResultsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTables()
        setupViews()
        setupConstraints()
        setupNavigationBar()
        setupPageTitle()
    }
    
    func setupPageTitle() {
        pageTitle.text = "Results"
    }
    
    func setupNavigationBar() {
        leftNavigationButton.addTarget(self, action: #selector(createNewGame(_:)), for: .touchUpInside)
        rightNavigationButton.addTarget(self, action: #selector(navigateBack(_:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftNavigationButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightNavigationButton)
    }
    
    @objc func createNewGame(_ sender: UIBarButtonItem) {
        let newGameViewController = NewGameViewController()
        newGameViewController.isFirstTimePresented = false
        navigationController?.pushViewController(newGameViewController, animated: true)
    }
    
    @objc func navigateBack(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}

private extension ResultsViewController {
    func setupTables() {
        scoreTable.dataSource = self
        scoreTable.backgroundColor = .clear
        scoreTable.isScrollEnabled = false
        scoreTable.separatorStyle = .none
        scoreTable.register(ScoreTableViewCell.self, forCellReuseIdentifier: ScoreTableViewCell.identifier)
        scoreTable.rowHeight = LayoutConstants.scoreTableRowHeight
        
        turnsTable.dataSource = self
        turnsTable.backgroundColor = .clear
        turnsTable.isScrollEnabled = false
        turnsTable.register(TurnTableViewCell.self, forCellReuseIdentifier: TurnTableViewCell.identifier)
        turnsTable.rowHeight = LayoutConstants.turnsTableRowHeight
    }
    
    func setupViews() {
        view.addSubview(scoreTable)
        view.addSubview(turnsView)
        turnsView.addSubview(turnsViewTitle)
        turnsView.addSubview(turnsTable)
        
        scoreTable.translatesAutoresizingMaskIntoConstraints = false
        turnsView.translatesAutoresizingMaskIntoConstraints = false
        turnsViewTitle.translatesAutoresizingMaskIntoConstraints = false
        turnsTable.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scoreTable.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: LayoutConstants.scoreTableTopMargin),
            scoreTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.horizontalMargin),
            scoreTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.horizontalMargin),
            scoreTable.heightAnchor.constraint(equalToConstant: CGFloat(LayoutConstants.scoreTableRowHeight * CGFloat(viewModel.getTotalUsers()))),
            
            turnsView.topAnchor.constraint(equalTo: scoreTable.bottomAnchor, constant: LayoutConstants.turnsViewTopMargin),
            turnsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            turnsView.widthAnchor.constraint(equalTo: scoreTable.widthAnchor),
            turnsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -LayoutConstants.turnsViewBottomMargin),
            
            turnsViewTitle.topAnchor.constraint(equalTo: turnsView.topAnchor, constant: LayoutConstants.turnsViewTitleTopMargin),
            turnsViewTitle.leadingAnchor.constraint(equalTo: turnsView.leadingAnchor, constant: LayoutConstants.turnsViewTitleLeadingMargin),
            
            turnsTable.topAnchor.constraint(equalTo: turnsViewTitle.bottomAnchor),
            turnsTable.leadingAnchor.constraint(equalTo: turnsView.leadingAnchor),
            turnsTable.trailingAnchor.constraint(equalTo: turnsView.trailingAnchor, constant: -LayoutConstants.turnsTableTrailingMargin),
            turnsTable.bottomAnchor.constraint(equalTo: turnsView.bottomAnchor)
        ])
    }
}


extension ResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == scoreTable {
            return viewModel.getTotalUsers()
        } else if tableView == turnsTable {
            return viewModel.getTotalTurns()
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == scoreTable {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ScoreTableViewCell.identifier, for: indexPath) as? ScoreTableViewCell else {
                fatalError("Unable to dequeue")
            }
            if let name = viewModel.getTopUserName(at: indexPath.item),
               let score = viewModel.getTopUserScore(at: indexPath.item) {
                cell.configure(position: indexPath.item + 1, name: name, score: Int(score))
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TurnTableViewCell.identifier, for: indexPath) as? TurnTableViewCell else {
                fatalError("Unable to dequeue")
            }
            if let name = viewModel.getTurnName(at: indexPath.item),
               let score = viewModel.getTurnScore(at: indexPath.item) {
                cell.configure(name: name, score: Int(score))
            }
            return cell
        }
    }
}

