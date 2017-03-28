//
//  ViewController.swift
//  Weather
//
//  Created by Kryg Tomasz on 16.03.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet var backgroundView: UIView! {
        didSet {
            backgroundView.backgroundColor = Colors.MAIN_COLOR
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            let cvCellNib = UINib(nibName: "WeatherDataCVCell", bundle: nil)
            collectionView.register(cvCellNib, forCellWithReuseIdentifier: "WeatherDataCVCell")
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.allowsSelection = false
        }
    }
    
    @IBOutlet weak var separatorView: UIView! {
        didSet {
            separatorView.backgroundColor = Colors.DARK_LABEL_COLOR
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
    
    @IBOutlet weak var bottomView: UIView! {
        didSet {
            bottomView.backgroundColor = Colors.MAIN_COLOR
            //bottomView.backgroundColor = bottomView.backgroundColor?.withAlphaComponent(0.8)
            let shadowOffset = CGSize(width: 0, height: -10)
            ViewTool.addShadow(to: bottomView, offset: shadowOffset)
        }
    }
    
    var locationManager: CLLocationManager?
    
    let CELLS_FOR_ROW: CGFloat = 1
    let CELLS_FOR_COLUMN: CGFloat = 1
    
    var locations: [Location] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initLocationService()
        setViewColors()
        locations.append(Location(name: "Miami"))
        pageControl.numberOfPages = locations.count
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func initLocationService() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    func setViewColors() {
        //let topColor = UIColor.init(red: 0, green: 0.2, blue: 0.5, alpha: 1).cgColor
        //let bottomColor = UIColor.init(red: 0, green: 0, blue: 0.3, alpha: 1).cgColor
        //ViewTool.addGradientBackground(to: backgroundView, using: [topColor, bottomColor])
        //ViewTool.addGradientBackground(to: bottomView, using: [bottomColor, topColor])
    }
    
    func onPageChanged() {
        let indexPath = IndexPath(item: pageControl.currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func onAddButtonClick() {
        showDialog()
    }
    
    private func addNewWeather(for city: String) {
        let location = Location(name: city)
        locations.append(location)
        pageControl.numberOfPages = locations.count
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
        return locations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherDataCVCell", for: indexPath) as? WeatherDataCVCell else {
            return UICollectionViewCell()
        }
        let location = locations[indexPath.item]
        cell.setData(for: location)
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

extension ViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    let locationCoordinate = locationManager?.location?.coordinate
                    let lat = locationCoordinate?.latitude
                    let long = locationCoordinate?.longitude
                    print("Latitude: \(locationCoordinate?.latitude)")
                    print("Longitude: \(locationCoordinate?.longitude)")
                    let currentLocation = Location(latitude: lat, longitude: long, isLocalizedByDevice: true)
                    locations.insert(currentLocation, at: 0)
                    pageControl.numberOfPages = locations.count
                    collectionView.reloadData()
                }
            }
        } else if status == .denied || status == .notDetermined || status == .restricted {
            if locations[0].isLocalizedByDevice {
                locations.remove(at: 0)
                pageControl.numberOfPages = locations.count
                collectionView.reloadData()
            }
        }
    }
    
}

extension ViewController {
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
        DispatchQueue.main.async {
            let indexPath = IndexPath(item: self.pageControl.currentPage, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let alpha = (200 - tableView.contentOffset.y) / 200
//        print(alpha)
//        currentTemperature.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: alpha)
//    }
