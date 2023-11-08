//
//  ForageViewModel.swift
//  ForageSwiftUISample
//
//  Created by Danilo Joksimovic on 2023-10-26.
//

import ForageSDK
import Foundation

class ForageViewModel: ObservableObject {
    @Published var panTextField: ForagePANTextField?
    @Published var pinTextField: ForagePINTextField?

    @Published var panInputValidationState: ObservableState?
    @Published var isPanElementFocused: Bool = false

    @Published var pinInputValidationState: ObservableState?
    @Published var isPinElementFocused: Bool = false
}
