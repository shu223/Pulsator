//
//  MapDemoView.swift
//  PulsatorDemo
//
//  Created by Shuichi Tsutsumi on 2026/05/22.
//

import SwiftUI
import MapKit

// Mirrors the UIKit demo's MapViewController: a single pulsing halo annotation
// rendered with MapKit for SwiftUI (`Map` + `Annotation`, iOS 17+).

struct MapDemoView: View {

    private let coordinate = CLLocationCoordinate2D(latitude: 50, longitude: -100)
    private let haloRadius: CGFloat = 40

    var body: some View {
        Map(initialPosition: .region(
            MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
            )
        )) {
            // `anchor: .center` aligns the frame's center with the coordinate.
            // The pulse expands beyond its frame, so the frame is sized to the
            // pulse diameter and left unclipped.
            Annotation("TITLE", coordinate: coordinate, anchor: .center) {
                ZStack {
                    PulsatorView(
                        numPulse: 5,
                        radius: haloRadius,
                        animationDuration: 3,
                        color: SwiftUI.Color(red: 0, green: 0.455, blue: 0.756),
                        isPulsating: true
                    )
                    .frame(width: haloRadius * 2, height: haloRadius * 2)

                    // A small dot marking the halo's center.
                    Circle()
                        .fill(SwiftUI.Color(red: 0, green: 0.455, blue: 0.756))
                        .frame(width: 12, height: 12)
                }
            }
        }
        .navigationTitle("Map")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        MapDemoView()
    }
}
