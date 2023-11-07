//
//  ForagePANView.swift
//  ForageSwiftUISample
//
//  Created by Danilo Joksimovic on 2023-10-26.
//

import SwiftUI
import ForageSDK

struct ForagePANView: UIViewRepresentable {
    @ObservedObject var viewModel: ForageViewModel
    
    class Coordinator: NSObject, ForageElementDelegate {
        var parent: ForagePANView
        
        init(parent: ForagePANView) {
            self.parent = parent
        }
        
        func textFieldDidChange(_ state: ObservableState) {
            parent.viewModel.panInputValidationState = state
        }
        
        func focusDidChange(_ state: ObservableState) {
            parent.viewModel.isPanElementFocused = state.isFirstResponder
            
        }
    }
    
    // MARK: Styling options
    var borderWidth: CGFloat = 1.0
    var borderColor: UIColor = .black
    var cornerRadius: CGFloat = 4
    var padding: UIEdgeInsets = UIEdgeInsets()
    var font: UIFont = UIFont.systemFont(ofSize: 20, weight: .regular)
    var textColor: UIColor = .black
    var tfTintColor: UIColor = .black
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> ForagePANTextField {
        let textField = ForagePANTextField()
        
        textField.delegate = context.coordinator
        viewModel.panTextField = textField
        
        return textField
    }
    
    func updateUIView(_ uiView: ForagePANTextField, context: Context) {
        uiView.borderWidth = borderWidth
        uiView.borderColor = borderColor
        uiView.cornerRadius = cornerRadius
        uiView.padding = padding
        uiView.font = font
        uiView.textColor = textColor
        uiView.tfTintColor = tfTintColor
    }
}

