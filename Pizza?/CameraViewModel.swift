//
//  CameraViewModel.swift
//  Pizza?
//
//  Created by Igor Łopatka on 11/06/2024.
//

import SwiftUI
import AVFoundation
import Vision

class CameraViewModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var captureSession: AVCaptureSession?
    private var model: VNCoreMLModel?

    @Published var isPizza: Bool = false
    @Published var detectedLabel: String = ""

    override init() {
        super.init()
        setupModel()
        setupCamera()
    }

    private func setupModel() {
        guard let model = try? VNCoreMLModel(for: MyPizzaClassifier_1().model) else {
            fatalError("Failed to load model")
        }
        self.model = model
    }

    private func setupCamera() {
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession?.canAddInput(videoInput) ?? false) {
            captureSession?.addInput(videoInput)
        } else {
            return
        }

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession?.addOutput(videoOutput)
        captureSession?.startRunning()
    }

    private func classify(image: CVPixelBuffer) {
        guard let model = model else { return }

        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                return
            }

            DispatchQueue.main.async {
                self?.detectedLabel = topResult.identifier
                self?.isPizza = topResult.identifier == "pizza" // Assuming your model has a "pizza" label
            }
        }

        let handler = VNImageRequestHandler(cvPixelBuffer: image, options: [:])
        try? handler.perform([request])
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        classify(image: pixelBuffer)
    }
}
