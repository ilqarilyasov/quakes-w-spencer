//
//  ViewController.swift
//  Quakes
//
//  Created by Ilgar Ilyasov on 11/8/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "QaukeAnnotationView")
        
        fetchQuakes()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let quake = annotation as? Quake else { return nil }
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "QaukeAnnotationView", for: quake) as! MKMarkerAnnotationView
        
        annotationView.glyphTintColor = .white
        annotationView.glyphImage = UIImage(named: "QuakeIcon")
        
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
            DispatchQueue.main.async {
                self.mapView.addAnnotations(self.quakes)
            }
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
}

