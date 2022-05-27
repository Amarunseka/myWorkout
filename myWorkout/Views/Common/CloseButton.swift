//
//  CloseButton.swift
//  myWorkout
//
//  Created by Миша on 12.04.2022.
//

import UIKit

class CloseButton: UIButton {
    
    private var viewController: UIViewController?
    
    convenience init(viewController: UIViewController) {
        self.init(type: .system)
        self.viewController = viewController
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView(){
        translatesAutoresizingMaskIntoConstraints = false
        setBackgroundImage(UIImage(named: "closeButton"), for: .normal)
        addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func closeButtonTapped() {
        viewController?.dismiss(animated: true)
    }
}
