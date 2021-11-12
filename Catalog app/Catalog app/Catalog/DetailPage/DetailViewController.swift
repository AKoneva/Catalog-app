//
//  DetailViewController.swift
//  testTask_ProductCatalog
//
//  Created by Macbook Pro on 05.11.2021.
//

import UIKit
import CoreData

protocol DetailsExerciseDelegate {
    func detailsWillDisappear(user: User?);
}

class DetailViewController: UIViewController {
    
    @IBOutlet weak var addCommentButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonBackgroundView: UIView!
    
    
    private var refreshControl: UIRefreshControl!
    
    var user: User?
    var delegate : DetailsExerciseDelegate?
    var product: Products?
    var commentsArray : [Comments?]?
    private let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTableView()
        
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        if let delegate = self.delegate {
            delegate.detailsWillDisappear(user: user)
        }
        
    }
    
    
    //MARK:- Configuration
    
    func configureView() {
        buttonBackgroundView.layer.cornerRadius = 8
        addCommentButton.layer.cornerRadius = 8
        
        // Apply a shadow
        addCommentButton.layer.shadowRadius = 8.0
        addCommentButton.layer.shadowOpacity = 0.10
        addCommentButton.layer.shadowColor = UIColor.black.cgColor
        addCommentButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        commentsArray = product?.comments?.toArray()
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = #colorLiteral(red: 0.3182727098, green: 0.5263802409, blue: 0.4970731735, alpha: 1)
        refreshControl.addTarget(self, action: #selector(refresh), for: .allEvents)
        
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.refreshControl = refreshControl
        
    }
    
    
    //MARK:- Buttons action
    
    @objc func refresh(_ sender: Any) {
        self.fetchProduct()
        tableView.reloadData()
        refreshControl.endRefreshing()
        
    }
    
    @IBAction func addCommentButtonTapped(_ sender: Any) {
        user != nil ? performSegue(withIdentifier: "comment", sender: self) : performSegue(withIdentifier: "showLogin", sender: self)
        
    }
    
    
    //MARK:- Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLogin" {
            let navigationController = segue.destination as! UINavigationController
            let nextVC = navigationController.topViewController as! LoginViewController
            nextVC.state = .loginForFullAccsess
            nextVC.callback = { user in
                self.user = user
            }
        }
        if segue.identifier == "comment" {
            let nextVC = segue.destination as! AddCommentPopupViewController
            nextVC.product = self.product
            nextVC.user = self.user
            nextVC.callback = { comment in
                self.product?.addToComments(comment)
                self.commentsArray?.append(comment)
                try! self.context.save()
                self.fetchProduct()
                self.tableView.reloadData()
            }
        }
    }
}


//MARK:- Extensions

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return product?.comments?.count ?? 0
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let productCell = tableView.dequeueReusableCell(withIdentifier: "productCell") as! ProductTableViewCell
            productCell.configureWithData(data: product)
            return productCell
        case 1:
            let comments = tableView.dequeueReusableCell(withIdentifier: "comments") as! CommentTableViewCell
            
            comments.configureWithData(data: commentsArray?[indexPath.row] ?? Comments())
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

extension DetailViewController {
    func fetchProduct(){
        do{
            let request = Products.fetchRequest() as  NSFetchRequest<Products>
            let filter = NSPredicate(format:  "%K == %@", "id", product!.id! as CVarArg)
            request.predicate = filter
            self.product = try context.fetch(request).first ?? nil
        }
        catch {
            
        }
    }
}
