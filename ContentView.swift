//
//  ContentView.swift
//  NavigationApp
//
//  Created by Aydın KAYA on 14.03.2024.
//

import SwiftUI
import MapKit


struct ContentView: View {
    @State private var cameraPosition : MapCameraPosition = .region(.userRegion)
    @State private var searchText = ""
    @State private var results = [MKMapItem]()
    
    var body: some View {
        
        
        Map(position: $cameraPosition){
            Annotation("My Location", coordinate: .userLocation) {
                ZStack{
                    Circle()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(.blue.opacity(0.25))
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.white)
                    Circle()
                        .frame(width: 12, height: 12)
                        .foregroundStyle(.blue)
                    
                }
            }
            
            ForEach(results ,id: \.self){ item in
                
                
            }
        }
        .overlay(alignment: .top, content: {
            TextField("Search for a location...", text: $searchText)
                .font(.subheadline)
                .padding(12)
                .background(.white)
                .padding()
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        })
        .onSubmit(of: /*@START_MENU_TOKEN@*/.text/*@END_MENU_TOKEN@*/) {
            Task{await searchPlaces()}
        }
        .mapControls {
            MapCompass()
            MapPitchToggle()
            MapUserLocationButton()
        }
    }
}




extension ContentView{
    func searchPlaces() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = .userRegion
        
        if let result = try? await MKLocalSearch(request: request).start() {
                   self.results = result.mapItems
               } else {
                   self.results = []
               }
        
    }
}




#Preview {
    ContentView()
}
