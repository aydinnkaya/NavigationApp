//
//  Extensions.swift
//  NavigationApp
//
//  Created by Aydın KAYA on 15.03.2024.
//

import MapKit
import Foundation




extension CLLocationCoordinate2D{
    static var userLocation: CLLocationCoordinate2D{
        
        return .init(latitude: 25.7602, longitude: -80.1959)
    }
}

extension MKCoordinateRegion{
     static var userRegion : MKCoordinateRegion{
    
        return .init(center: .userLocation,
                     latitudinalMeters: 10000,
                     longitudinalMeters: 10000)
    }
}



