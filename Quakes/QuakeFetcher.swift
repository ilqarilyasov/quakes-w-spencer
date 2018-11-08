//
//  QuakeFetcher.swift
//  Quakes
//
//  Created by Ilgar Ilyasov on 11/8/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation

extension CoordinateRegion {
    fileprivate var queryItems: [URLQueryItem] {
        return [URLQueryItem(name: "minlongitude", value: String(origin.longitude)),
                URLQueryItem(name: "minlatitude", value: String(origin.latitude)),
                URLQueryItem(name: "maxlongitude", value: String(origin.longitude + size.width)),
                URLQueryItem(name: "maxlatitude", value: String(origin.latitude + size.height))
        ]
    }
}

class QuakeFetcher {
    
    enum FetcherError: Int, Error {
        case unknownError
        case dateMathError
        case invalidURL
    }
    
    func fetchQuakes(in region: CoordinateRegion? = nil, completion: @escaping ([Quake]?, Error?) -> Void) {
        
        let calendar = Calendar.current
        let now = calendar.startOfDay(for: Date())
        
        var components = DateComponents()
        components.calendar = calendar
        components.day = -7
        
        guard let aWeekAgo = calendar.date(byAdding: components, to: now) else {
            completion(nil, FetcherError.dateMathError)
            return
        }
        
        let interval = DateInterval(start: aWeekAgo, end: now)
        
        fetchQuakes(in: region, inDateInterval: interval, completion: completion)
    }
    
    func fetchQuakes(in region: CoordinateRegion? = nil, inDateInterval: DateInterval, completion: @escaping ([Quake]?, Error?) -> Void) {
        var urlComponents = URLComponents(url: QuakeFetcher.baseURL, resolvingAgainstBaseURL: true)!
        let startDate = dateFormatter.string(from: inDateInterval.start)
        let endDate = dateFormatter.string(from: inDateInterval.end)
        var queryItems = [URLQueryItem(name: "format", value: "geojson"),
                          URLQueryItem(name: "starttime", value: startDate),
                          URLQueryItem(name: "endtime", value: endDate)]
        if let region = region {
            queryItems.append(contentsOf: region.queryItems)
        }
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            completion(nil, FetcherError.invalidURL)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, FetcherError.unknownError)
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .millisecondsSince1970
                let quakes = try jsonDecoder.decode(QuakeResults.self, from: data).features
                completion(quakes, nil)
            } catch {
                completion(nil, error)
                return
            }
            }.resume()
    }
    
    private let dateFormatter = ISO8601DateFormatter()
    static let baseURL = URL(string: "https://earthquake.usgs.gov/fdsnws/event/1/query")!
}
