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
    var state: HomeState = .products
    var currentCategory = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureKeyboard()
       
        print("## home userr", user)
        print("## data count", filteredData?.count)
        
    }
    func configureView(){
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = #colorLiteral(red: 0.3182727098, green: 0.5263802409, blue: 0.4970731735, alpha: 1)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        searchBar.delegate = self
       
        if state == .categoryProducts {
            fetchCategoryProducts()
        }
        else{
            fetchProducts()
            addProducts()
        }
        filteredData = data

    }
    
    func configureKeyboard() {
        hideKeyboardWhenTappedAround()
        collectionView.keyboardDismissMode = .onDrag
        
    }
    
    func addProducts() {
        if data?.count ?? 0 < 1{
            let kidsProduct = Products(context: context)
            kidsProduct.category = "Kids"
            kidsProduct.discription = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Material: cotton, size: 150x210"
            kidsProduct.id = UUID()
            kidsProduct.image = "kids"
            kidsProduct.name = "Batman"
            kidsProduct.rating = 5
            
            
            let newComment = Comments(context: context)
            newComment.id = UUID()
            newComment.productId = kidsProduct.id
            newComment.rate = 4
            newComment.time = Date()
            newComment.comment = "Its nice thing that I have but not perfect in wash, thank you so much"
            
            let newComment2 = Comments(context: context)
            newComment2.id = UUID()
            newComment2.productId = kidsProduct.id
            newComment2.rate = 5
            newComment2.time = Date()
            newComment2.comment = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. "
            
            let alexsaUser = User(context: self.context)
            alexsaUser.email = "email@gmail.com"
            alexsaUser.password =  "test"
            alexsaUser.image = UIImage(named: "noPhotoIcon")?.jpegData(compressionQuality: 1.0)
            alexsaUser.name = "Alexa"
            alexsaUser.commentsCount = 1
            alexsaUser.id = UUID()
            
            let annaUser = User(context: self.context)
            annaUser.email = "email2@gmail.com"
            annaUser.password =  "test"
            annaUser.image = UIImage(named: "annaPhoto")?.jpegData(compressionQuality: 1.0)
            annaUser.name = "Anna"
            annaUser.commentsCount = 1
            annaUser.id = UUID()
            
            newComment.user = alexsaUser
            newComment2.user = annaUser
            
            kidsProduct.addToComments(newComment)
            kidsProduct.addToComments(newComment2)
            
            
            let smallSizeProduct = Products(context: context)
            smallSizeProduct.category = "Small sizes"
            smallSizeProduct.discription = "Liven up your bedroom. Settle in her awe and lightness. This design perfectly combines solid milk chocolate-colored elements with a print pattern on a light gray background. Material: cotton, size: 150x210"
            smallSizeProduct.id = UUID()
            smallSizeProduct.image = "small"
            smallSizeProduct.name = "Sleep well"
            smallSizeProduct.rating = 5
            
            let newCommentForSmallSize = Comments(context: context)
            newCommentForSmallSize.id = UUID()
            newCommentForSmallSize.productId = smallSizeProduct.id
            newCommentForSmallSize.rate = 5
            newCommentForSmallSize.time = Date()
            newCommentForSmallSize.comment = "Thank you so much"
            newCommentForSmallSize.user = alexsaUser
            
            smallSizeProduct.addToComments(newCommentForSmallSize)
            
            let mediumSizeProduct = Products(context: context)
            mediumSizeProduct.category = "Medium sizes"
            mediumSizeProduct.discription = "In a house where it smells of comfort, and every little thing is saturated with love, you always want to return. To bring even more warmth and emphasize the mood of your abode will help the Single-colored bedding set Blue space (double-euro). The Berni online store takes care of the best in your family nest: and for this you do not need to spend a lot of money. Product Bedding set monophonic Blue space (double-euro) is presented in the catalog at an affordable price. Place an order on the website online and pick up the parcel at the nearest branch of the carrier. Surrounding yourself with beauty is so easy! Material: cotton, size: 190 x210"
            mediumSizeProduct.id = UUID()
            mediumSizeProduct.image = "medium"
            mediumSizeProduct.name = "Medium size best suggestion"
            mediumSizeProduct.rating = 5
            
            let kingSizeProduct = Products(context: context)
            kingSizeProduct.category = "King sizes"
            kingSizeProduct.discription = "Test task is a Ukrainian manufacturer of bed linen. These sets are made of certified fabric. We have 3 levels of quality check before shipment. Checking the quality of fabric, checking the quality of sewing, checking the quality of packaging. You can definitely be sure that quality goods will come to you.Material: cotton, size: 210x210"
            kingSizeProduct.id = UUID()
            kingSizeProduct.image = "kingDark"
            kingSizeProduct.name = "Best dark"
            kingSizeProduct.rating = 5
            
            let saleProduct = Products(context: context)
            saleProduct.category = "Sales"
            saleProduct.discription = " Product Bedding set monophonic Blue space (double-euro) is presented in the catalog at an affordable price. Place an order on the website online and pick up the parcel at the nearest branch of the carrier. Surrounding yourself with beauty is so easy! Material: cotton, size: 190x190"
            saleProduct.id = UUID()
            saleProduct.image = "image"
            saleProduct.name = "Discounts here"
            saleProduct.rating = 5
            
            let saleSecondProduct = Products(context: context)
            saleSecondProduct.category = "Sales"
            saleSecondProduct.discription = "In a house where it smells of comfort, and every little thing is saturated with love, you always want to return. To bring even more warmth and emphasize the mood of your abode will help the Single-colored bedding set Blue space (double-euro). The Berni online store takes care of the best in your family nest: and for this you do not need to spend a lot of money. Product Bedding set monophonic Blue space (double-euro) is presented in the catalog at an affordable price. Place an order on the website online and pick up the parcel at the nearest branch of the carrier. Surrounding yourself with beauty is so easy! Material: cotton, size: 190 x210"
            saleSecondProduct.id = UUID()
            saleSecondProduct.image = "sale"
            saleSecondProduct.name = "Discounts best"
            
            saleSecondProduct.rating = 5
            do {
                try  context.save()
            }
            catch {
                
            }
            fetchProducts()
        }
        
    }
    
    @objc func refresh(_ sender: Any) {
        fetchProducts()
        collectionView.reloadData()
        refreshControl.endRefreshing()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail" {
            if let cell = sender as? ProductCollectionViewCell {
                let indexPath = cell.tag
                if let nextViewController = segue.destination as? DetailViewController {
                    nextViewController.delegate = self
                    nextViewController.user = self.user
                    nextViewController.product = filteredData?[indexPath]
                }
            }
        }
    }
    
}
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "product", for: indexPath) as! ProductCollectionViewCell
        cell.configureWithData(data: filteredData?[indexPath.row])
        cell.tag = indexPath.row
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing : CGFloat = (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0.0
        let widthPerItem = (view.frame.width  - spacing * 2)/2
        return CGSize(width: widthPerItem, height: 300)
    }
   
}
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? data : data?.filter { $0.name!.lowercased().contains(searchText.lowercased())  || $0.discription!.lowercased().contains(searchText.lowercased())  }
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
    func fetchCategoryProducts(){
        do{
            let request = Products.fetchRequest() as  NSFetchRequest<Products>
            let filter = NSPredicate(format: "category CONTAINS %@", currentCategory)
            request.predicate = filter
            self.data = try context.fetch(request)
        }
        catch {
            
        }
    }
}
enum HomeState : String {
    case products = "products"
    case categoryProducts = "categoryProducts"
}
