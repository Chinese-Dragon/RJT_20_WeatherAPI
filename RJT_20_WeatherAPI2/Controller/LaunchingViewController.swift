//
//  LaunchingViewController.swift
//  RJT_20_WeatherAPI2
//
//  Created by Mark on 1/1/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import UIKit
import SVProgressHUD

class LaunchingViewController: UIViewController {

    var locationManager = LocationDataManager.shareInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        
        locationManager.parse {
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                print(self.locationManager.locationData.count)
                // Once parsing finish then go to weatherSearch Controller now we can use our data
                print("Need to present our initial vc")
                let targetVC = self.storyboard?.instantiateViewController(withIdentifier: "WeatherNavigationController") as! UINavigationController
                
                self.present(targetVC, animated: true, completion: nil)
            }
        }
    }
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
//
}
