//
//  ProductCollectionViewCell.swift
//  testTask_ProductCatalog
//
//  Created by Macbook Pro on 05.11.2021.
//

import UIKit
import Cosmos
class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var ratingControl: CosmosView!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    
    private var rating = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productImageView.layer.cornerRadius = 8
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        layer.cornerRadius = 8
        layer.masksToBounds = false
        layer.shadowRadius = 8.0
        layer.shadowOpacity = 0.10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: 8
        ).cgPath
    }
    
    func configureWithData(data: Products?) {
        productNameLabel.text = data?.name
        productDescriptionLabel.text = data?.discription
        productImageView.image = UIImage(named: data?.image ?? "")
        ratingControl.rating = getRating(data: data)
        
    }
    
    func getRating(data: Products?) -> Double {
        let comments: [Comments] = data?.comments?.allObjects as! [Comments]
        print(comments)
        if !comments.isEmpty {
            for comment in comments {
                rating = rating + comment.rate
            }
            let result = rating/Double(comments.count)
            rating = 0
            return result
        } else {
            return 0
        }
    }
    
}
