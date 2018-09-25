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
        
        //getReviews()
        //tableView.dataSource = self
    }
    
   /* func getReviews() {
        let id = singleBusiness?.id!
        let url = URL(string: "https://api.yelp.com/v3/businesses/\(id!)/reviews")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                //self.alert()
                print(error.localizedDescription)
            } else if let data = data {
               
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                print(dataDictionary, " *****")
                let movies = dataDictionary["reviews"] as? [[String: Any]]
                print(movies)
                
                
            }
        }
        task.resume()
    }*/
}
