
import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    fileprivate var locManager = LocationManager.instance
    fileprivate var isFirstLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locManager.initialize()
        self.customizeMap()
    }
    
    fileprivate func customizeMap() {
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(self.addPin))
        self.map.addGestureRecognizer(tap)
    }
    
    @IBAction func findMe() {
        self.setMapRegion(self.map.userLocation.coordinate)
    }
    
    fileprivate func setMapRegion(_ coordinate: CLLocationCoordinate2D) {
        let zoom = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: coordinate, span: zoom)
        self.map.setRegion(region, animated: true)
    }
    
    @objc func addPin(_ gesture: UILongPressGestureRecognizer) {
        
        let location = gesture.location(in: self.map)
        let coordinate = self.map.convert(location, toCoordinateFrom: self.map)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "AR Location"
        self.map.addAnnotation(annotation)
        
    }
    
    fileprivate func openARView(_ coordinate: CLLocationCoordinate2D) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "ARViewController") as! ARViewController
        vc.coordinate = coordinate
        vc.userCoordinate = self.map.userLocation.coordinate
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        guard self.isFirstLoad else {
            return
        }
        
        self.findMe()
        self.isFirstLoad = !self.isFirstLoad
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let id = "pin"
        var view = self.map.dequeueReusableAnnotationView(withIdentifier: id)
        
        guard view == nil else {
            view?.annotation = annotation
            return view
        }
        
        view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: id)
        view?.canShowCallout = true
        view?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        return view
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard let coord = view.annotation?.coordinate else {
            return
        }
        
        self.openARView(coord)
        
    }
    
}
