//
//  CameraView.swift
//  Pizza?
//
//  Created by Igor Łopatka on 12/06/2024.
//

import SwiftUI
import UIKit
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    
    @ObservedObject var viewModel: CameraViewModel

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .black
        viewModel.captureSession?.startRunning()

        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: viewModel.captureSession!)
        videoPreviewLayer.videoGravity = .resizeAspectFill

        let videoView = UIView(frame: viewController.view.bounds)
        videoView.layer.addSublayer(videoPreviewLayer)
        viewController.view.addSubview(videoView)
        videoPreviewLayer.frame = viewController.view.bounds

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    static func dismantleUIViewController(_ uiViewController: UIViewController, coordinator: ()) {
        (uiViewController as? CameraView)?.viewModel.captureSession?.stopRunning()
    }
}
