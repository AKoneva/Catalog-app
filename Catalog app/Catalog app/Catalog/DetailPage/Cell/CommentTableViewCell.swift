//
//  CommentTableViewCell.swift
//  testTask_ProductCatalog
//
//  Created by Macbook Pro on 05.11.2021.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = 5
    }

    func getDateTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM YY, hh:mm"
        return dateFormatter.string(from: date)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureWithData(data: Comments) {
        let defaultImage = UIImage(named: "noPhotoIcon")!.pngData()
        avatarImageView.image = UIImage(data: (data.user?.image ?? defaultImage)!)
        nameLabel.text = data.user?.name 
        commentLabel.text = data.comment
        dateLabel.text = getDateTime(date: data.time ?? Date())
    }
    
}
