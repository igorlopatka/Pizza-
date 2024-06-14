//
//  ARPizzaView.swift
//  Pizza?
//
//  Created by Igor Łopatka on 14/06/2024.
//

import SwiftUI
import RealityKit
import ARKit


struct ARPizzaView: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let configuration = ARWorldTrackingConfiguration()
        arView.session.run(configuration)
        addPizzaModel(to: arView)
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}

    private func addPizzaModel(to arView: ARView) {
        guard let pizzaModel = try? Entity.load(named: "PizzaModel") else {
            fatalError("Failed to load pizza model")
        }
        let anchor = AnchorEntity(world: [0, 0, -0.5]) // Position the model half a meter in front of the camera
        anchor.addChild(pizzaModel)
        pizzaModel.setParent(anchor)
        
        arView.scene.addAnchor(anchor)
        
        // Make the pizza model spin
                pizzaModel.addRotationAnimation(duration: 10, axis: [0, 1, 0])
            }
}

extension Entity {
    func addRotationAnimation(duration: TimeInterval, axis: SIMD3<Float>) {
        let rotation = Transform(pitch: 0, yaw: .pi * 2, roll: 0)
        let animation = try! Entity.load(named: "PizzaModel").move(
            to: rotation, relativeTo: self, duration: duration, timingFunction: .linear)
        self.move(to: rotation, relativeTo: self, duration: duration, timingFunction: .linear)
    }
}

#Preview {
    ARPizzaView()
}
