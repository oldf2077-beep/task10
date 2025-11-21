//
//  NewGameViewController.swift
//  task10
//
//  Created by akote on 5.11.25.
//

import UIKit

class NewGameViewController: BaseViewController {
    lazy var viewModel = NewGameViewModel()
    
    enum LayoutConstants {
        static let stackViewTopMargin: CGFloat = 24
        static let horizontalMargin: CGFloat = 16
        static let stackViewSpacing: CGFloat = 10
        static let stackViewCornerRadius: CGFloat = 10
        static let stackViewTopPadding: CGFloat = 16
        static let stackViewBottomPadding: CGFloat = 16
        static let titleLeadingMargin: CGFloat = 16
        static let containerTitleHeight: CGFloat = 10
        static let containerAddPlayerHeight: CGFloat = 20
        static let addPlayerCellLeadingMargin: CGFloat = 16
        static let startButtonHeight: CGFloat = 65
        static let startButtonBottomMargin: CGFloat = 40
        static let startButtonCornerRadius: CGFloat = 32
        static let startButtonShadowOffset: CGFloat = 5
        static let startButtonShadowRadius: CGFloat = 0
        static let startButtonShadowOpacity: Float = 1
        static let cellHeight: CGFloat = 60
        static let maxCollectionViewHeight: CGFloat = 300
        static let collectionViewAdjustmentDelay: TimeInterval = 0.1
        static let animationDuration: TimeInterval = 0.3
    }
    
    lazy var leftNavigationButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.nunito(17, .extraBold)
        button.setTitle("Cancel", for: .normal)
        button.tintColor = .grayGreen
        return button
    }()
    
    private lazy var collectionStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: LayoutConstants.stackViewTopPadding,
            leading: 0,
            bottom: LayoutConstants.stackViewBottomPadding,
            trailing: 0
        )
        stack.layer.cornerRadius = LayoutConstants.stackViewCornerRadius
        stack.spacing = LayoutConstants.stackViewSpacing
        stack.backgroundColor = .blackOlive
        return stack
    }()
    
    private lazy var containerViewTitle = UIView()
    
    private lazy var contentViewTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.nunito(16, .semiBold)
        title.text = "Players"
        title.textColor = .gray
        return title
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = true
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        collectionView.isDirectionalLockEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PlayerCollectionViewCell.self, forCellWithReuseIdentifier: PlayerCollectionViewCell.identifier)
        return collectionView
    }()
    
    private lazy var containerAddPlayerCell = UIView()
    
    lazy var addPlayerCell = AddPlayerCell()
    
    lazy var startGameButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .grayGreen
        button.layer.cornerRadius = LayoutConstants.startButtonCornerRadius
        button.layer.shadowColor = UIColor.darkMint.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: LayoutConstants.startButtonShadowOffset)
        button.layer.shadowRadius = LayoutConstants.startButtonShadowRadius
        button.layer.shadowOpacity = LayoutConstants.startButtonShadowOpacity
        button.layer.masksToBounds = false
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.darkMint
        shadow.shadowOffset = CGSize(width: 0, height: 2)

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.nunito(24, .extraBold),
            .foregroundColor: UIColor.white,
            .shadow: shadow,
        ]

        let attributedString = NSAttributedString(string: "Start Game", attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        return button
    }()
    
    var isFirstTimePresented = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        setupViews()
        setupConstraints()
        setupNavigationBar()
        setupPageTitle()
        
        if navigationController?.viewControllers.count == 1 {
            navigationItem.leftBarButtonItem?.isEnabled = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.leftBarButtonItem?.isHidden = isFirstTimePresented
        adjustCollectionViewHeight()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadUsers()
        collectionView.reloadData()
    }
    
    func setupPageTitle() {
        pageTitle.text = "Game Counter"
    }
    
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftNavigationButton)
        leftNavigationButton.addTarget(self, action: #selector(leftNavigationButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func navigateToAddPlayer(_ sender: UIBarButtonItem) {
        navigationController?.pushViewController(AddPlayerViewController(), animated: true)
    }
    
    @objc func leftNavigationButtonTapped(_ sender: UIBarButtonItem) {
        guard viewModel.hasUsers() else { return }
        navigationController?.popViewController(animated: false)
    }
    
    @objc func startButtonTapped(_ sender: UIBarButtonItem) {
        validateAndStartGame()
    }
    
    func deleteItem(at index: Int) {
        guard viewModel.isValidIndex(index) else { return }

        viewModel.deleteUser(at: index)
        collectionView.reloadData()
        adjustCollectionViewHeight()
        
        if !viewModel.hasUsers() {
            isFirstTimePresented = true
            navigationItem.leftBarButtonItem?.isHidden = isFirstTimePresented
        }
   }
}

extension NewGameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getTotalUsers()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlayerCollectionViewCell.identifier, for: indexPath) as! PlayerCollectionViewCell
        if let name = viewModel.getUserName(at: indexPath.item) {
            cell.configure(with: name) { [weak self] gesture in
                self?.handleDragGesture(gesture, for: cell, at: indexPath)
            }
            cell.deleteAction = { [weak self] in
                self?.deleteItem(at: indexPath.item)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        viewModel.moveUser(at: sourceIndexPath.item, to: destinationIndexPath.item)
        collectionView.reloadData()
    }
}

private extension NewGameViewController {
    func setupActions() {
        addPlayerCell.addPlayerButton.addTarget(self, action: #selector(navigateToAddPlayer(_:)), for: .touchUpInside)
        startGameButton.addTarget(self, action: #selector(startButtonTapped(_:)), for: .touchUpInside)
    }
    
    func setupViews() {
        view.addSubview(collectionStackView)
        view.addSubview(startGameButton)
        containerViewTitle.addSubview(contentViewTitle)
        collectionStackView.addArrangedSubview(containerViewTitle)
        collectionStackView.addArrangedSubview(collectionView)
        containerAddPlayerCell.addSubview(addPlayerCell)
        collectionStackView.addArrangedSubview(containerAddPlayerCell)
        
        collectionStackView.translatesAutoresizingMaskIntoConstraints = false
        contentViewTitle.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addPlayerCell.translatesAutoresizingMaskIntoConstraints = false
        startGameButton.translatesAutoresizingMaskIntoConstraints = false
        containerViewTitle.translatesAutoresizingMaskIntoConstraints = false
        containerAddPlayerCell.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionStackView.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: LayoutConstants.stackViewTopMargin),
            collectionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.horizontalMargin),
            collectionStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.horizontalMargin),
            
            contentViewTitle.leadingAnchor.constraint(equalTo: containerViewTitle.leadingAnchor, constant: LayoutConstants.titleLeadingMargin),
            containerViewTitle.heightAnchor.constraint(equalToConstant: LayoutConstants.containerTitleHeight),
            
            containerAddPlayerCell.heightAnchor.constraint(equalToConstant: LayoutConstants.containerAddPlayerHeight),
            addPlayerCell.leadingAnchor.constraint(equalTo: containerAddPlayerCell.leadingAnchor, constant: LayoutConstants.addPlayerCellLeadingMargin),
            
            startGameButton.heightAnchor.constraint(equalToConstant: LayoutConstants.startButtonHeight),
            startGameButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -LayoutConstants.startButtonBottomMargin),
            startGameButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.horizontalMargin),
            startGameButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.horizontalMargin)
        ])
    }
    
    func adjustCollectionViewHeight() {
       DispatchQueue.main.asyncAfter(deadline: .now() + LayoutConstants.collectionViewAdjustmentDelay) {
           var contentHeight = self.collectionView.collectionViewLayout.collectionViewContentSize.height
           if contentHeight > LayoutConstants.maxCollectionViewHeight {
               contentHeight = LayoutConstants.maxCollectionViewHeight
           }
     
           if let heightConstraint = self.collectionView.constraints.first(where: { $0.firstAttribute == .height }) {
               heightConstraint.constant = contentHeight
           } else {
               self.collectionView.heightAnchor.constraint(equalToConstant: contentHeight).isActive = true
           }
           
           UIView.animate(withDuration: LayoutConstants.animationDuration) {
               self.view.layoutIfNeeded()
           }
       }
    }
    
    func handleDragGesture(_ gesture: UILongPressGestureRecognizer, for cell: PlayerCollectionViewCell, at indexPath: IndexPath) {
        let location = gesture.location(in: collectionView)
        
        switch gesture.state {
        case .began:
            collectionView.beginInteractiveMovementForItem(at: indexPath)
            cell.startDragAnimation()
        case .changed:
            guard let item = collectionView.cellForItem(at: indexPath) else { break }
            collectionView.updateInteractiveMovementTargetPosition(CGPoint(x: item.center.x, y: location.y))
        case .ended:
            collectionView.endInteractiveMovement()
            cell.endDragAnimation()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    func validateAndStartGame() {
        if let validationError = viewModel.validateGameStart() {
            showAlert(message: validationError.message)
            return
        }
        
        viewModel.clearGameState()
        let gameViewController = GameViewController()
        navigationController?.setViewControllers([gameViewController], animated: false)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "OK", style: .destructive))
        present(alertController, animated: true)
    }
}

extension NewGameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: LayoutConstants.cellHeight)
    }
}
