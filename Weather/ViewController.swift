//
//  ViewController.swift
//  Weather
//
//  Created by Kryg Tomasz on 16.03.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var weather = DataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weather.downloadData {
            print(self.weather.temp)
            
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

