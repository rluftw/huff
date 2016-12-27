//
//  LoginViewController.swift
//  huff
//
//  Created by Xing Hui Lu on 12/6/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn

class LoginViewController: UIViewController, LoginOverlayViewDelegate {
    
    // MARK: - outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var loginOverlay: LoginOverlayView = {
        let overlay = LoginOverlayView(frame: self.view.bounds)
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.delegate = self
        return overlay
    }()
    
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        view.backgroundColor = UIColor(patternImage: UIImage(named: "smooth_wall")!)
    }

    // MARK: - actions
    
    @IBAction func facebookLogin(_ sender: Any) {
        self.userInteraction(halt: true)
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            guard error == nil, let accessToken = result?.token else {
                self.giveWarning(title: "Facebook Login", message: "Uh-oh, looks like there was an error logging in with your Facebook account")
                self.userInteraction(halt: false)
                return
            }
 
            // use the token to log in with firebase
            let facebookCredentials = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            FirebaseService.sharedInstance().signInWithSocialNetwork(credentials: facebookCredentials, completionHandler: { (user, error) in
                guard error == nil else {
                    self.giveWarning(title: "Facebook Login", message: "Snaps! looks like there was an error logging in with your Facebook account")
                    self.userInteraction(halt: false)
                    return
                }
                self.userInteraction(halt: false)
            })
        }
    }
    
    @IBAction func googleLogin(_ sender: Any) {
        self.userInteraction(halt: true)
        GIDSignIn.sharedInstance().signIn()
    }

    @IBAction func emailLogin(_ sender: Any) {
        self.view.addSubview(loginOverlay)
        
        loginOverlay.addAnchorsTo(topAnchor: self.view.topAnchor, rightAnchor: self.view.rightAnchor, bottomAnchor: self.view.bottomAnchor, leftAnchor: self.view.leftAnchor, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - Login overlay view delegate
    func showNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func login(email: String?, password: String?) {
        self.userInteraction(halt: true)
        guard let email = email else {
            self.giveWarning(title: "Login", message: "That's a funny looking email you have there")
            return
        }
        guard let password = password else {
            self.giveWarning(title: "Login", message: "You're going to need a password")
            return
        }
        
        FirebaseService.sharedInstance().signInWithEmail(email: email, password: password) { (user, error) in
            guard error == nil else {
                print("error: \(error!.localizedDescription)")
                self.giveWarning(title: "Login", message: error!.localizedDescription)
                self.userInteraction(halt: false)
                return
            }
            self.userInteraction(halt: false)
        }
        
    }
    
    // MARK: - helper methods
    func giveWarning(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    func userInteraction(halt: Bool) {
        halt ? activityIndicator.startAnimating():  self.activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = !halt
    }
}

extension LoginViewController: GIDSignInUIDelegate, GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            self.giveWarning(title: "Login", message: "Uh-oh, looks like there was an error logging in with your Google account")
            self.userInteraction(halt: false)
            return
        }
        
        let authentication = user!.authentication
        let idToken = authentication?.idToken ?? ""
        let accessToken = authentication?.accessToken ?? ""
        
        let googleCredentials = FIRGoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        FirebaseService.sharedInstance().signInWithSocialNetwork(credentials: googleCredentials) { (user, error) in
            guard error == nil else {
                self.giveWarning(title: "Login", message: "Snaps! looks like there was an error logging in with your Google account")
                self.userInteraction(halt: false)
                return
            }
            self.userInteraction(halt: false)
        }
    }
}
