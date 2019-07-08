//
//  MapViewController.swift
//  IW Employee System
//
//  Created by Sagun Raj Lage on 7/8/19.
//  Copyright © 2019 Sagun Raj Lage. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotation: MKPointAnnotation {
    
    var id: Int?

}

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    var activityIndicator: UIActivityIndicatorView!
    var locationManager: CLLocationManager?
    var employeeArr: [Employee] = []
    @IBOutlet weak var updateBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureMapView()
        mapView.delegate = self
        showActivityIndicator()
        showCurrentUserLocation()
        displayUpdateButton()
    }
    
    private func displayUpdateButton(){
        if employeeArr.count <= 1 {
            updateBtn.isHidden = false
        }
        else {
            updateBtn.isHidden = true
        }
    }
    
    private func showCurrentUserLocation(){
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.distanceFilter = kCLDistanceFilterNone
        locationManager?.startUpdatingLocation()
        
        mapView.showsUserLocation = true
    }
    
    private func showActivityIndicator(){
        activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.center = mapView.center
        mapView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func configureMapView(){
        let initialLocation = CLLocationCoordinate2D(latitude: 27.7107, longitude: 85.3500)
        let regionRadius: CLLocationDistance = 10000
        let coordinateRegion = MKCoordinateRegion(center: initialLocation, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        passEmployeeArrayToMapView()
    }
    
    private func passEmployeeArrayToMapView(){
        for (index,employee) in employeeArr.enumerated() {
            guard let title = employee.address?.formattedAddress, let latitude = employee.address?.latitude, let longitude = employee.address?.longitude else { return }
            loadDataOnMapView(id: index, name: employee.name, title: title, latitude: latitude, longitude: longitude)
        }
    }
    
    private func loadDataOnMapView(id: Int, name: String, title: String, latitude: Double, longitude: Double){
        let annotation = CustomAnnotation()
        annotation.id = id
        annotation.title = name
        annotation.subtitle = title
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView.addAnnotation(annotation)
    }
    
    static func getInstance(with employees: [Employee]) -> MapViewController? {
        let vc = UIStoryboard(name: "HomeStoryboard", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as? MapViewController
        vc?.employeeArr = employees
        return vc
    }
   
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let coordinate = view.annotation?.coordinate {
            mapView.setCenter(coordinate, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? CustomAnnotation,
        let id = annotation.id else { return }
        let employee = employeeArr[id]
        
        let detailsVC = DetailsViewController.getInstance(with: employee, at: id)
        navigationController?.pushViewController(detailsVC!, animated: true)
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        activityIndicator.stopAnimating()
    }
    
    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        showAlert(alertTitle: "Failed to load map", withMessage: "Please check your connectivity and retry.", okTitle: "Retry", okHandler: {self.viewDidLoad()}, cancelTitle: "Cancel")
    }
    
}
