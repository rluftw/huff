//
//  LoginViewController.swift
//  huff
//
//  Created by Xing Hui Lu on 12/6/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, LoginOverlayViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(patternImage: UIImage(named: "smooth_wall")!)
    }

    @IBAction func facebookLogin(_ sender: Any) {
    }
    
    @IBAction func googleLogin(_ sender: Any) {
    }

    @IBAction func emailSignup(_ sender: Any) {
    }
    
    @IBAction func emailLogin(_ sender: Any) {
        let loginOverlay = LoginOverlayView(frame: self.view.bounds)
        loginOverlay.translatesAutoresizingMaskIntoConstraints = false
        loginOverlay.layer.cornerRadius = 5
        loginOverlay.delegate = self
        
        self.view.addSubview(loginOverlay)
        
        loginOverlay.addAnchorsTo(topAnchor: self.view.topAnchor, rightAnchor: self.view.rightAnchor, bottomAnchor: self.view.bottomAnchor, leftAnchor: self.view.leftAnchor, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - Login overlay view delegate
    func showNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func login(email: String?, password: String?) {
        guard let email = email else {
            self.giveWarning(title: "Login", message: "That's a funny looking email you have there")
            return
        }
        guard let password = password else {
            self.giveWarning(title: "Login", message: "You're going to need a password")
            return
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
            guard error == nil else {
                self.giveWarning(title: "Login", message: error!.localizedDescription)
                return
            }
        })
    }
    
    // MARK: - helper methods
    func giveWarning(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
