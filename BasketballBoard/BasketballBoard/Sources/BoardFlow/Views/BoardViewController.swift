//
//  BoardViewController.swift
//  BasketballBoard
//
//  Created by Eva on 29.05.2024.
//

import UIKit

final class BoardViewController: UIViewController {
    
    // MARK: - UI components
    private lazy var shootButton: UIButton = {
        let button = UIButton()
        button.setTitle("ShootBall", for: .normal)
        button.addTarget(self, action: #selector(shootButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var defendersButton: UIButton = {
        let button = UIButton()
        button.setTitle("Defenders", for: .normal)
        button.addTarget(self, action: #selector(defendButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var changeSideButton: UIButton = {
        let button = UIButton()
        button.setTitle("СourtSide", for: .normal)
        button.addTarget(self, action: #selector(changeSideButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("StartOver", for: .normal)
        button.addTarget(self, action: #selector(setPointButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.alignment = .bottom
        stackView.spacing = 5
        
        return stackView
    }()
    
    // MARK: - Properties
    private var viewModel: BoardViewModelProtocol!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Methods
    private func setupButtonsStackView() {
        view.addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        [shootButton, defendersButton, changeSideButton, resetButton].forEach { button in
            button.setTitleColor(.black, for: .normal)
            button.setTitleColor(.black.withAlphaComponent(0.3), for: .highlighted)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            let width = button.titleLabel?.intrinsicContentSize.width
            
            let containerView = UIView()
            containerView.addSubview(button)
            
            
            NSLayoutConstraint.activate([
                button.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                button.widthAnchor.constraint(equalToConstant: width ?? .zero),
                button.topAnchor.constraint(equalTo: containerView.topAnchor),
                button.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
            
            buttonsStackView.addArrangedSubview(containerView)
        }
    }
    
    private func setup() {
        viewModel = BoardViewModel()
        viewModel.basketballBoardInstaller.view = view
        viewModel.setBasketballBoardWithPlayers()
        setupButtonsStackView()
    }
     
     @objc private func shootButtonPressed() {
         viewModel.shootBall()
     }
     
     @objc private func setPointButtonPressed() {
         viewModel.setPlayersToOriginPoints()
     }
     
     @objc private func defendButtonPressed() {
         viewModel.showOrHideDefenders()
     }
     
     @objc private func changeSideButtonPressed() {
         viewModel.changeSideOfCourt()
     }
 }
