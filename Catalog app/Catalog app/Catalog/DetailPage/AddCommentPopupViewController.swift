//
//  AddCommentViewController.swift
//  testTask_ProductCatalog
//
//  Created by Macbook Pro on 07.11.2021.
//

import UIKit
import NotificationCenter
import CoreData
import Cosmos

class AddCommentPopupViewController: UIViewController {
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingControl: CosmosView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var commentView: UIView!
    
    var user: User?
    var product: Products?
    var callback : ((Comments) -> Void)?
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureKeyboard()
    }
    
    
    //MARK:- Configuration
    
    func configureView() {
        commentView.layer.cornerRadius = 8
        cancelButton.layer.cornerRadius = 8
        doneButton.layer.cornerRadius = 8
        ratingLabel.text = "Rate" + (product?.name)!
        
        commentTextView.delegate = self
        
        commentTextView.text = "Input your comment here"
        commentTextView.textColor = UIColor.lightGray
        commentTextView.backgroundColor = .white
        commentTextView.layer.cornerRadius = 8
        commentTextView.layer.shadowRadius = 8.0
        commentTextView.layer.shadowOpacity = 0.04
        commentTextView.layer.shadowColor = UIColor.black.cgColor
        commentTextView.layer.shadowOffset = CGSize(width: 0, height: 5)
        
    }
    
    func configureKeyboard() {
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y = 0 - 150
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    
    //MARK:- Buttons action
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func doneButtonTapped(_ sender: Any) {
        let newComment = Comments(context: context)
        newComment.id = UUID()
        newComment.rate = ratingControl.rating
        newComment.time = Date()
        newComment.user = user
        newComment.productId = product?.id
        if commentTextView.text == "Input your comment here" {
            newComment.comment = ""
            
        } else {
            newComment.comment = commentTextView.text
        }
        user?.commentsCount += 1
        do {
            try  context.save()
        }
        catch {
            
        }
        callback?(newComment)
        self.dismiss(animated: true)
    }
    
}


//MARK:- Extensions

extension AddCommentPopupViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Input your comment here"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
