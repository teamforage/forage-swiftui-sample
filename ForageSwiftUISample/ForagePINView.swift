//
//  ForagePINView.swift
//  ForageSwiftUISample
//
//  Created by Danilo Joksimovic on 2023-10-26.
//

import Foundation

import SwiftUI
import ForageSDK

struct ForagePINView: UIViewRepresentable {
    @ObservedObject var viewModel: ForageViewModel
    
    class Coordinator: NSObject, ForageElementDelegate {
        var parent: ForagePINView
        
        init(parent: ForagePINView) {
            self.parent = parent
        }
        
        func textFieldDidChange(_ state: ObservableState) {
            parent.viewModel.pinInputValidationState = state
        }
        
        func focusDidChange(_ state: ObservableState) {
            parent.viewModel.isPinElementFocused = state.isFirstResponder
        }
    }
    
    // MARK: Styling options
    var borderWidth: CGFloat = 1.0
    var borderColor: UIColor = .black
    // ....
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> ForagePINTextField {
        let textField = ForagePINTextField()
        
        textField.delegate = context.coordinator
        viewModel.pinTextField = textField

        return textField
    }
    
    func updateUIView(_ uiView: ForagePINTextField, context: Context) {
        uiView.borderWidth = borderWidth
        uiView.borderColor = borderColor
        uiView.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    }
}

