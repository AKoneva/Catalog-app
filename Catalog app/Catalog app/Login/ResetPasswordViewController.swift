//
//  ResetPasswordViewController.swift
//  testTask_ProductCatalog
//
//  Created by Macbook Pro on 04.11.2021.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var emailValidationErrorStack: UIStackView!
    @IBOutlet weak var emailValidationErrorLabel: UILabel!
    @IBOutlet weak var userEmailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        userEmailTextField.delegate = self
        resetButton.layer.cornerRadius = 6
    }
    
    
    @IBAction func resetPasswordButtonTapped(_ sender: Any) {
        if validateEmail(enteredEmail: userEmailTextField.text) {
            let alert = UIAlertController(title: "Done", message: "We send you email with your new password. You can change it in your personal cabinet (this is stub)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else {
            let alert = UIAlertController(title: "Error", message: "Please, check your email", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func validateEmail(enteredEmail:String?) -> Bool {
        guard enteredEmail != nil else {
            emailValidationErrorLabel.text = "Please, input your e-mail"
            emailValidationErrorStack.isHidden = false
            return false
        }
        if(enteredEmail != ""){
            
            let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
            
            if(emailPredicate.evaluate(with: enteredEmail)) {
                emailValidationErrorStack.isHidden = true
                return true
            }
            else {
                emailValidationErrorLabel.text = "Incorrect e-mail. Please, try again"
                emailValidationErrorStack.isHidden = false
            }
        }
        else {
            emailValidationErrorLabel.text = "Please, input your e-mail"
            emailValidationErrorStack.isHidden = false
            return false
            
        }
        return false
    }
    
    
}
extension ResetPasswordViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        validateEmail(enteredEmail: userEmailTextField.text)
        
    }
}

