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
    @State private var mapSelection : MKMapItem?
    @State private var showDetails = false
    @State private var getDirections = false
    @State private var routeDisplaying = false
    @State private var route : MKRoute?
    @State private var routeDestination: MKMapItem?
    
    var body: some View {
        
        Map(position: $cameraPosition, selection : $mapSelection){
            
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
                if routeDisplaying{
                    if item == routeDestination{
                        let placeMark = item.placemark
                        Marker(placeMark.name ?? "", coordinate: placeMark.coordinate)
                    }
                }
                else {
                    let placeMark = item.placemark
                    Marker(placeMark.name ?? "", coordinate: placeMark.coordinate)
                }
            }
            
            if let route {
                MapPolyline(route.polyline)
                    .stroke(.blue, lineWidth: 6)
            }
            
        }
        .overlay(alignment: .top, content: {
            TextField("Search for a location...", text: $searchText)
                .frame(width: 260)
                .font(.subheadline)
                .padding(12)
                .background(.white)
                .padding()
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        })
        .onSubmit(of: /*@START_MENU_TOKEN@*/.text/*@END_MENU_TOKEN@*/) {
            Task{await searchPlaces()}
        }
        .onChange(of: getDirections) { oldValue, newValue in
            if newValue {
                print("Debuggg !!!!")
                fetchRoute()
            }
        }
        .onChange(of: mapSelection, { oldValue, newValue in
            showDetails = newValue != nil
        })
        .sheet(isPresented: $showDetails, content: {
            LocationDetailsView(mapSelection: $mapSelection, show: $showDetails, getDirections: getDirections)
                .presentationDetents([.height(340)])
                .presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
                .presentationCornerRadius(12)
        })
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
        
        let result = try? await MKLocalSearch(request: request).start()
            self.results = result?.mapItems ?? []
            }
    
       func fetchRoute() {
        if let mapSelection {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: .init(coordinate: .userLocation))
            request.destination = mapSelection
            
            Task {
                let result = try? await MKDirections(request: request).calculate()
                route = result?.routes.first
                routeDestination = mapSelection
                
                withAnimation(.snappy) {
                    routeDisplaying = true
                    showDetails = false
                    if let rect = route?.polyline.boundingMapRect, routeDisplaying {
                        cameraPosition = .rect (rect)
                    }
                }
             }
        }
    }
}


#Preview {
    ContentView()
}



