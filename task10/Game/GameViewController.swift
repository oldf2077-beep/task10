//
//  GameViewController.swift
//  task10
//
//  Created by akote on 6.11.25.
//

import UIKit

class GameViewController: BaseViewController {
    var viewModel = GameViewModel()
    
    enum LayoutConstants {
        static let rollButtonSize: CGFloat = 30
        static let horizontalMargin: CGFloat = 16
        static let timerTitleTopMargin: CGFloat = 16
        static let timerButtonSpacing: CGFloat = 10
        static let resetTimerButtonWidth: CGFloat = 15
        static let resetTimerButtonHeight: CGFloat = 20
        static let timerButtonWidth: CGFloat = 18
        static let timerButtonHeight: CGFloat = 20
        static let playerCollectionViewTopMargin: CGFloat = 40
        static let playerCollectionViewHeight: CGFloat = 240
        static let playerCollectionViewContentInset: CGFloat = 55
        static let playerCollectionViewSpacing: CGFloat = 20
        static let incrementButtonSize: CGFloat = 90
        static let incrementButtonTopMargin: CGFloat = 16
        static let addPointsCollectionViewTopMargin: CGFloat = 16
        static let addPointsCollectionViewWidth: CGFloat = 335
        static let addPointsCollectionViewHeight: CGFloat = 55
        static let addPointsCollectionViewSpacing: CGFloat = 15
        static let scrollButtonSize: CGFloat = 30
        static let scrollButtonSpacing: CGFloat = 16
        static let undoButtonLeadingMargin: CGFloat = 24
        static let undoButtonBottomMargin: CGFloat = 16
        static let undoButtonWidth: CGFloat = 15
        static let undoButtonHeight: CGFloat = 20
        static let letterCollectionViewTopMargin: CGFloat = 16
        static let letterCollectionViewHeight: CGFloat = 24
        static let letterCollectionViewItemWidth: CGFloat = 32
        static let letterCollectionViewSpacing: CGFloat = 10
        static let playerCellWidth: CGFloat = 255
        static let playerCellHeight: CGFloat = 240
        static let addPointsCellSize: CGFloat = 55
        static let letterCellSize: CGFloat = 24
        static let diceImageSize: CGFloat = 120
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
        button.setTitle("Results", for: .normal)
        button.tintColor = .grayGreen
        
        return button
    }()
    
    lazy var rollButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "dice_4"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        return button
    }()
    
    lazy var undoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "undo"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        return button
    }()
    
    lazy var timerTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.nunito(28, .extraBold)
        title.textColor = .blackOlive
        title.text = "00:00"
        title.textAlignment = .center
        return title
    }()
    
    lazy var timerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "play"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        return button
    }()
    
    private lazy var playerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = LayoutConstants.playerCollectionViewSpacing
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(
            top: 0,
            left: LayoutConstants.playerCollectionViewContentInset,
            bottom: 0,
            right: LayoutConstants.playerCollectionViewContentInset
        )
        collectionView.register(GamePlayerViewCell.self, forCellWithReuseIdentifier: GamePlayerViewCell.identifier)
        return collectionView
    }()
    
    private lazy var addPointsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = LayoutConstants.addPointsCollectionViewSpacing
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AddPointsCollectionViewCell.self, forCellWithReuseIdentifier: AddPointsCollectionViewCell.identifier)
        return collectionView
    }()
    
    lazy var nextScrollButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_Next"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        return button
    }()
    
    lazy var previousScrollButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_Previous"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        return button
    }()
    
    lazy var incrementButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
        button.tintColor = .grayGreen
        button.setTitle("+1", for: .normal)
        button.titleLabel?.font = UIFont.nunito(40, .extraBold)
        button.titleLabel?.textColor = .white
        return button
    }()
    
    lazy var resetTimerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "undo"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        
        return button
    }()
    
    let addPointsValues = ["-10", "-5", "-1", "+5", "+10"]
    
    private var blurView: UIVisualEffectView?
    
    lazy var letterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = LayoutConstants.letterCollectionViewSpacing
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(LetterCollectionViewCell.self, forCellWithReuseIdentifier: LetterCollectionViewCell.identifier)
        return collectionView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        setupViews()
        setupConstraints()
        setupNavigationBar()
        setupPageTitle()
        setupTimerService()
        restoreGameState()
        
        navigationController?.setViewControllers([self], animated: true)
    }
    
    @objc func resetButtonTapped() {
        viewModel.resetTimer()
    }
    
    @objc func rollButtonTapped() {
        showDiceBlur()
    }
    
    @objc func undoButtonTapped() {
        guard viewModel.hasUsers() else { return }
        guard let playerIndex = viewModel.undoTurn() else { return }
        guard viewModel.isValidIndex(playerIndex) else { return }
        let indexPath = IndexPath(item: playerIndex, section: 0)
        playerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        viewModel.saveCurrentPlayerIndex(playerIndex)
        playerCollectionView.reloadData()
    }
    
    @objc func incrementButtonTapped() {
        if let index = playerCollectionView.getCenterIndexPath()?.item {
            viewModel.incrementScore(for: index)
            scrollToPlayer(offset: 1)
        }
        playerCollectionView.reloadData()
    }
    
    @objc func createNewGame(_ sender: UIBarButtonItem) {
        guard let navigationController = self.navigationController else {
            return
        }
        let newGameViewController = NewGameViewController()
        newGameViewController.isFirstTimePresented = false
        
        navigationController.pushViewController(newGameViewController, animated: true)
    }
    
    @objc func navigateToResults(_ sender: UIBarButtonItem) {
        navigationController?.pushViewController(ResultsViewController(), animated: true)
    }
    
    func setupPageTitle() {
        pageTitle.text = "Game"
    }
    
    func setupNavigationBar() {
        leftNavigationButton.addTarget(self, action: #selector(createNewGame(_:)), for: .touchUpInside)
        rightNavigationButton.addTarget(self, action: #selector(navigateToResults(_:)), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftNavigationButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightNavigationButton)
    }
    
    @objc func nextButtonTapped(_ sender: UIButton) {
        scrollToPlayer(offset: 1)
    }
    
    @objc func previousButtonTapped(_ sender: UIButton) {
        scrollToPlayer(offset: -1)
    }
    
    func selectLetterCollectionViewCell(_ indexPath: IndexPath) {
        updateLetterCell(at: indexPath, isSelected: true)
    }
    
    func deselectLetterCollectionViewCell(_ indexPath: IndexPath) {
        updateLetterCell(at: indexPath, isSelected: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveGameState()
    }
}


extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == playerCollectionView {
            return viewModel.getTotalUsers()
        } else if collectionView == addPointsCollectionView {
            return addPointsValues.count
        } else if collectionView == letterCollectionView {
            return viewModel.getTotalUsers()
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == playerCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GamePlayerViewCell.identifier, for: indexPath) as? GamePlayerViewCell else {
                return UICollectionViewCell()
            }
            if let name = viewModel.getUserName(at: indexPath.item),
               let score = viewModel.getUserScore(at: indexPath.item) {
                cell.configure(with: name, score: Int(score))
            }
            return cell
        } else if collectionView == addPointsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPointsCollectionViewCell.identifier, for: indexPath) as? AddPointsCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: addPointsValues[indexPath.item])
            cell.delegate = self
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LetterCollectionViewCell.identifier, for: indexPath) as? LetterCollectionViewCell else {
                return UICollectionViewCell()
            }
            if let firstLetter = viewModel.getUserFirstLetter(at: indexPath.item) {
                cell.configure(with: firstLetter)
            }
            if indexPath.item == 0 {
                cell.title.textColor = .white
            }
            return cell
        }
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == playerCollectionView {
            return CGSize(width: LayoutConstants.playerCellWidth, height: LayoutConstants.playerCellHeight)
        } else if collectionView == addPointsCollectionView {
            return CGSize(width: LayoutConstants.addPointsCellSize, height: LayoutConstants.addPointsCellSize)
        } else {
            return CGSize(width: LayoutConstants.letterCellSize, height: LayoutConstants.letterCellSize)
        }
    }
}

extension GameViewController: CollectionViewCellDelegate {
    func didTapButton(in cell: UICollectionViewCell) {
        guard let indexPath = addPointsCollectionView.indexPath(for: cell) else { return }
        guard let pointsString = addPointsValues[safe: indexPath.item],
              let points = Int(pointsString) else { return }
        
        if let index = playerCollectionView.getCenterIndexPath()?.item {
            viewModel.increaseScore(for: index, on: points)
            scrollToPlayer(offset: 1)
        }
        playerCollectionView.reloadData()
    }
}

extension UICollectionView {
    func getCenterIndexPath() -> IndexPath? {
        let centerPoint = CGPoint(
            x: contentOffset.x + bounds.width / 2,
            y: contentOffset.y + bounds.height / 2
        )
        return indexPathForItem(at: centerPoint)
    }
}

private extension GameViewController {
    func setupActions() {
        nextScrollButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        previousScrollButton.addTarget(self, action: #selector(previousButtonTapped(_:)), for: .touchUpInside)
        timerButton.addTarget(self, action: #selector(startPauseButtonTapped), for: .touchUpInside)
        incrementButton.addTarget(self, action: #selector(incrementButtonTapped), for: .touchUpInside)
        undoButton.addTarget(self, action: #selector(undoButtonTapped), for: .touchUpInside)
        rollButton.addTarget(self, action: #selector(rollButtonTapped), for: .touchUpInside)
        resetTimerButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
    }
    
    func setupViews() {
        let views: [UIView] = [
            rollButton, undoButton, timerTitle, timerButton, playerCollectionView,
            nextScrollButton, incrementButton, previousScrollButton,
            addPointsCollectionView, letterCollectionView, resetTimerButton
        ]
        
        views.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            rollButton.centerYAnchor.constraint(equalTo: pageTitle.centerYAnchor),
            rollButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.horizontalMargin),
            rollButton.widthAnchor.constraint(equalToConstant: LayoutConstants.rollButtonSize),
            rollButton.heightAnchor.constraint(equalToConstant: LayoutConstants.rollButtonSize),
            
            timerTitle.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: LayoutConstants.timerTitleTopMargin),
            timerTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            resetTimerButton.centerYAnchor.constraint(equalTo: timerTitle.centerYAnchor),
            resetTimerButton.trailingAnchor.constraint(equalTo: timerTitle.leadingAnchor, constant: -LayoutConstants.timerButtonSpacing),
            resetTimerButton.widthAnchor.constraint(equalToConstant: LayoutConstants.resetTimerButtonWidth),
            resetTimerButton.heightAnchor.constraint(equalToConstant: LayoutConstants.resetTimerButtonHeight),
            
            timerButton.centerYAnchor.constraint(equalTo: timerTitle.centerYAnchor),
            timerButton.leadingAnchor.constraint(equalTo: timerTitle.trailingAnchor, constant: LayoutConstants.timerButtonSpacing),
            timerButton.widthAnchor.constraint(equalToConstant: LayoutConstants.timerButtonWidth),
            timerButton.heightAnchor.constraint(equalToConstant: LayoutConstants.timerButtonHeight),
            
            playerCollectionView.topAnchor.constraint(equalTo: timerTitle.bottomAnchor, constant: LayoutConstants.playerCollectionViewTopMargin),
            playerCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerCollectionView.heightAnchor.constraint(equalToConstant: LayoutConstants.playerCollectionViewHeight),
            
            incrementButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            incrementButton.topAnchor.constraint(equalTo: playerCollectionView.bottomAnchor, constant: LayoutConstants.incrementButtonTopMargin),
            incrementButton.widthAnchor.constraint(equalToConstant: LayoutConstants.incrementButtonSize),
            incrementButton.heightAnchor.constraint(equalToConstant: LayoutConstants.incrementButtonSize),
            
            addPointsCollectionView.topAnchor.constraint(equalTo: incrementButton.bottomAnchor, constant: LayoutConstants.addPointsCollectionViewTopMargin),
            addPointsCollectionView.widthAnchor.constraint(equalToConstant: LayoutConstants.addPointsCollectionViewWidth),
            addPointsCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addPointsCollectionView.heightAnchor.constraint(equalToConstant: LayoutConstants.addPointsCollectionViewHeight),
            
            previousScrollButton.centerYAnchor.constraint(equalTo: incrementButton.centerYAnchor),
            previousScrollButton.trailingAnchor.constraint(equalTo: incrementButton.leadingAnchor, constant: -LayoutConstants.scrollButtonSpacing),
            previousScrollButton.widthAnchor.constraint(equalToConstant: LayoutConstants.scrollButtonSize),
            previousScrollButton.heightAnchor.constraint(equalToConstant: LayoutConstants.scrollButtonSize),
            
            nextScrollButton.centerYAnchor.constraint(equalTo: incrementButton.centerYAnchor),
            nextScrollButton.leadingAnchor.constraint(equalTo: incrementButton.trailingAnchor, constant: LayoutConstants.scrollButtonSpacing),
            nextScrollButton.widthAnchor.constraint(equalToConstant: LayoutConstants.scrollButtonSize),
            nextScrollButton.heightAnchor.constraint(equalToConstant: LayoutConstants.scrollButtonSize),
            
            undoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.undoButtonLeadingMargin),
            undoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -LayoutConstants.undoButtonBottomMargin),
            undoButton.widthAnchor.constraint(equalToConstant: LayoutConstants.undoButtonWidth),
            undoButton.heightAnchor.constraint(equalToConstant: LayoutConstants.undoButtonHeight),
            
            letterCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            letterCollectionView.topAnchor.constraint(equalTo: addPointsCollectionView.bottomAnchor, constant: LayoutConstants.letterCollectionViewTopMargin),
            letterCollectionView.widthAnchor.constraint(equalToConstant: CGFloat(viewModel.getTotalUsers()) * LayoutConstants.letterCollectionViewItemWidth),
            letterCollectionView.heightAnchor.constraint(equalToConstant: LayoutConstants.letterCollectionViewHeight)
        ])
    }
    
    func setupTimerService() {
        viewModel.timerService.delegate = self
        viewModel.timerService.stop()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.updateTimerLabel(secondsElapsed: self.viewModel.getTimerSecondsElapsed())
            self.updateButtonState(isRunning: self.viewModel.getTimerIsRunning())
        }
    }
    
    func saveGameState() {
        guard viewModel.hasUsers() else { return }
        if let currentIndex = playerCollectionView.getCenterIndexPath()?.item,
           viewModel.isValidIndex(currentIndex) {
            viewModel.saveCurrentPlayerIndex(currentIndex)
        }
    }
    
    func restoreGameState() {
        guard viewModel.hasUsers() else { return }
        
        let savedPlayerIndex = viewModel.getCurrentPlayerIndex()
        guard viewModel.isValidIndex(savedPlayerIndex) else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self, self.viewModel.hasUsers() else { return }
            let indexPath = IndexPath(item: savedPlayerIndex, section: 0)
            
            guard self.viewModel.isValidIndex(indexPath.item) else { return }
            
            self.playerCollectionView.reloadData()
            self.playerCollectionView.layoutIfNeeded()
            
            self.playerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.selectLetterCollectionViewCell(indexPath)
            }
        }
    }
    
    func showDiceBlur() {
        blurView?.removeFromSuperview()

        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let blur = UIVisualEffectView(effect: blurEffect)
        blurView = blur

        guard let window = view.window else { return }
        
        window.addSubview(blur)
        
        blur.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blur.topAnchor.constraint(equalTo: window.topAnchor),
            blur.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            blur.trailingAnchor.constraint(equalTo: window.trailingAnchor),
            blur.bottomAnchor.constraint(equalTo: window.bottomAnchor)
        ])
        
        blur.alpha = 0
        UIView.animate(withDuration: 0.3) {
            blur.alpha = 1.0
        }
        let diceImage = UIImageView(image: UIImage(named: String(format: "dice_%d", Int.random(in: 1...6))))
        
        blur.contentView.addSubview(diceImage)
        diceImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            diceImage.centerXAnchor.constraint(equalTo: blur.contentView.centerXAnchor),
            diceImage.centerYAnchor.constraint(equalTo: blur.contentView.centerYAnchor),
            
            diceImage.heightAnchor.constraint(equalToConstant: LayoutConstants.diceImageSize),
            diceImage.widthAnchor.constraint(equalToConstant: LayoutConstants.diceImageSize)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeBlur))
        blur.addGestureRecognizer(tapGesture)
    }
    
    @objc func removeBlur() {
        UIView.animate(withDuration: 0.3, animations: {
            self.blurView?.alpha = 0
        }) { _ in
            self.blurView?.removeFromSuperview()
            self.blurView = nil
        }
    }
    
    func scrollToPlayer(offset: Int) {
        guard viewModel.hasUsers() else { return }
        guard let currentIndexPath = playerCollectionView.getCenterIndexPath() else { return }
        
        let currentIndex = currentIndexPath.item
        guard let newIndex = viewModel.getNextPlayerIndex(from: currentIndex, offset: offset) else { return }
        
        let indexPath = IndexPath(item: newIndex, section: 0)
        playerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        deselectLetterCollectionViewCell(currentIndexPath)
        selectLetterCollectionViewCell(indexPath)
        viewModel.saveCurrentPlayerIndex(newIndex)
    }
    
    func updateLetterCell(at indexPath: IndexPath, isSelected: Bool) {
        guard viewModel.isValidIndex(indexPath.item) else { return }
        if let cell = letterCollectionView.cellForItem(at: indexPath) as? LetterCollectionViewCell {
            cell.title.textColor = isSelected ? .white : .blackOlive
        } else if isSelected {
            letterCollectionView.reloadItems(at: [indexPath])
        }
    }
    
    func updateTimerLabel(secondsElapsed: Int) {
        let minutes = secondsElapsed / 60
        let seconds = secondsElapsed % 60
        timerTitle.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    @objc func startPauseButtonTapped() {
        if viewModel.getTimerIsRunning() {
            viewModel.pauseTimer()
        } else {
            viewModel.startTimer()
        }
    }
    
    func updateButtonState(isRunning: Bool) {
        if isRunning {
            timerButton.setImage(UIImage(named: "pause")?.withTintColor(.blackOlive), for: .normal)
            timerTitle.textColor = .white
        } else {
            timerButton.setImage(UIImage(named: "play"), for: .normal)
            timerTitle.textColor = .blackOlive
        }
    }
}

extension GameViewController: TimerServiceDelegate {
    func timerDidUpdate(secondsElapsed: Int) {
        updateTimerLabel(secondsElapsed: secondsElapsed)
    }
    
    func timerDidChangeState(isRunning: Bool) {
        updateButtonState(isRunning: isRunning)
    }
}

protocol CollectionViewCellDelegate: AnyObject {
    func didTapButton(in cell: UICollectionViewCell)
}
