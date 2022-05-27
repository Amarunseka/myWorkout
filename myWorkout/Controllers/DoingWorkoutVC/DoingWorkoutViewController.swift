//
//  DoingWorkoutViewController.swift
//  myWorkout
//
//  Created by Миша on 14.04.2022.
//

import UIKit

class DoingWorkoutViewController: UIViewController {

    // MARK: - initialise elements
    var isTimerMode: Bool
    
    private let startWorkoutLabel = UILabel.bigGrayLabel(text: "START WORKOUT")
    private lazy var closeButton = CloseButton(viewController: self)
    private let detailsLabel = UILabel.smallBrownLabel(text: "Details")
    private let detailsView = DetailsView()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private lazy var finishButton = SaveButton(text: "FINISH") { [weak self] in
        self?.finishButtonTapped()
    }

    // MARK: - live cycle
    init(isTimerMode: Bool) {
        self.isTimerMode = isTimerMode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }

    // MARK: - methods-actions
    private func setupViews() {
        view.backgroundColor = .specialBackground
        setupImageView()
        view.addSubview(startWorkoutLabel)
        view.addSubview(closeButton)
        view.addSubview(imageView)
        view.addSubview(detailsLabel)
        view.addSubview(detailsView)
        view.addSubview(finishButton)
    }
    
    private func setupImageView(){
        if isTimerMode {
            imageView.image = UIImage(named: "ellipse")
        } else {
            imageView.image = UIImage(named: "girlWithBarbells")
        }
    }
    
    private func finishButtonTapped(){
        print("finishButtonTapped")
    }
}

// MARK: - Constraints
extension DoingWorkoutViewController {
    private func setupConstraints() {
        let constraints = [
            startWorkoutLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            startWorkoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            
            closeButton.centerYAnchor.constraint(equalTo: startWorkoutLabel.centerYAnchor, constant: 0),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor),
            
            imageView.topAnchor.constraint(equalTo: startWorkoutLabel.bottomAnchor, constant: 25),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            imageView.heightAnchor.constraint(equalToConstant: 280),
            
            detailsLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            detailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            detailsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            detailsView.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 0),
            detailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            detailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            detailsView.heightAnchor.constraint(equalToConstant: 250),
            
            finishButton.topAnchor.constraint(equalTo: detailsView.bottomAnchor, constant: 20),
            finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            finishButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
