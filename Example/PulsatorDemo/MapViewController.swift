//
//  MapViewController.swift
//  PulsatorDemo
//
//  Created by Shuichi Tsutsumi on 6/12/16.
//  Copyright © 2016 Shuichi Tsutsumi. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let delta = 5.0
        var region = MKCoordinateRegion()
        region.center.latitude = 50.0
        region.center.longitude = -100.0
        region.span.latitudeDelta = delta
        region.span.longitudeDelta = delta
        mapView.setRegion(region, animated: true)
        
        mapView.delegate = self
        addAnnotations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func addAnnotations() {
        let point = MKPointAnnotation()
        point.coordinate = CLLocationCoordinate2DMake(50, -100)
        point.title = "TITLE"
        point.subtitle = "Subtitle"
        mapView.addAnnotation(point)
    }
    
    // =========================================================================
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKindOfClass(MKUserLocation) else { return nil }

        return AnnotationView(annotation: annotation, reuseIdentifier: "PulsatorDemoAnnotation")
    }

    // =========================================================================
    // MARK: - Actions
    
    @IBAction func backBtnTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

class AnnotationView: MKAnnotationView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        addHalo()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addHalo() {
        let pulsator = Pulsator()
        pulsator.position = center
        pulsator.numPulse = 5
        pulsator.radius = 40
        pulsator.animationDuration = 3
        pulsator.backgroundColor = UIColor(red: 0, green: 0.455, blue: 0.756, alpha: 1).CGColor
        layer.addSublayer(pulsator)
        pulsator.start()
    }
}