
import UIKit
import SceneKit
import ARKit
import CoreLocation

class ARViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var originalTransform: SCNMatrix4!
    var distance: Float = 0.0
    var heading: Double = 0.0
    var userCoordinate: CLLocationCoordinate2D!
    var coordinate: CLLocationCoordinate2D!
    var userLocation: CLLocation!
    var location: CLLocation!
    var modelNode: SCNNode!
    let rootNodeName = "Rocket"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.sceneView.delegate = self
        self.sceneView.showsStatistics = false
        
        self.updateLocation()
        self.createNode()
        self.addCloseButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.worldAlignment = .gravityAndHeading
        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    fileprivate func updateLocation() {
        self.location = CLLocation(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
        self.userLocation = CLLocation(latitude: self.userCoordinate.latitude, longitude: self.userCoordinate.longitude)
        self.distance = Float(self.location.distance(from: self.userLocation))
    }
    
    fileprivate func createNode() {
        
        guard self.modelNode == nil else {
            return
        }
        
        let modelScene = SCNScene(named: "art.scnassets/\(rootNodeName).dae")!
        self.modelNode = modelScene.rootNode.childNode(withName: rootNodeName, recursively: true)!
        
        let (minBox, maxBox) = self.modelNode.boundingBox
        self.modelNode.pivot = SCNMatrix4MakeTranslation(0, (maxBox.y - minBox.y)/2, 0)
        
        self.originalTransform = self.modelNode.transform
        let location = CLLocation(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
        positionModel(location)
        sceneView.scene.rootNode.addChildNode(self.modelNode)
        
    }
    
    func positionModel(_ location: CLLocation) {
        self.modelNode.transform = ARHelper.rotateNode(Float(-1 * (self.heading - 180).toRadians()), self.originalTransform)
        self.modelNode.position = ARHelper.translateNode(self.location, userLocation: self.userLocation, distance: self.distance)
        self.modelNode.scale = ARHelper.scaleNode(self.location, distance: self.distance)
    }
    
    func addCloseButton() {
        let closeButton: UIButton = UIButton(type: UIButtonType.custom)
        closeButton.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        closeButton.frame = CGRect(x: self.view.bounds.size.width - 45, y: 22, width: 40, height: 40)
        closeButton.addTarget(self, action: #selector(self.closeScreen), for: .touchUpInside)
        closeButton.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleBottomMargin]
        self.view.addSubview(closeButton)
    }
    
    @objc func closeScreen() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
