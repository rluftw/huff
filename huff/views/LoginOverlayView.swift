//
//  LoginView.swift
//  huff
//
//  Created by Xing Hui Lu on 12/8/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit

/*
 color palette
 =============
 red - 204, 0, 0
 yellow - 255, 193, 0
 green - 0, 153, 0
 blue - 0,102,204
 */

protocol LoginOverlayViewDelegate: class {
    func showNavigationBar()
    func login(email: String?, password: String?)
}

class LoginOverlayView: UIView {

    // MARK: - properties
    weak var delegate: LoginOverlayViewDelegate?
    
    // MARK: - outlets
    lazy var emailTF: UnderlinerTextField = {
        let tf = self.createTextFieldWithPlaceholder(title: "Email")
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    lazy var passwordTF: UnderlinerTextField = {
        let tf = self.createTextFieldWithPlaceholder(title: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var loginButton: UIButton = {
        let button = self.createButtonWith(title: "Login", image: nil, selector: #selector(login))
        button.backgroundColor = UIColor(red: 0, green: 153/255.0, blue: 0, alpha: 1)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = self.createButtonWith(title: nil, image: UIImage(named: "close"), selector: #selector(cancelLogin))
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return button
    }()
    
    
    // MARK: - initiazation
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - helper methods
    
    func setupViews() {
        // create the background blur effect
        let blurEffect = UIBlurEffect(style: .light)
        let visualView = UIVisualEffectView(effect: blurEffect)
        visualView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(visualView)
        visualView.addAnchorsTo(topAnchor: topAnchor, rightAnchor: rightAnchor, bottomAnchor: bottomAnchor, leftAnchor: leftAnchor)
        
        
        // create the components of the view
        let containerView = UIView()
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(loginButton)
        containerView.addSubview(cancelButton)

        // set the container view dimensions
        containerView.addAnchorsTo(topAnchor: nil, rightAnchor: rightAnchor, bottomAnchor: nil, leftAnchor: leftAnchor, topConstant: 0, rightConstant: -16, bottomConstant: 0, leftConstant: 16)
        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        loginButton.addAnchorsTo(topAnchor: nil, rightAnchor: containerView.rightAnchor, bottomAnchor: containerView.bottomAnchor, leftAnchor: containerView.leftAnchor, topConstant: 0, rightConstant: -16, bottomConstant: -16, leftConstant: 16)
        
        // create the stackview for the textfield
        let tfStackView = UIStackView()
        tfStackView.axis = .vertical
        tfStackView.spacing = 10
        tfStackView.translatesAutoresizingMaskIntoConstraints = false
        tfStackView.insertArrangedSubview(passwordTF, at: 0)
        tfStackView.insertArrangedSubview(emailTF, at: 0)
        addSubview(tfStackView)
        
        // set the cancelButton and the stackviews dimensions
        cancelButton.addAnchorsTo(topAnchor: containerView.topAnchor, rightAnchor: nil, bottomAnchor: tfStackView.topAnchor, leftAnchor: containerView.leftAnchor, topConstant: 16, rightConstant: 0, bottomConstant: -24, leftConstant: 16)
        tfStackView.addAnchorsTo(topAnchor: nil, rightAnchor: containerView.rightAnchor, bottomAnchor: loginButton.topAnchor, leftAnchor: containerView.leftAnchor, topConstant: 0, rightConstant: -16, bottomConstant: -16, leftConstant: 16)
    }
    
    func cancelLogin() {
        delegate?.showNavigationBar()
        self.removeFromSuperview()
    }
    
    func login() {
        print("Attempting to log in")
        delegate?.login(email: emailTF.text, password: passwordTF.text)
    }
    
    func createTextFieldWithPlaceholder(title: String) -> UnderlinerTextField {
        let tf = UnderlinerTextField()
        tf.placeholder = title
        tf.font = UIFont(name: "RobotoMono-Regular", size: 17)
        tf.textColor = .white
        tf.tintColor = .white
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none

        tf.backgroundColor = UIColor(red: 0, green: 102/255.0, blue: 204/255.0, alpha: 1)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return tf
    }
    
    func createButtonWith(title: String?, image: UIImage?, selector: Selector?) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "RobotoMono-Regular", size: 17)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        if let selector = selector {
            button.addTarget(self, action: selector, for: .touchUpInside)
        }
        return button
    }
}
