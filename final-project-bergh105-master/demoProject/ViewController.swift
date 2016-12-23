//
//  ViewController.swift
//  demoProject
//
//  Created by DBergh on 12/21/16.
//  Copyright © 2016 Chapman. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var decisionButton: UIButton!
    
    let options = ["Breakfast", "Lunch", "Dinner",
                   "Italian", "Chinese", "Mexican",
                   "Japanese", "Thai", "Greek",
                   "Sushi", "Hamburgers", "Salad",
                   "Vegetarian", "Takeout"]
    var selections : [String] = []
    var curr_option = 0
    
    var currLocation : CLLocation?
    var locationManager : CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.decisionButton.isHidden = true
        
        self.optionLabel.text = options[curr_option]
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.didSwipeRight(_:)))
        rightSwipe.direction = UISwipeGestureRecognizerDirection.right
        view.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.didSwipeLeft(_:)))
        leftSwipe.direction = UISwipeGestureRecognizerDirection.left
        view.addGestureRecognizer(leftSwipe)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onClickDecisionButton(_ sender: Any) {
        //searchNearby()
    }
    
    func didSwipeRight(_ sender: UISwipeGestureRecognizer) {
        self.decisionButton.isHidden = false
        if(curr_option <= (options.count - 1)) {
            self.selections.append(options[curr_option])
        }
        changeText()
    }
    
    func didSwipeLeft(_ sender: UISwipeGestureRecognizer) {
        changeText()
    }
    
    func changeText() {
        if(curr_option == (options.count - 1)) {
            self.optionLabel.isHidden = true
            self.decisionButton.isHidden = false
        }
        else {
            curr_option += 1
            self.optionLabel.text = options[curr_option]
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let decisionVC = segue.destination as? DecisionsViewController {
            decisionVC.currLocation = self.currLocation!
            decisionVC.preferences = self.selections
        }
    }

}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location updates failed. Error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first!
        self.currLocation = location
    }
}


