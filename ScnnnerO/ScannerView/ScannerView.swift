//
//  ScannerView.swift
//  ScnnnerO
//
//  Created by Supalert Kamolsin on 16/10/2566 BE.
//

import SwiftUI

struct ScannerView: View {
	@State var scanResult = ""
	
    var body: some View {
		VStack {
			if scanResult == "" {
				QRScanner(result: $scanResult)
					.onAppear {
						print(scanResult)
					}
			} else {
				Text(scanResult)
				Button {
					scanResult = ""
				} label: {
					Text("Scan Again")
				}
			}
		}
    }
}
