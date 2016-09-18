//: [Previous](@previous)

import UIKit
import XCPlayground
import Pulsator
import MapKit

class AnnotationView: MKAnnotationView {
    
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
        pulsator.backgroundColor = UIColor(red: 0, green: 0.455, blue: 0.756, alpha: 1).cgColor
        layer.addSublayer(pulsator)
        pulsator.start()
    }
}

class MapViewController: UIViewController, MKMapViewDelegate {

    let mapView = MKMapView(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.frame = view.bounds
        mapView.delegate = self
        let delta = 5.0
        var region = MKCoordinateRegion()
        region.center.latitude = 50.0
        region.center.longitude = -100.0
        region.span.latitudeDelta = delta
        region.span.longitudeDelta = delta
        mapView.setRegion(region, animated: true)

        view.addSubview(mapView)
        view.backgroundColor = UIColor.yellow
        
        addAnnotations()
    }
    
    private func addAnnotations() {
        let point = MKPointAnnotation()
        point.coordinate = CLLocationCoordinate2DMake(50, -100)
        point.title = "TITLE"
        point.subtitle = "Subtitle"
        mapView.addAnnotation(point)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.classForCoder()) else { return nil }
        
        return AnnotationView(annotation: annotation, reuseIdentifier: "PulsatorDemoAnnotation")
    }
}

let controller = MapViewController()
XCPlaygroundPage.currentPage.liveView = controller.view
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

//: [Next](@next)
