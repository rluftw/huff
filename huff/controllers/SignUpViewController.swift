//
//  SignUpViewController.swift
//  huff
//
//  Created by Xing Hui Lu on 12/7/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstName: UnderlinerTextField!
    @IBOutlet weak var lastName: UnderlinerTextField!
    @IBOutlet weak var email: UnderlinerTextField!
    @IBOutlet weak var password: UnderlinerTextField!
    @IBOutlet weak var confirmPassword: UnderlinerTextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textfieldContainerStack: UIStackView!
    
    var readyToContinue: Bool {
        // check if they all have values
        guard let firstName = self.firstName.text, let lastName = self.lastName.text, let email = self.email.text, let password = self.password.text, let confirmPassword = self.confirmPassword.text else {
            self.giveWarning(title: "Sign Up", message: "It looks like one of the fields are empty")
            return false
        }
        // verify the name values
        guard firstName.characters.count > 0 && lastName.characters.count > 0 else {
            // TODO: show an alert controller - mention that name fields must be filled
            self.giveWarning(title: "Sign Up", message: "It looks like one of the name fields are empty")
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
        
        firstName.delegate = self
        lastName.delegate = self
        email.delegate = self
        password.delegate = self
        confirmPassword.delegate = self
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @IBAction func goToHome(_ sender: Any) {
        if readyToContinue {
            userInteraction(halt: true)
            FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!, completion: { (user, error) in
                guard error == nil else {
                    self.giveWarning(title: "Sign Up", message: error!.localizedDescription)
                    self.userInteraction(halt: false)
                    return
                }
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "finishSignup", sender: self)
                    self.userInteraction(halt: false)
                }
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
}


extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let tag = textField.tag
        guard let nextTextField = self.view.viewWithTag(tag+1) as? UITextField else {
            // Since this is the last text field, initiate the go to home method
            self.goToHome(self)
            return textField.resignFirstResponder()
        }
        return nextTextField.becomeFirstResponder()
    }
    
    // helper method for keyboard shifting
    func getKeyboardHeight() -> CGSize {
        return .zero
    }
}
