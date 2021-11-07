//
//  PerconalCabinetViewController.swift
//  testTask_ProductCatalog
//
//  Created by Macbook Pro on 05.11.2021.
//

import UIKit
import NotificationCenter

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var emailValidationErrorsLabel: UILabel!
    @IBOutlet weak var nameValidationErrorsLabel: UILabel!
    @IBOutlet weak var nameValidationErrorStack: UIStackView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var saveValidationErrorsLabel: UILabel!
    @IBOutlet weak var saveValidationErrorsStack: UIStackView!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var emailValidationErrorStack: UIStackView!
    @IBOutlet weak var editeProfileButton: UIButton!
    @IBOutlet weak var numberOfCommentsLabel: UILabel!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var editEmailTextField: UITextField!
    @IBOutlet weak var editNameTextField: UITextField!
    @IBOutlet weak var editPhotoButton: UIButton!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    
   private var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        editEmailTextField.delegate = self
        editNameTextField.delegate = self
        editNameTextField.tag = 1
        editEmailTextField.tag = 2
        
        configureView()
    }
    
    func configureView(){
        logOutButton.layer.cornerRadius = 5
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width/2
        avatarImageView.layer.borderWidth = 5
        avatarImageView.layer.borderColor = #colorLiteral(red: 0.9764705882, green: 0.968627451, blue: 0.9137254902, alpha: 1)
        
        editPhotoButton.layer.cornerRadius = 5
        changePasswordButton.layer.cornerRadius = 5
        
    }
    
    @IBAction func editProfileButtonTapped(_ sender: Any) {
        editNameTextField.text = nameLabel.text
        editEmailTextField.text = emailLabel.text
        editView.isHidden = false
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if checkData() {
            editView.isHidden = true
        }
        
       
    }
 
    @IBAction func editPhotoButtonTapped(_ sender: Any) {
       
        ImagePickerManager().pickImage(self){ image in
            self.avatarImageView.image = image
          }

    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
    }
    
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
       self.view.frame.origin.y = 0 - 150
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func validateEmail(enteredEmail: String?) -> Bool {
        guard enteredEmail != nil   else {
            emailValidationErrorsLabel.text = "Please, input your e-mail"
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
                emailValidationErrorsLabel.text = "Incorrect e-mail. Please, try again"
                emailValidationErrorStack.isHidden = false
            }
        }
        else {
            emailValidationErrorsLabel.text = "Please, input your e-mail"
            emailValidationErrorStack.isHidden = false
            return false
        }
        return false
    }
    
    func validateName(name: String?) -> Bool {
        guard name != nil   else {
            nameValidationErrorsLabel.text = "Please, input your name"
            nameValidationErrorStack.isHidden = false
            return false
        }
        if name!.count  > 2 {
            nameValidationErrorStack.isHidden = true
            return true
        } else {
            nameValidationErrorsLabel.text = "Input full name,please"
            nameValidationErrorStack.isHidden = false
            return false
        }
      
    }
    func checkData() -> Bool {
        if nameValidationErrorStack.isHidden == true && emailValidationErrorStack.isHidden == true  {
            if !(editNameTextField.text?.isEmpty ?? true) && !(editEmailTextField.text?.isEmpty ?? true) {
                nameLabel.text = editNameTextField.text
                emailLabel.text = editEmailTextField.text
                saveValidationErrorsStack.isHidden = true
            }
            
           return true
        }
        else if editNameTextField.text == "" || editNameTextField.text == nil || editEmailTextField.text == "" || editEmailTextField.text == nil {
            saveValidationErrorsLabel.text = "Please, cheak your data. Unable to save."
            saveValidationErrorsStack.isHidden = false
            
        }
        return false
    }
}

extension ProfileViewController: UITextFieldDelegate {
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField.tag {
        
        case 1:
            validateName(name: editNameTextField.text)
        case 2:
            validateEmail(enteredEmail:  editEmailTextField.text)
            
        default: break
        }
        
    }
}
