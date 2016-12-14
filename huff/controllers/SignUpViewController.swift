//
//  SignUpViewController.swift
//  huff
//
//  Created by Xing Hui Lu on 12/7/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {

    // MARK: - outlets
    @IBOutlet weak var email: UnderlinerTextField!
    @IBOutlet weak var password: UnderlinerTextField!
    @IBOutlet weak var confirmPassword: UnderlinerTextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textfieldContainerStack: UIStackView!

    // MARK: - properties
    var ref: FIRDatabaseReference!
    
    // MARK: - computed properties
    var readyToContinue: Bool {
        // check if they all have values
        guard let email = self.email.text, let password = self.password.text, let confirmPassword = self.confirmPassword.text else {
            self.giveWarning(title: "Sign Up", message: "It looks like one or more fields are empty")
            return false
        }
        // verify the email
        guard isValidEmail(testStr: email) else {
            self.giveWarning(title: "Sign Up", message: "That's a funny looking email you have there")
            return false
        }
        // verify that the password is at least 8 characters long
        guard password.characters.count >= 8 else {
            self.giveWarning(title: "Sign Up", message: "Think of a better password, one that's 8 characters or longer")
            return false
        }
        // verify that the passwords match
        guard password == confirmPassword else {
            self.giveWarning(title: "Sign Up", message: "Make sure your passwords match")
            return false
        }
        return true
    }
    
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        email.delegate = self
        password.delegate = self
        confirmPassword.delegate = self
        
        let endKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(endKeyboardTap)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - actions
    @IBAction func goToHome(_ sender: Any) {
        if readyToContinue {
            userInteraction(halt: true)
            FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!, completion: { (user: FIRUser?, error: Error?) in
                guard error == nil else {
                    self.giveWarning(title: "Sign Up", message: error!.localizedDescription)
                    self.userInteraction(halt: false)
                    return
                }
                
                let values: [String: Any] = [
                    "creation_date": Date().timeIntervalSince1970,
                ]
                
                self.ref.child("users/\(user!.uid)").setValue(values)
                user?.sendEmailVerification(completion: nil)
                
                // dismiss this view controller
                let window = (UIApplication.shared.delegate as? AppDelegate)?.window
                window?.rootViewController?.dismiss(animated: false, completion: nil)
            })
        }
    }
    
    
    // MARK: - helper methods
    func isValidEmail(testStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    func giveWarning(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    func userInteraction(halt: Bool) {
        halt ? self.activityIndicator.startAnimating(): self.activityIndicator.stopAnimating()
        self.textfieldContainerStack.isUserInteractionEnabled = !halt
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }

    
}


extension SignUpViewController: UITextFieldDelegate {
    // MARK: - textfield delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let tag = textField.tag
        guard let nextTextField = self.view.viewWithTag(tag+1) as? UITextField else {
            // Since this is the last text field
            return textField.resignFirstResponder()
        }
        return nextTextField.becomeFirstResponder()
    }
}
