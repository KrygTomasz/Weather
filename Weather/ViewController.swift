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
    
    @IBOutlet weak var pageControl: UIPageControl! {
        didSet {
            pageControl.hidesForSinglePage = true
            pageControl.numberOfPages = 0
            pageControl.addTarget(self, action: #selector(onPageChanged), for: .valueChanged)
        }
    }
    @IBOutlet weak var addButton: UIButton! {
        didSet {
            addButton.setTitle("", for: .normal)
            addButton.setImage(#imageLiteral(resourceName: "plusIcon"), for: .normal)
            addButton.tintColor = UIColor.white
            addButton.addTarget(self, action: #selector(onAddButtonClick), for: .touchUpInside)
        }
    }
    
    let CELLS_FOR_ROW: CGFloat = 1
    let CELLS_FOR_COLUMN: CGFloat = 1
    
    var cities: [String] = ["Katowice", "California"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        pageControl.numberOfPages = cities.count
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
//        collectionView.reloadData()
//    }
    
    func onPageChanged() {
        let indexPath = IndexPath(item: pageControl.currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func onAddButtonClick() {
        showDialog()
    }
    
    private func addNewWeather(for city: String) {
        cities.append(city)
        pageControl.numberOfPages = cities.count
        collectionView.reloadData()
    }
    
    private func showDialog() {
        
        let alert = UIAlertController(title: "Dodaj miejsce", message: "Podaj miejsce, dla którego chcesz sprawdzić pogodę", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        
        
        let cancelAction = UIAlertAction(title: "Odrzuć", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        })
        
        let saveAction = UIAlertAction(title: "Dodaj", style: .default, handler: {(action: UIAlertAction) -> Void in
            if let city: String = alert.textFields?.first?.text {
                self.addNewWeather(for: city)
            }
        })
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }

}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherDataCVCell", for: indexPath) as? WeatherDataCVCell else {
            return UICollectionViewCell()
        }
        let city = cities[indexPath.item]
        cell.setView(for: city)
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) { // set pageControl to current visible page
        let pageWidth = self.collectionView.frame.size.width
        pageControl.currentPage = Int(self.collectionView.contentOffset.x / pageWidth)
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
