//
//  ViewController.swift
//  Quakes
//
//  Created by Ilgar Ilyasov on 11/8/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
    private var quakes = [Quake]()
    
    @IBOutlet weak var mapView: MKMapView!
}

