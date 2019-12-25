//
//  ViewController.swift
//  Foursquare
//
//  Created by Mehmet Baran on 21.11.2019.
//  Copyright © 2019 Mehmet Baran. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class mainPageVC: UIViewController {
    var mekanlar: [venuesModel] = []
    @IBOutlet weak var placeTypeText: UITextField!
    @IBOutlet weak var locationText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeTypeText.keyboardType = UIKeyboardType.alphabet
        
    }
    
    // Search Butonu ve tıklandığınde gerçekleştirilecekler.
    @IBAction func searchClicked(_ sender: Any) {
        
        // Giriş ekranında textField boş olma durumları ve ekrana verilen alert işlemleri
        if placeTypeText.text != "" && locationText.text != "" {
            if placeTypeText.text!.count >= 3 {
            getListOfVenues(); // Koşullar sağlandığında API den liste çeken fonk. çağırıyoruz
            } else {
                let alert = UIAlertController(title: "UYARI !", message: "Lütfen en az 3 Karekterli Yer Adı Giriniz.", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                
            }
        } else {
           let alert = UIAlertController(title: "UYARI !", message: "Lütfen Yer Adı Giriniz.", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
   }
    
    // Mekanlar listesini API den çeken fonksiyon
    func getListOfVenues() {
        MBProgressHUD.showAdded(to: self.view, animated: true);
        self.mekanlar.removeAll()
        
        var urlPrefix :String = "https://api.foursquare.com/v2/venues/search?near="+locationText.text!
        var urlSuffix :String = "&query="+placeTypeText.text!+"&client_id=\(clientID)&client_secret=\(clientSecret)&v=20190520"
        var url :String = urlPrefix + urlSuffix
        
        AF.request(url).responseJSON { response in
                 print(response)
            if let json = response.value {
            
                let jsonDict = json as! NSDictionary;
                let responseModel = jsonDict["response"] as! NSDictionary;
                let venuesArray = responseModel["venues"] as! NSArray;
          
                for object in venuesArray {
                    print("object")
                    let venue = object as! NSDictionary;
                    let location = venue["location"] as! NSDictionary;
                    let categoriArray = venue["categories"] as! NSArray;
                   
                    var id: String = ""
                    var name: String = ""
                    var adress: String = ""
                    var city: String = ""
                    var country: String = ""
                    var photo: String = ""
                    var latitute: Double = 0
                    var longitute: Double = 0
                   
                    if venue["id"] != nil {
                     id = (venue["id"] as! String)
                    }
                    if venue["name"] != nil {
                     name = (venue["name"] as! String)
                    }
                    if location["address"] != nil {
                     adress = (location["address"] as! String)
                    }
                    if location["city"] != nil {
                     city = (location["city"] as! String)
                    }
                    if location["country"] != nil {
                     country = (location["country"] as! String)
                    }
                    if location["lat"] != nil {
                     latitute = (location["lat"] as! Double)
                    }
                    if location["lng"] != nil {
                     longitute = (location["lng"] as! Double)
                    }
                    
                    for categori in categoriArray {
                        let model = categori as! NSDictionary;
                        let icon = model["icon"] as! NSDictionary;
                        photo = (icon["prefix"] as! String) + (icon["suffix"] as! String)
                    }

                    let mekan = venuesModel(id: id, name: name, adress: adress, city: city, country: country, photo: photo, lat: latitute, lng: longitute)
                    
                    self.mekanlar.append(mekan);
                   
                }
                // Places ekranına veri aktarmak
                DispatchQueue.main.async(){
                    self.performSegue(withIdentifier: "mainPageVCToPlacesVC", sender: nil)
                
                }
                MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
 }
    // Places ekranına veri aktarmak
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainPageVCToPlacesVC" {
            let vc = segue.destination as! placesVC
            vc.mekanArray = mekanlar
        }
    }
}


