//
//  DetailViewController.swift
//  testTask_ProductCatalog
//
//  Created by Macbook Pro on 05.11.2021.
//

import UIKit
protocol DetailsExerciseDelegate {
    func detailsWillDisappear(user: User?);
}
class DetailViewController: UIViewController {
    
    @IBOutlet weak var addCommentButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonBackgroundView: UIView!
    
    var user: User?
    var delegate : DetailsExerciseDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTableView()
        print("## detail userr", user)
    }
    
    override func viewWillDisappear(_ animated : Bool) {
           super.viewWillDisappear(animated)

           // When you want to send data back to the caller
           // call the method on the delegate
           if let delegate = self.delegate {
            delegate.detailsWillDisappear(user: user)
           }
       }
   
    func configureView(){
        buttonBackgroundView.layer.cornerRadius = 8
        addCommentButton.layer.cornerRadius = 8
        
        // Apply a shadow
        addCommentButton.layer.shadowRadius = 8.0
        addCommentButton.layer.shadowOpacity = 0.10
        addCommentButton.layer.shadowColor = UIColor.black.cgColor
        addCommentButton.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    @IBAction func addCommentButtonTapped(_ sender: Any) {
        user != nil ? openPopUp() : performSegue(withIdentifier: "showLogin", sender: self)
        
    }
    
    func openPopUp(){
        let storyboard = UIStoryboard(name: "Catalog", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "AddCommentPopupViewController")
        
        secondVC.modalPresentationStyle = .overFullScreen
        secondVC.modalTransitionStyle = .crossDissolve
        
        present(secondVC, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLogin" {
            let navigationController = segue.destination as! UINavigationController
            let nextVC = navigationController.topViewController as! LoginViewController
            nextVC.state = .loginForFullAccsess
            nextVC.callback = { user in
                print("## callback ", user)
                self.user = user
            }
        }
    }
}
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 5
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let productCell = tableView.dequeueReusableCell(withIdentifier: "productCell") as! ProductTableViewCell
            return productCell
        case 1:
            let comments = tableView.dequeueReusableCell(withIdentifier: "comments") as! CommentTableViewCell
            return comments
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 80
    }
    
}
