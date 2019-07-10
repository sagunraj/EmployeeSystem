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

protocol MapOperationProtocol: class {
    
    func updateEmployeeAddress(coordinates: CLLocationCoordinate2D)
    
}

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var activityIndicator: UIActivityIndicatorView!
    
    var locationManager: CLLocationManager?
    var draggedLocation: CLLocationCoordinate2D?
    
    var employeeArr: [Employee] = []
    var selectedEmployeeName: String?
    
    weak var delegate: MapOperationProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "Employee Address"
        configureMapView(with: CLLocationCoordinate2D(latitude: 27.7107, longitude: 85.3290))
        mapView.delegate = self
        showActivityIndicator()
        showCurrentUserLocation()
        displayUpdateButton()
    }
    
    @objc private func updateEmployeeLocation(){
        delegate?.updateEmployeeAddress(coordinates: draggedLocation ?? CLLocationCoordinate2D(latitude: 27.7107, longitude: 85.3290))
    }
    
    private func displayUpdateButton(){
        if employeeArr.count == 1 {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(updateEmployeeLocation))
            centerEmployeeLocation()
        }
    }
    
    private func centerEmployeeLocation(){
        if let latitude = employeeArr[0].address?.latitude, let longitude = employeeArr[0].address?.longitude {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView.setCenter(coordinate, animated: true)
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
    
    private func configureMapView(with center: CLLocationCoordinate2D){
        let regionRadius: CLLocationDistance = 10000
        let coordinateRegion = MKCoordinateRegion(center: center, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
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
    
    private func refreshMap() {
        configureMapView(with: mapView.region.center)
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
            view.animatesWhenAdded = true
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            if mapView.annotations.count == 1 {
                view.isDraggable = true
            }
            view.animatesWhenAdded = true
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        draggedLocation = CLLocationCoordinate2D(latitude: (view.annotation?.coordinate.latitude)!, longitude: (view.annotation?.coordinate.longitude)!)
        selectedEmployeeName = (view.annotation?.title)!
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
        showAlert(alertTitle: "Failed to load map", alertMessage: "Please check your connectivity and retry.", alertActionTitle: "Retry", handler: { _ in self.refreshMap()})
    }
    
}
