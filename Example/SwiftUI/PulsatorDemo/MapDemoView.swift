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
            // `anchor: .center` aligns the annotation's center with the
            // coordinate. The `.pulsator` modifier renders the pulse behind the
            // center dot, expanding beyond it without clipping.
            Annotation("TITLE", coordinate: coordinate, anchor: .center) {
                // A small dot marking the halo's center.
                Circle()
                    .fill(SwiftUI.Color(red: 0, green: 0.455, blue: 0.756))
                    .frame(width: 12, height: 12)
                    .pulsator(
                        numPulse: 5,
                        radius: haloRadius,
                        animationDuration: 3,
                        color: SwiftUI.Color(red: 0, green: 0.455, blue: 0.756)
                    )
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
