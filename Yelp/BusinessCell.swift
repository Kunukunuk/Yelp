//
//  BusinessCell.swift
//  Yelp
//
//  Created by Kun Huang on 9/19/18.
//  Copyright © 2018 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var foodCategoryLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var business: Business!{
        didSet{
            nameLabel.text = business.name
            thumbImageView.setImageWith(business.imageURL!)
            foodCategoryLabel.text = business.categories
            addressLabel.text = business.address
            reviewLabel.text = "\(business.reviewCount) Reviews"
            ratingImageView.image = business.ratingImage
            distanceLabel.text = business.distance
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
