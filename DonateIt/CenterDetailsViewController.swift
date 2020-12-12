//
//  CenterDetailsViewController.swift
//  DonateIt
//
//  Created by Evelyn Hasama on 12/5/20.
//

import UIKit
import Parse
import MapKit

class CenterDetailsViewController: UIViewController {

    var location : MKMapItem!
    @IBOutlet weak var itemImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        itemImage.layer.cornerRadius = 20
        itemImage.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
 
  
    
    @IBAction func onDirections(_ sender: Any) {
        location.openInMaps()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
