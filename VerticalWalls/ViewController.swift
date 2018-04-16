//
//  ViewController.swift
//  VerticalPlaneDetection
//
//  Created by Gregory Chiste on 1/27/18.
//  Copyright © 2018 Gregory Chiste. All rights reserved.
//
import UIKit
import SceneKit
import ARKit


class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    
    
    @IBOutlet weak var ARView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ARView.delegate = self
        ARView.session.delegate = self
        ARView.showsStatistics = true
        ARView.autoenablesDefaultLighting = true
        let ARScene = SCNScene()
        ARView.scene = ARScene
        ARView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
    }
    
    //adding viewwillappear function
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // setting up our scene configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .vertical //iOS 11.3 beta ONLY!
        // running our configured session in our pianoView, at this point we can actually see things on-screen
        ARView.session.run(configuration)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        let planeNode = createPlaneNode(anchor: planeAnchor)
        node.addChildNode(planeNode)
   }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
         // Remove existing plane nodes
        node.enumerateChildNodes {
            (childNode, _) in
            childNode.removeFromParentNode()
        }
        let planeNode = createPlaneNode(anchor: planeAnchor)
        node.addChildNode(planeNode)
    }
    
    func createPlaneNode(anchor: ARPlaneAnchor) -> SCNNode {
        let planeNode = SCNNode()
        planeNode.geometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        planeNode.opacity = 0.3
        planeNode.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
        planeNode.eulerAngles = SCNVector3(-Float.pi/2,0,0)
        return planeNode
    }

    
    
}
