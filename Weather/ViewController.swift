//
//  ViewController.swift
//  Weather
//
//  Created by Kryg Tomasz on 16.03.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var backgroundView: UIView! {
        didSet {
            backgroundView.backgroundColor = UIColor.init(red: 1, green: 1, blue: 0.5, alpha: 1)
        }
    }
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var weather = WSCurrentWeather()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        weather.downloadData(for: "Gliwice", completion:  {
            self.setView()
        })
        
    }
    
    private func setView() {
        currentTemperature.text = weather.temp
        cityLabel.text = weather.location
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let alpha = (200 - tableView.contentOffset.y) / 200
        print(alpha)
        currentTemperature.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: alpha)
    }
    
}
