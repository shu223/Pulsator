//
//  ContentView.swift
//  PulsatorDemo
//
//  Created by Shuichi Tsutsumi on 2026/05/22.
//

import SwiftUI

// Note: The demo target compiles the Pulsator sources directly, so `Pulsator`'s
// `public typealias Color = UIColor` is in scope. Use `SwiftUI.Color` explicitly
// to avoid ambiguity.

struct ContentView: View {

    // Initial values mirror the UIKit demo.
    @State private var numPulse: Double = 5
    @State private var radius: Double = 140
    @State private var duration: Double = 5
    @State private var red: Double = 0
    @State private var green: Double = 0.455
    @State private var blue: Double = 0.756
    @State private var alpha: Double = 1
    @State private var isPulsating = true

    private var pulseColor: SwiftUI.Color {
        SwiftUI.Color(red: red, green: green, blue: blue).opacity(alpha)
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                PulsatorView(
                    numPulse: Int(numPulse),
                    radius: radius,
                    animationDuration: duration,
                    color: pulseColor,
                    isPulsating: isPulsating
                )
                Image(systemName: "iphone")
                    .font(.system(size: 64))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.secondary, .white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            controlPanel
                .padding()
                .background(.regularMaterial)
        }
        .navigationTitle("Pulsator")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    MapDemoView()
                } label: {
                    Image(systemName: "map")
                }
            }
        }
    }

    private var controlPanel: some View {
        VStack(spacing: 8) {
            sliderRow("Count", value: $numPulse, range: 1...20, format: "%.0f")
            sliderRow("Radius", value: $radius, range: 0...200, format: "%.0f")
            sliderRow("Duration", value: $duration, range: 0...10, format: "%.1f")
            sliderRow("R", value: $red, range: 0...1, format: "%.2f")
            sliderRow("G", value: $green, range: 0...1, format: "%.2f")
            sliderRow("B", value: $blue, range: 0...1, format: "%.2f")
            sliderRow("A", value: $alpha, range: 0...1, format: "%.2f")
            Toggle("Animating", isOn: $isPulsating)
        }
    }

    private func sliderRow(
        _ title: String,
        value: Binding<Double>,
        range: ClosedRange<Double>,
        format: String
    ) -> some View {
        HStack {
            Text(title)
                .frame(width: 64, alignment: .leading)
            Slider(value: value, in: range)
            Text(String(format: format, value.wrappedValue))
                .frame(width: 48, alignment: .trailing)
                .monospacedDigit()
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
