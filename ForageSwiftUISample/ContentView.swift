//
//  ContentView.swift
//  SwiftUISample
//
//  Created by Danilo Joksimovic on 2023-10-26.
//

import SwiftUI
import ForageSDK

struct ContentView: View {
    @ObservedObject private var viewModel: ForageViewModel
    
    @State private var tokenizeResult: PaymentMethodModel?
    @State private var balanceResult: BalanceModel?
    
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    
    @State private var textInput: String = ""
    
    init(viewModel: ForageViewModel) {
        self.viewModel = viewModel
        
        ForageSDK.setup(
            ForageSDK.Config(
                merchantID: "1234567",
                sessionToken: "sandbox_...."
            )
        )
    }
    
    var body: some View {
        
        ScrollView {
            Text("(PAN) is empty: \(viewModel.panInputValidationState?.isEmpty ?? false ? "✅" : "❌")")
                .padding()
            
                .onReceive(viewModel.$isPanElementFocused) { isFocused in
                    print("PAN element changed? \(isFocused)")
                }
            
            Text("(PAN) is valid: \(viewModel.panInputValidationState?.isValid ?? false ? "✅" : "❌")")
                .padding()
            
            Text("(PAN) is complete: \(viewModel.panInputValidationState?.isComplete ?? false ? "✅" : "❌")")
                .padding()
            
            Text("(PAN) has focus: \(viewModel.isPanElementFocused ? "Focused" : "Blurred")")
                .padding()
            
            let isPanValid = viewModel.panInputValidationState?.isValid ?? true
            let isPanFocused = viewModel.panInputValidationState?.isFirstResponder ?? true
            
            let showRedBorder = !isPanFocused && !isPanValid
            
            VStack {
                VStack {
                    ForagePANView(
                        viewModel: viewModel,
                        borderWidth: 2.0,
                        borderColor: showRedBorder ? .red : .systemGreen
                    )
                }.frame(height: 37)
                    .padding()
                
                Button(action: {
                    if let textField = viewModel.panTextField {
                        ForageSDK.shared.tokenizeEBTCard(
                            foragePanTextField: textField,
                            // TODO: update with real customer ID
                            customerID: "dev_swiftui_customer_id"
                        ) { result in
                            switch result {
                            case .success(let paymentMethod):
                                tokenizeResult = paymentMethod
                                break
                            case .failure(let error):
                                errorMessage = error.localizedDescription
                                showError = true
                                break
                            }
                        }
                    }
                }) {
                    Text("Submit EBT Card")
                        .padding()
                        .background(viewModel.panInputValidationState?.isComplete ?? true ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Text(
                    "PaymentMethod ref: \(tokenizeResult?.paymentMethodIdentifier ?? "")"
                ).padding()
                
                Spacer()
                
                VStack {
                    ForagePINView(
                        viewModel: viewModel,
                        borderWidth: 2.0,
                        borderColor: .black
                    )
                }.frame(width: 140, height: 80)
                    .padding()
                
                Button(action: {
                    guard let tokenizeResult = tokenizeResult else { return }
                    
                    if let pinTextField = viewModel.pinTextField {
                        ForageSDK.shared.checkBalance(
                            foragePinTextField: pinTextField,
                            paymentMethodReference: tokenizeResult.paymentMethodIdentifier
                        ) { result in
                            switch result {
                            case .success(let balance):
                                balanceResult = balance
                                break
                            case .failure(let error):
                                errorMessage = error.localizedDescription
                                showError = true
                                break
                            }
                        }
                    }
                }) {
                    let isComplete = viewModel.pinInputValidationState?.isComplete ?? true
                    
                    Text("Check Balance")
                        .padding()
                        .background(isComplete ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }.padding()
                
                Text(
                    "Balance - SNAP: \(balanceResult?.snap ?? "N/A"), Cash \(balanceResult?.cash ?? "N/A")"
                )
            }
            .padding()
            .alert(isPresented: $showError) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .onTapGesture {
            // dismiss keyboard on tap outside!
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .scrollDismissesKeyboard(.immediately)
    }
}

// Comment out if your version of Xcode supports the #Preview macro

//#Preview {
//    ContentView(viewModel: ForageViewModel())
//}
