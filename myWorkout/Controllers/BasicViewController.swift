//
//  BasicViewController.swift
//  myWorkout
//
//  Created by Миша on 13.05.2022.
//

import UIKit

class BasicViewController: UIViewController {

    // MARK: - initialise elements
    lazy var titleLabel = UILabel.bigGrayLabel(text: "")
    private lazy var closeButton = CloseButton(viewController: self)

    // MARK: - live cycle
    init(titleText: String, closeButtonIsHidden: Bool) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = titleText
        closeButton.isHidden = closeButtonIsHidden
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBasicViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupBasicConstraints()
    }
    
    // MARK: - methods-actions
    private func setupBasicViews() {
        view.backgroundColor = .specialBackground
        view.addSubview(titleLabel)
        view.addSubview(closeButton)
    }

}

// MARK: - Constraints
extension BasicViewController {
    private func setupBasicConstraints() {
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor, constant: 0),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

