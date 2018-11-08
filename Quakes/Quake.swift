//
//  Quake.swift
//  Quakes
//
//  Created by Ilgar Ilyasov on 11/8/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation
import CoreLocation

class Quake: NSObject, Decodable {

    struct Properties: Decodable {
        
        enum PropertiesCodingKeys: String, CodingKey {
            case magnitude = "mag"
            case place
            case time
        }
        
        let magnitude: Double?
        let place: String
        let time: Date
    }

    struct Geometry: Decodable {
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: GeometryCodingKeys.self)
            var coordinates = try container.nestedUnkeyedContainer(forKey: .coordinates)
            let longitude = try coordinates.decode(CLLocationDegrees.self)
            let latitude = try coordinates.decode(CLLocationDegrees.self)
            
            location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
        }
        
        enum GeometryCodingKeys: String, CodingKey {
            case coordinates
        }
        
        let location: CLLocationCoordinate2D
    }
    
    let geometry: Geometry
    let properties: Properties
    let id: String
}

struct QuakeResults: Decodable {
    let features: [Quake]
}
