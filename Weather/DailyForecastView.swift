//
//  DailyForecastView.swift
//  Weather
//
//  Created by Kryg Tomasz on 21.03.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import UIKit

class DailyForecastView: UIView {

    @IBOutlet weak var dayLabel: UILabel! {
        didSet {
            dayLabel.textColor = Colors.LABEL_COLOR
        }
    }
    
    @IBOutlet weak var dayTemperatureLabel: UILabel! {
        didSet {
            dayTemperatureLabel.textColor = Colors.LABEL_COLOR
        }
    }
    
    @IBOutlet weak var nightTemperatureLabel: UILabel! {
        didSet {
            nightTemperatureLabel.textColor = Colors.DARK_LABEL_COLOR
        }
    }
    
    var onHeaderClick: (()->())?
    var isExpanded: Bool = false
    
    class func instanceFromNib() -> DailyForecastView {
        return UINib(nibName: "DailyForecastView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DailyForecastView
    }
    
    func setView(day: String, dayTemperature: String, nightTemperature: String) {
        dayLabel.text = day
        dayTemperatureLabel.text = dayTemperature
        nightTemperatureLabel.text = nightTemperature
        addGesture()
    }
    
    private func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onHeaderTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    func onHeaderTap() {
        guard let click = onHeaderClick else { return }
        click()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
