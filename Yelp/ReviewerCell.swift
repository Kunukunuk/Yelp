//
//  ReviewerCell.swift
//  Yelp
//
//  Created by Kun Huang on 9/25/18.
//  Copyright © 2018 Timothy Lee. All rights reserved.
//

import UIKit

class ReviewerCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var datePostedLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var reviewLabel: UILabel!
    
    var reviews: BusinessReview! {
        didSet{
            userName.text = reviews.reviewerName
            datePostedLabel.text = reviews.dateCreated
            userImageView.setImageWith(reviews.reviewerImage!)
            ratingLabel.text = "Rating: \(reviews.rating!)"
            reviewLabel.text = reviews.reviewText
            ratingImage.image = reviews.ratingImage
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
