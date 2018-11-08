//
//  ViewController.swift
//  Quakes
//
//  Created by Ilgar Ilyasov on 11/8/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "QaukeAnnotationView")
        
        userTrackingButton = MKUserTrackingButton(mapView: mapView)
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.addSubview(userTrackingButton)
        
        userTrackingButton.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 20).isActive = true
        userTrackingButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -20).isActive = true
        
        fetchQuakes()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        fetchQuakes()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let quake = annotation as? Quake else { return nil }
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "QaukeAnnotationView", for: quake) as! MKMarkerAnnotationView
        
        annotationView.glyphTintColor = .white
        annotationView.glyphImage = UIImage(named: "QuakeIcon")
        annotationView.canShowCallout = true
        
        let detailView = QuakeDetailView(frame: .zero)
        detailView.quake = quake
        
        annotationView.detailCalloutAccessoryView = detailView
        
        return annotationView
    }

    private func fetchQuakes() {
        
        let visibleRegion = CoordinateRegion(mapRect: mapView.visibleMapRect)
        
        quakeFetcher.fetchQuakes(in: visibleRegion) { (quakes, error) in
            if let error = error {
                NSLog("Error fetching quakes: \(error.localizedDescription)")
                return
            }
            
            self.quakes = quakes ?? []
        }
    }
    
    
    private let quakeFetcher = QuakeFetcher()
    private var quakes = [Quake]() {
        didSet {
            let oldQuakes = Set(oldValue)
            let newQuakes = Set(quakes)
            
            let addedQuakes = Array(newQuakes.subtracting(oldQuakes))
            let removedQuakes = Array(oldQuakes.subtracting(newQuakes))
            
            DispatchQueue.main.async {
                
                self.mapView.removeAnnotations(removedQuakes)
                self.mapView.addAnnotations(addedQuakes)
            }
        }
    }
    
    let locationManager = CLLocationManager()
    private var userTrackingButton: MKUserTrackingButton!
    
    @IBOutlet weak var mapView: MKMapView!
}

