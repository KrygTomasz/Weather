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
            backgroundView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 1, alpha: 1)
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            let cvCellNib = UINib(nibName: "WeatherDataCVCell", bundle: nil)
            collectionView.register(cvCellNib, forCellWithReuseIdentifier: "WeatherDataCVCell")
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    let CELLS_FOR_ROW: CGFloat = 1
    let CELLS_FOR_COLUMN: CGFloat = 1
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherDataCVCell", for: indexPath) as? WeatherDataCVCell else {
            return UICollectionViewCell()
        }
        cell.setView()
        return cell
    }
    
}

extension ViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width/CELLS_FOR_ROW
        let cellHeight = collectionView.bounds.height/CELLS_FOR_COLUMN
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let alpha = (200 - tableView.contentOffset.y) / 200
//        print(alpha)
//        currentTemperature.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: alpha)
//    }


