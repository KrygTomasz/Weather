//
//  ViewTool.swift
//  Weather
//
//  Created by Kryg Tomasz on 21.03.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import UIKit

class ViewTool {
    
    static func addShadow(to view: UIView) {
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        view.layer.shadowRadius = 10
        view.layer.shouldRasterize = false
        view.layer.shadowOpacity = 0.8
        view.layer.masksToBounds = false
        
    }
    
    static func removeShadow(from view: UIView) {
        
        view.layer.shadowColor = UIColor.clear.cgColor
        
    }
    
    static func addGradientBackground(to view: UIView, using colors: [CGColor]) {
        let backgroundLayer = Colors.gradient(using: colors)
        view.backgroundColor = UIColor.clear
        backgroundLayer.frame = view.frame
        view.layer.insertSublayer(backgroundLayer, at: 0)
    }
    
}
