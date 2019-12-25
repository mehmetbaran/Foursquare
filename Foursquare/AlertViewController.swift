//
//  AlertViewController.swift
//  Foursquare
//
//  Created by Mehmet Baran on 23.11.2019.
//  Copyright © 2019 Mehmet Baran. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SDWebImage
import Alamofire
import MBProgressHUD 

class AlertViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate,UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var tipsTableView: UITableView!
    @IBOutlet var alertView: UIView!
    
    var choosePlace: venuesModel? = nil
    var tipsList: [String] = []
    var manager = CLLocationManager()
    var requestCLLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        tipsTableView.dataSource = self
        tipsTableView.delegate = self
        map.delegate = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        getPhotosOfVenues()   // API den çekilen photo  fonk. çağırıyoruz.
        getListOfTips()   //API den çekilen yorumlar  fonk. çağırıyoruz.
        
        // Detay ekranında yer adını yazdırıyoruz.
        nameLabel.text = choosePlace?.name
     
    
    }
    
    // Detay ekranında yorumları listelemek için yapılan iki fonksiyon
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tipsList.count
    }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = self.tipsTableView.dequeueReusableCell(withIdentifier: "TipsCell", for: indexPath) as! TipsTableViewCell;
        
            cell.tipsLabel.text = tipsList[indexPath.row]
        return cell;
    }
    
    // API den foto çeken fonksiyon
    func getPhotosOfVenues() {
        MBProgressHUD.showAdded(to: self.view, animated: true);
        var url : String = "https://api.foursquare.com/v2/venues/"+choosePlace!.id+"/photos?client_id=\(clientID)&client_secret=\(clientSecret)&v=20190521"
        AF.request(url).responseJSON { response in
            if let json = response.value {
                let jsonDict = json as! NSDictionary;
                let responseModel = jsonDict["response"] as! NSDictionary;
                let photoModel = responseModel["photos"] as! NSDictionary;
                let photoItemsArray = photoModel["items"] as! NSArray;
                var photo = ""
                let object = photoItemsArray[0]
                let model = object as! NSDictionary;
                photo = (model["prefix"] as! String) + "414x268"+(model["suffix"] as! String)
                self.image.sd_setImage(with: URL(string:photo))
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    //API den yorumları çeken fonksiyon
    func getListOfTips() {
        MBProgressHUD.showAdded(to: self.view, animated: true);
        var url : String = "https://api.foursquare.com/v2/venues/"+choosePlace!.id+"/tips?client_id=\(clientID)&client_secret=\(clientSecret)&v=20190521"
        print(url)
        AF.request(url).responseJSON { response in
            if let json = response.value {
                let jsonDict = json as! NSDictionary;
                let responseModel = jsonDict["response"] as! NSDictionary;
                let tipsModel = responseModel["tips"] as! NSDictionary;
                let tipsItemsArray = tipsModel["items"] as! NSArray;
                let count :Int = tipsModel["count"] as! Int;
                for object in tipsItemsArray {
                    let model = object as! NSDictionary;
                    var tipsText = (model["text"] as! String)
                    self.tipsList.append(tipsText);
                }
                DispatchQueue.main.async {
                    self.tipsTableView.reloadData()
                }
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    
    // Yerin lat ve lng değerlerine göre haritada yerini bulup pinleyerek gösteren işlemler
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: choosePlace!.lat, longitude: choosePlace!.lng)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        map.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        self.map.addAnnotation(annotation)
        annotation.title = nameLabel.text
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation{
            return nil
        }
        
        let reuseID = "pin"
        var pinView = map.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        
        if pinView == nil{
            
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView?.canShowCallout = true
            pinView?.pinTintColor = UIColor.red
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        } else {
            
            pinView?.annotation = annotation
        }
        return pinView
        
    }
   
    // Gösterilen yerde pin üzerine basılarak navigasyona bağlanma işlemleri
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if choosePlace!.lat != Double(0) {
            if choosePlace!.lng != 0  {
                self.requestCLLocation = CLLocation(latitude: choosePlace!.lat, longitude: choosePlace!.lng)
                
            }
            
        }
        
        CLGeocoder().reverseGeocodeLocation(requestCLLocation) { (placemarks, error) in
            if let placesmark = placemarks {
                
                if placesmark.count > 0 {
                    
                    let newPlacesmark = MKPlacemark(placemark: placesmark[0])
                    let item = MKMapItem(placemark: newPlacesmark)
                    
                    item.name = self.nameLabel.text
                    let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                    
                    item.openInMaps(launchOptions: launchOptions)
                }
            }
        }

  }
}
