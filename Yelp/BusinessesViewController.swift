//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UISearchBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var businesses: [Business]!
    @IBOutlet weak var tableView: UITableView!
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    var searchRestaurant = "Restaurant"
    @IBOutlet weak var centerPopUp: NSLayoutConstraint!
    let pickerData = ["Best Match", "Rating", "Review Count", "Distance"]
    @IBOutlet weak var picker: UIPickerView!
    var pickedRow = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        picker.delegate = self
        picker.dataSource = self

        createSearchBar()
        searchRestaurants()
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickedRow = row
    }
    @IBAction func sortBy(_ sender: UIBarButtonItem) {
        pickedRow = 0
        centerPopUp.constant = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveEaseOut, animations: { self.view.layoutIfNeeded()}, completion: nil)
        
    }
    
    
    @IBAction func closePopUp(_ sender: UIButton) {
        centerPopUp.constant = -500
        
        UIView.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()})
        sortRestaurants()
    }
    
    func searchRestaurants() {
        
        Business.searchWithTerm(term: searchRestaurant, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            if self.isMoreDataLoading {
                self.businesses = self.businesses + businesses!
            } else {
                self.businesses = businesses
            }
            //self.searchedData = self.businesses
            
            self.isMoreDataLoading = false
            self.loadingMoreView!.stopAnimating()
            
            self.tableView.reloadData()
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
            
        }
        )
        
        /*Example of Yelp search with more search options specified
         Business.searchWithTerm(term: "Restaurants", sort: .distance, categories: ["asianfusion", "burgers"]) { (businesses, error) in
         self.businesses = businesses
         for business in self.businesses {
         print(business.name!)
         print(business.address!)
         }
         }*/
 
        
    }
    
    func sortRestaurants() {
        
        let sortBy: String?
        
        switch pickedRow {
            case 1:
                sortBy = ".rating"
            case 2:
                sortBy = ".review_count"
            case 3:
                sortBy = ".distance"
            case 0:
                sortBy = ".best_match"
            default:
                sortBy = ".best_match"
        }
        
        Business.searchWithTerm(term: searchRestaurant, sort: YelpSortMode(rawValue: sortBy!)) { (businesses, error) in
            self.businesses = businesses
            self.tableView.setContentOffset(.zero, animated: true)
            self.tableView.reloadData()
            for business in self.businesses {
                print(business.name!)
                print(business.address!)
            }
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            searchRestaurant = "Restaurant"
            YelpClient.sharedInstance.resetOffset()
            searchRestaurants()
            tableView.setContentOffset(.zero, animated: true)
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                
                isMoreDataLoading = true
                
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Code to load more results
                searchRestaurants()
                //loadMoreData()
            }
        }
    }
    
    func createSearchBar() {
        
        let searchBar = UISearchBar()
        searchBar.placeholder = "Restaurants"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil {
            searchRestaurant = searchBar.text!
            searchRestaurants()
            tableView.setContentOffset(.zero, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "MapViewResults") {
            let vc = segue.destination as! MapViewController
            vc.data = businesses
        } else if (segue.identifier == "DetailsSegue") {
            let vc = segue.destination as! DetailsViewController
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)!
            
            vc.singleBusiness = businesses[indexPath.row]
            vc.getReviews()
        }
    }
    
}
