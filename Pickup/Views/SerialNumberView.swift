//
//  SerialNumberView.swift
//  Pickup
//
//  Created by Luis Enrique Perez Tapia on 04/07/25.
//

import Foundation
import SwiftUI
import AVFoundation

struct SerialNumberModalView: View {
    
    let item: OrderItemDto
    let orderId: Int
    var onDismiss: (() -> Void)?
    let orderStatus : String
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: SerialNumberViewModel
    
    
    @State var num : String = ""
    
    // Custom initializer
    init(item: OrderItemDto, orderId: Int, orderStatus : String, onDismiss: (() -> Void)? = nil){
            self.item = item
            self.orderId = orderId
            self.onDismiss = onDismiss
            self.orderStatus = orderStatus
            _viewModel = StateObject(wrappedValue: SerialNumberViewModel(codes: item.serialNumbers))
            
    }

    var body: some View {
        VStack {
            Text(item.productDescription)
                .foregroundColor(.text)
                .bold()
            Text(item.ean)
                .font(.caption)
                .foregroundColor(.gray)
            Text("Cantidad: \(item.quantity)")
                .foregroundColor(.text)
            
            Spacer().frame(height: 10)
        

            List {
                ForEach(Array(viewModel.scannedCodes.enumerated()), id: \.element.id) { index, code in
                    HStack {
                                    Text("Art. \(index + 1)")
                                        .foregroundColor(.text)
                                        .padding(.horizontal)
                                    Spacer()
                                }
                                .listRowBackground(Color.clear)
                                .scrollContentBackground(.hidden)
                                .background(Color.bg)
                        
                        
                    VStack(alignment: .leading) {
                        
                        if orderStatus == "Asignado" {
                            TextField("", text: $viewModel.scannedCodes[index].numSerie ,prompt: Text("Número de Serie").foregroundColor(Color.gray))
                                .autocapitalization(.none)
                                .foregroundColor(Color.text)
                            
                            
                        } else {
                            Text(viewModel.scannedCodes[index].numSerie)
                                .foregroundColor(.text)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
            }
            .background(Color.bg)
            .scrollContentBackground(.hidden)

            if(orderStatus == "Asignado"){
                Button("Confirmar") {
                    viewModel.confirm( ean: item.ean , orderId: orderId)
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            

        }
        .padding()
        .background(Color.bg)
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Resultado"),
                message: Text(viewModel.errorMessage),
                dismissButton: .default(Text("Cerrar")) {
                    onDismiss?()
                    dismiss()
                }
            )
        }
        
    }
        
}



