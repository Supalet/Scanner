//
//  ScannerView.swift
//  ScnnnerO
//
//  Created by Supalert Kamolsin on 16/10/2566 BE.
//

import SwiftUI

struct ScannerView: View {
	@ObservedObject var viewModel = ScannerViewModel()
	@State private var showingSheet = false
	
	@State var codeQr = ""
	@State private var imagePicker = UIImage()
	
	var body: some View {
		ZStack {
			VStack {
				if viewModel.scanResult == "" {
					QRScanner(result: $codeQr)
						.edgesIgnoringSafeArea(.all)
						.onChange(of: codeQr) {
							viewModel.scanResult = codeQr
						}
				} else {
					Text(viewModel.scanResult)
					Button {
						viewModel.scanResult = ""
					} label: {
						Text("Scan Again")
					}
				}
			}
			
			VStack {
				Spacer()
				
				HStack {
					Spacer()
					
					Button {
						showingSheet.toggle()
					} label: {
						Image(systemName: "folder")
							.resizable()
							.frame(width: 30, height: 30)
							.foregroundStyle(.white)
							.padding()
							.background(.green)
							.clipShape(Circle())
					}
					.sheet(isPresented: $showingSheet) {
						ImagePickerHelper(selectedImage: $imagePicker)
					}
					.onChange(of: imagePicker) {
						viewModel.scannnerFromimage(image: imagePicker)
					}
				}
				.padding(.horizontal, 20)
			}
		}
    }
}
