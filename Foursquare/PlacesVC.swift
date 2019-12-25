//
//  placesVC.swift
//  Foursquare
//
//  Created by Mehmet Baran on 21.11.2019.
//  Copyright © 2019 Mehmet Baran. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import FoursquareAPIClient

class placesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var listtableview: UITableView!
    var mekanArray: [venuesModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
   
   //Detay ekranına bilgileri aktaran fonksiyon
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromPlacesVCtoAlertVC" {
            let vc = segue.destination as! AlertViewController
            vc.choosePlace=mekanArray[sender as! Int]
        }
    }
    
    // TableView de listesinde seçilen cell özelliklerini Alert (Detay ekranına) aktaran fonksiyon
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "fromPlacesVCtoAlertVC", sender: indexPath.row)
    }
 
    //TableView ekranında yerleri listelemek için yazılan 2 fonksiyon
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mekanArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.listtableview.dequeueReusableCell(withIdentifier: "VenuesCell", for: indexPath) as! VenuesTableViewCell;
             cell.venuesName.text = mekanArray[indexPath.row].name
             cell.venuesAddress.text = mekanArray[indexPath.row].adress
             cell.venuesCity.text = mekanArray[indexPath.row].city
             cell.venuesCountry.text = mekanArray[indexPath.row].country
        return cell;
       }
    }
   
   
    
    




