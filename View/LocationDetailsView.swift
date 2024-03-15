//
//  LocationDetailsView.swift
//  NavigationApp
//
//  Created by Aydın KAYA on 15.03.2024.
//

import MapKit
import SwiftUI

struct LocationDetailsView: View {
    @Binding var mapSelection : MKMapItem?
    @Binding var show: Bool
    @State private var lookArroundScene : MKLookAroundScene?
    @State  var getDirections : Bool
    
    var body: some View {
        VStack{
            HStack{
                VStack(alignment: .leading){
                    Text(mapSelection?.placemark.name ?? "")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(mapSelection?.placemark.title ?? "")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                        .padding(.trailing)
                }
                
                Spacer()
                
                Button(action: {
                    show.toggle()
                    mapSelection = nil
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24,height: 24)
                        .foregroundStyle(.gray , Color(.systemGray6))
                })
            }
            .padding(.horizontal)
            .padding(.top)
            
            if let scene = lookArroundScene {
                LookAroundPreview(initialScene: scene)
                    .frame(height: 200)
                    .presentationCornerRadius(12)
                    .padding()
                
            }else{
                ContentUnavailableView("No preview available", systemImage: "eye.slash")
                
            }
            
            HStack(spacing: 24) {
                Button{
                    if let mapSelection{
                        mapSelection.openInMaps()
                    }
                }label: {
                    Text("Open in Maps")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 170,height: 48)
                        .background(.green)
                        .cornerRadius(12)
                }
                
                
                Button{
                    getDirections = true
                    show = false
                }label: {
                    Text("Get Directions")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 170,height: 48)
                        .background(.blue)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)
        }
        .onAppear{
            print("DEBUG: did call on appear")
            fetchLookArroundPreview()
        }
        .onChange(of: mapSelection) { oldValue, newValue in
            print("DEBUG: did call on change")
            fetchLookArroundPreview()
        }
  }
}




extension LocationDetailsView{
    func fetchLookArroundPreview(){
    
        if let mapSelection{
           lookArroundScene = nil
            Task{
                let request = MKLookAroundSceneRequest(mapItem: mapSelection)
                lookArroundScene = try? await request.scene
            }
        }
        
    }
}

#Preview {
    LocationDetailsView(mapSelection: .constant(nil), show: .constant(false), getDirections: (false))
}
