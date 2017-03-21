//
//  Colors.swift
//  Weather
//
//  Created by Kryg Tomasz on 21.03.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import UIKit

class Colors {
    
    static let LABEL_COLOR = UIColor.white
    static let DARK_LABEL_COLOR = UIColor.gray
    
}

extension Colors {
    
    static func gradient(using colors: [CGColor]) -> CAGradientLayer {
        
        let gradient = CAGradientLayer()
        gradient.colors = colors
        for i in 0..<colors.count {
            let location: NSNumber = (NSNumber(value: (Float)(i)/(Float)(colors.count)))
            gradient.locations?.append(location)
        }
        return gradient
        
    }
    
}
