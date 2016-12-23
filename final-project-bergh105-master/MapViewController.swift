//
//  MapViewController.swift
//  demoProject
//
//  Created by DBergh on 12/23/16.
//  Copyright © 2016 Chapman. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var latitude: Double?
    var longitude : Double?
    var rating : Double?
    var name : String?
    var address : String?
    var phone : String?
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!

    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var labelView: UIView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
        
        self.mapView.addAnnotation(annotation)
        
        self.labelView.alpha = 0.0
        
        self.nameLabel.text = self.name
        
        if let addr = self.address {
            self.addressLabel.text = addr
        }
        
        if let phone = self.phone {
            self.phoneLabel.text = phone
        }
        
        if let rating = self.rating {
            self.ratingLabel.text = "\(rating)/5"
        }
        
        self.showLabels()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(latitude!, longitude!), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showLabels() {
        UIView.animate(withDuration: 1.0, animations: {
            self.labelView.alpha = 1
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
