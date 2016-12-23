//
//  DecisionsViewController.swift
//  demoProject
//
//  Created by DBergh on 12/21/16.
//  Copyright © 2016 Chapman. All rights reserved.
//

import UIKit
import CoreLocation

class DecisionsViewController: UIViewController {
    let api_key = "AIzaSyBMWz5FDBhfiQTacOOUxa1y93q3mMeobq4"
    var currLocation : CLLocation?
    //@IBOutlet weak var decisionsLabel: UILabel!
    @IBOutlet weak var startAgainButton: UIButton!
    
    @IBOutlet weak var showMapButton: UIButton!
    
    var preferences : [String] = []
    
    @IBOutlet weak var searchingLabel: UILabel!
    
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantAddress: UILabel!
    @IBOutlet weak var restaurantPhone: UILabel!
    @IBOutlet weak var restaurantRating: UILabel!
    
    var restLocLat : Double?
    var restLocLong : Double?
    var restRate : Double?
    var restName : String?
    var restAddr : String?
    var restPhone : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.restaurantName.isHidden = true
        self.restaurantAddress.isHidden = true
        self.restaurantPhone.isHidden = true
        self.restaurantRating.isHidden = true
        self.startAgainButton.isHidden = true
        self.showMapButton.isHidden = true
        // Do any additional setup after loading the view.
        
        self.restaurantAddress.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        
        DispatchQueue.main.async {
            self.callForRestaurants()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callForRestaurants() {
        let keywords = self.preferences.joined(separator: ",")
        let latitude = self.currLocation!.coordinate.latitude
        let longitude = self.currLocation!.coordinate.longitude
        
        let fullurl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=100&type=restaurant&keyword=\(keywords)&key=\(self.api_key)"
        
        let url = URL(string: fullurl)!
        var restaurants : [String: String] = [:]
        
        let searchTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            let resultsDict = json as! [String: AnyObject]
            
            if let array = resultsDict["results"] as? [AnyObject] {
                for object in array {
                    let name = "\(object["name"]!!)"
                    let place_id = "\(object["place_id"]!!)"
                    restaurants[name] = place_id
                }
            }
            self.getRestaurantDetails(restaurants)
        }
        
        searchTask.resume()
        
    }
    
    func getRestaurantDetails(_ restaurants : [String: String]) {
        
        if restaurants.isEmpty {
            self.onEmptySearch()
            return
        }
        let rs = [String](restaurants.keys)
        let restaurant = rs[0]
        let id = restaurants[restaurant]
        
        self.callAPI(restaurant: restaurant, restaurant_id: id!)
    }
    
    func callAPI(restaurant: String, restaurant_id: String) {
        
        let api = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(restaurant_id)&key=\(self.api_key)"
        let url = URL(string: api)!
        let detailsTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            let jsonDict = json as! [String: AnyObject]
            
            if let resultDict = jsonDict["result"] as? [String: AnyObject] {
                if let address = resultDict["formatted_address"] as? String {
                    self.restaurantAddress.text = address
                    self.restAddr = address
                }
                if let phone = resultDict["formatted_phone_number"] as? String {
                    self.restaurantPhone.text = phone
                    self.restPhone = phone
                }
                if let rating = resultDict["rating"] as? Double {
                    self.restaurantRating.text = "\(rating)/5 stars"
                    self.restRate = rating
                }
                
                if let geo = resultDict["geometry"] as? [String:AnyObject] {
                    
                    if let loc = geo["location"] as? [String:AnyObject] {
                        if let lat = loc["lat"] as? Double {
                            self.restLocLat = lat
                        }
                        if let long = loc["lng"] as? Double {
                            self.restLocLong = long
                        }
                    }
                }
                
                self.searchingLabel.isHidden = true
                
                self.restaurantName.text = restaurant
                self.restName = restaurant
                self.restaurantName.isHidden = false
                self.restaurantAddress.isHidden = false
                self.restaurantPhone.isHidden = false
                self.restaurantRating.isHidden = false
                
                self.startAgainButton.isHidden = false
                self.showMapButton.isHidden = false
            }
        }
        detailsTask.resume()
    }
    
    func onEmptySearch() {
        self.restaurantName.text = "No restaurants available :("
        self.restaurantAddress.text = "Your preferences may have been too varied."
        self.searchingLabel.isHidden = true
        if(self.searchingLabel.isHidden) {
            self.restaurantName.isHidden = false
            self.restaurantAddress.isHidden = false
            self.startAgainButton.isHidden = false
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let mapVC = segue.destination as? MapViewController {
            mapVC.latitude = self.restLocLat
            mapVC.longitude = self.restLocLong
            mapVC.rating = self.restRate
            mapVC.name = self.restName
            mapVC.address = self.restAddr
            mapVC.phone = self.restPhone
        }
    }
    
}
