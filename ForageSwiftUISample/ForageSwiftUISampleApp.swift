//
//  ForageSwiftUISampleApp.swift
//  ForageSwiftUISample
//
//  Created by Danilo Joksimovic on 2023-10-26.
//

import SwiftUI

@main
struct ForageSwiftUISampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ForageViewModel())
        }
    }
}
