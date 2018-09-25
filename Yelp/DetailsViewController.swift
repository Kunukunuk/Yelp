//
//  DetailsViewController.swift
//  Yelp
//
//  Created by Kun Huang on 9/24/18.
//  Copyright © 2018 Timothy Lee. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var name = ""
    var singleBusiness: Business?
    
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
        reviewCountLabel.text = "\(singleBusiness!.reviewCount) Reviews"
        starRatingImageView.image = singleBusiness!.ratingImage
        
        //tableView.dataSource = self
    }
    

}
