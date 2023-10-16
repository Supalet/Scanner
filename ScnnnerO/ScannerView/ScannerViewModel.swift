//
//  ScannerViewModel.swift
//  ScnnnerO
//
//  Created by Supalert Kamolsin on 16/10/2566 BE.
//

import Photos
import Vision
import Foundation
import SwiftUI

class ScannerViewModel: ObservableObject {
	@Published var scanResult = ""
	@Published var imageResult = UIImage()
	
	var vnBarCodeDetectionRequest: VNDetectBarcodesRequest {
		let requestCode = VNDetectBarcodesRequest { (request,error) in
			if let error = error as NSError? {
				return
			} else {
				guard let observations = request.results as? [VNDetectedObjectObservation] else { return }
				if let barcode = observations.first as? VNBarcodeObservation {
					self.scanResult = barcode.payloadStringValue ?? ""
					self.imageResult = UIImage()
				}
			}
		}
		return requestCode
	}
	
	init() {
		requestPhotoLibraryAccess()
	}
	
	private func requestPhotoLibraryAccess() {
		let status = PHPhotoLibrary.authorizationStatus()
		
		switch status {
		case .notDetermined:
			PHPhotoLibrary.requestAuthorization { newStatus in
				if newStatus == .authorized {
					print("Access granted.")
				} else {
					print("Access denied.")
				}
			}
		case .restricted, .denied:
			print("Access denied or restricted.")
		case .authorized:
			print("Access already granted.")
		case .limited:
			print("Access limited.")
		@unknown default:
			print("Unknown authorization status.")
		}
	}
	
	func saveCodeScan(code: String) {
		scanResult = code
	}
	
	func saveImageFromPicker(image: UIImage) {
		imageResult = image
	}
	
	func scannnerFromimage(image: UIImage) {
		var qrCode = ""
		if let features = self.detectQRCode(image), !features.isEmpty {
			for case let code as CIQRCodeFeature in features {
				scanResult = code.messageString ?? ""
			}
		}
		
		if qrCode == "" {
			createVisionRequest(image: imageResult)
		}
	}
	
	func createVisionRequest(image: UIImage) {
		guard let cgImage = image.cgImage else { return }
		let requestHandler = VNImageRequestHandler(cgImage: cgImage,
												   orientation: .up,
												   options: [:])
		let vnRequests = [vnBarCodeDetectionRequest]
		do {
			try requestHandler.perform(vnRequests)
		} catch let error as NSError {
			print("Error in performing Image request: \(error)")
		}
	}
	
	func detectQRCode(_ image: UIImage?) -> [CIFeature]? {
		if let image = image, let ciImage = CIImage.init(image: image) {
			var options: [String: Any]
			let context = CIContext()
			options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
			let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)
			if ciImage.properties.keys.contains((kCGImagePropertyOrientation as String)) {
				options = [CIDetectorImageOrientation: ciImage.properties[(kCGImagePropertyOrientation as String)] ?? 1]
			} else {
				options = [CIDetectorImageOrientation: 1]
			}
			let features = qrDetector?.features(in: ciImage, options: options)
			return features
		}
		return nil
	}
}
