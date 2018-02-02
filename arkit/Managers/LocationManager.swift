
import Foundation
import CoreLocation

protocol LocationManagerDelegate: class {
    func updateLocations(_ locations: [CLLocation])
}

class LocationManager: NSObject {
    
    weak var delegate: LocationManagerDelegate?
    
    static let instance = LocationManager()
    var manager = CLLocationManager()
    
    func initialize() {
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.requestWhenInUseAuthorization()
        self.manager.startUpdatingLocation()
    }
    
    func stop() {
        self.manager.stopUpdatingLocation()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.delegate?.updateLocations(locations)
    }
    
}
