//
//  Quake+Mapping.swift
//  Quakes
//
//  Created by Ilgar Ilyasov on 11/8/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation
import MapKit

extension Quake: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        return geometry.location
    }
    
    var title: String? {
        return properties.place
    }
}
