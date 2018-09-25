//
//  DetailsViewController.swift
//  Yelp
//
//  Created by Kun Huang on 9/24/18.
//  Copyright © 2018 Timothy Lee. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var singleBusiness: Business?
    var reviews: [BusinessReview]!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var businessPicImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var starRatingImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var foodCategoryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        businessNameLabel.text = singleBusiness!.name!
        businessPicImageView.setImageWith(singleBusiness!.imageURL!)
        foodCategoryLabel.text = singleBusiness!.categories
        addressLabel.text = singleBusiness!.address
        reviewCountLabel.text = "\(singleBusiness!.reviewCount!) Reviews"
        starRatingImageView.image = singleBusiness!.ratingImage
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        getReviews()
    }
    
   func getReviews() {
    let id = singleBusiness?.id!

    BusinessReview.getReviews(businessId: id!, completion: {(reviews: [BusinessReview]?, error: Error?) -> Void
        in
        
        self.reviews = reviews
        self.tableView.reloadData()
        
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reviews != nil {
            return reviews.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewerCell", for: indexPath) as! ReviewerCell
        cell.reviews = reviews[indexPath.row]
        return cell
    }
}
