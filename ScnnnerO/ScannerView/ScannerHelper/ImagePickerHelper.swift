//
//  ImagePickerHelper.swift
//  ScnnnerO
//
//  Created by Supalert Kamolsin on 16/10/2566 BE.
//

import SwiftUI

struct ImagePickerHelper: UIViewControllerRepresentable {
	@Environment(\.presentationMode) var presentationMode
	@Binding var selectedImage: UIImage
	
	func makeCoordinator() -> PickerCoordinator {
		PickerCoordinator($selectedImage, _presentationMode)
	}
	
	func makeUIViewController(context: Context) -> UIImagePickerController {
		let imagePicker = UIImagePickerController()
		imagePicker.allowsEditing = false
		imagePicker.sourceType = .savedPhotosAlbum
		imagePicker.delegate = context.coordinator
		return imagePicker
	}
	
	func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
	}
}

class PickerCoordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	@Environment(\.presentationMode) var presentationMode
	@Binding var selectedImage: UIImage
	
	init(_ selectedImage: Binding<UIImage>, _ presentationMode: Environment<Binding<PresentationMode>>) {
		self._selectedImage = selectedImage
		self._presentationMode = presentationMode
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
			selectedImage = image
		}
		
		presentationMode.wrappedValue.dismiss()
	}
}
