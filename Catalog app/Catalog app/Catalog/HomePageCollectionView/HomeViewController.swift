//
//  Home1ViewController.swift
//  testTask_ProductCatalog
//
//  Created by Macbook Pro on 05.11.2021.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var refreshControl: UIRefreshControl!
    
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var user: User?
    var data: [Products]?
    var filteredData: [Products]?
    
    private var selectedItem: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addProducts()
        configureView()
        configureKeyboard()
        
        print("## home userr", user)
        
    }
    func configureView(){
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = #colorLiteral(red: 0.3182727098, green: 0.5263802409, blue: 0.4970731735, alpha: 1)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        searchBar.delegate = self
        
        fetchProducts()
        filteredData = data
    }
    
    func configureKeyboard() {
        hideKeyboardWhenTappedAround()
        collectionView.keyboardDismissMode = .onDrag
        
    }
    
    func addProducts() {
        let newProduct = Products(context: context)
        newProduct.category = "Kids"
        newProduct.discription = "Best bed linen for kids. Material: cotton, size: 150x210"
        newProduct.id = UUID()
        newProduct.image = "kids"
        newProduct.name = "Batman"
        newProduct.rating = 5
        
        
        let newComment = Comments(context: context)
        newComment.id = UUID()
        newComment.productId = newProduct.id
        newComment.rate = 4
        newComment.time = Date()
        newComment.comment = "Its nice thing that I have but not perfect in wash, thank you so much"
        
        let newComment2 = Comments(context: context)
        newComment2.id = UUID()
        newComment2.productId = newProduct.id
        newComment2.rate = 5
        newComment2.time = Date()
        newComment2.comment = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. "
        
        let newUser = User(context: self.context)
        newUser.email = "email@gmail.com"
        newUser.password =  "test"
        newUser.image = UIImage(named: "noPhotoIcon")?.jpegData(compressionQuality: 1.0)
        newUser.name = "Alexa"
        newUser.commentsCount = 1
        newUser.id = UUID()
        
        let newUser2 = User(context: self.context)
        newUser2.email = "email2@gmail.com"
        newUser2.password =  "test"
        newUser2.image = UIImage(named: "annaPhoto")?.jpegData(compressionQuality: 1.0)
        newUser2.name = "Anna"
        newUser2.commentsCount = 1
        newUser2.id = UUID()
        
        newComment.user = newUser
        newComment2.user = newUser2
        
        newProduct.addToComments(newComment)
        newProduct.addToComments(newComment2)
        do {
            try  context.save()
        }
        catch {
            
        }
    }
    
    @objc func refresh(_ sender: Any) {
        
        collectionView.reloadData()
        refreshControl.endRefreshing()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let nextViewController =  segue.destination as! DetailViewController
        nextViewController.delegate = self
        nextViewController.user = self.user
        nextViewController.product = filteredData?[selectedItem?.row ?? 0]
    }
    
}
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredData?.count ?? 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "product", for: indexPath) as! ProductCollectionViewCell
        cell.configureWithData(data: filteredData?[indexPath.row])
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        selectedItem = indexPath
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing : CGFloat = (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0.0
        let widthPerItem = (view.frame.width  - spacing * 2)/2
        return CGSize(width: widthPerItem, height: 300)
    }
    
    
    
}
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? data : data?.filter { ($0.name?.lowercased().contains(searchText.lowercased())) != nil || (($0.discription?.lowercased().contains(searchText.lowercased())) != nil)  }
        collectionView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.endEditing(true)
    }
}

extension HomeViewController: DetailsExerciseDelegate {
    func detailsWillDisappear(user: User?) {
        self.user = user
    }
    
}

extension HomeViewController {
    func fetchProducts(){
        do{
            let request = Products.fetchRequest() as  NSFetchRequest<Products>
            self.data = try context.fetch(request)
        }
        catch {
            
        }
    }
}
