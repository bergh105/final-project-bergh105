//
//  HomepageViewController.swift
//  demoProject
//
//  Created by DBergh on 12/22/16.
//  Copyright © 2016 Chapman. All rights reserved.
//

import UIKit

class HomepageViewController: UIViewController {

    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var descrLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.descrLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
