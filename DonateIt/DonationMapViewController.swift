//
//  DonationMapViewController.swift
//  DonateIt
//
//  Created by Evelyn Hasama on 12/5/20.
//

import UIKit
import MapKit
import Parse

class DonationMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var centers = [PFObject]()
    
    private let locationManager = CLLocationManager()
    private var currentCoordinate = CLLocationCoordinate2D()
    var selectedTitle : String!
    var selectedPFObject: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        configureLocationServices()
        // Do any additional setup after loading the view.
    }
    
    private func configureLocationServices(){
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            mapView.showsUserLocation = true
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    private func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D){
        let zoomRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(zoomRegion, animated: true)
        
    }

    private func beginLocationUpdates(locationManager: CLLocationManager){
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    private func addAnotations() {
        let appleParkAnnotation = MKPointAnnotation()
        appleParkAnnotation.title = "Goodwill Donation Center San Pedro"
        appleParkAnnotation.coordinate = CLLocationCoordinate2D(latitude: 33.75610982095931, longitude: -118.31113053442913)
        
        let ortegaParkAnnotation = MKPointAnnotation()
        ortegaParkAnnotation.title = "Palos Verdes Resale"
        ortegaParkAnnotation.coordinate = CLLocationCoordinate2D(latitude: 33.789901347376976, longitude: -118.32340051387878)
       
        mapView.addAnnotation(appleParkAnnotation)
        mapView.addAnnotation(ortegaParkAnnotation)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        print("start Query")
        let query = PFQuery(className:"DonationCenters")
        query.limit = 100
        query.whereKey("Name", equalTo: selectedTitle! as String)
        print("afterwherekey")
        
        query.findObjectsInBackground{ (centers, error) in
            print("hello")
            if let error = error {
                print(error)
                return
            }
            if centers != nil {
                print("error nil")
                self.centers = centers!
            }
        print(centers)
        print("query complete")

            self.selectedPFObject = centers![0]
            print(self.selectedPFObject)
            }
        let centerDetailsViewController = segue.destination as! CenterDetailsViewController
        centerDetailsViewController.dcobj = self.selectedPFObject as PFObject
        
        
    }
    

}

extension DonationMapViewController: CLLocationManagerDelegate{
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        
        guard let latestLocation = locations.first else{
            return
        }
        
        if currentCoordinate != nil{
            zoomToLatestLocation(with: latestLocation.coordinate)
            addAnotations()
        }
        currentCoordinate = latestLocation.coordinate
        
        
    }


    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("The status changed")
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            beginLocationUpdates(locationManager: manager)
    }
 }
}
extension DonationMapViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if mapView.userLocation == annotation as! NSObject{
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Annotation View")
        }
       
        if annotation.title != "My Location"{
        annotationView?.image = UIImage(named: "pindrop")
        }
        
        annotationView?.canShowCallout = true
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("the annotation was selected: \(String(describing: view.annotation?.title))")
        selectedTitle = String((view.annotation?.title)!!)
        
        
        let coordinates = (view.annotation?.coordinate)!
        let mkplacemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: mkplacemark)
        mapItem.name = selectedTitle
        mapItem.openInMaps()
        
        
        //performSegue(withIdentifier: "centerInfo", sender: Any?(nilLiteral: ()))
        
    }
    
}
