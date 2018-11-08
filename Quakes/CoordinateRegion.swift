//
//  CoordinateRegion.swift
//  Quakes
//
//  Created by Ilgar Ilyasov on 11/8/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation
import MapKit

struct CoordinateRegion {
    
    init(mapRect: MKMapRect) {
        let region = MKCoordinateRegion(mapRect)
        
        let origin = (longitude: region.center.longitude - region.span.longitudeDelta / 2.0,
                      latitude: region.center.latitude - region.span.latitudeDelta / 2.0)
        let size = (width: region.span.longitudeDelta, height: region.span.latitudeDelta / 2.0)
        
        let originLongitude = min(max(origin.longitude, -180), 180)
        let originLatitude = min(max(origin.latitude, -90), 90)
        
        self.origin = (longitude: originLongitude, latitude: originLatitude)
        
        let farPointLongitude = self.origin.longitude + size.width
        let farPointLatitude = self.origin.latitude + size.height
        
        self.farPoint = (longitude: min(max(farPointLongitude, -180), 180), latitude: min(max(farPointLatitude, -90), 90))
    }
    
    
    var origin: (longitude: Double, latitude: Double)
    var farPoint: (longitude: Double, latitude: Double)
    
    var size: (width: Double, height: Double) {
        let width = farPoint.longitude - origin.longitude
        let height = farPoint.latitude - origin.latitude
        
        return ( width: width, height: height)
    }
}
