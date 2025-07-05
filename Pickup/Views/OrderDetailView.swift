//
//  OrderDetail.swift
//  Pickup
//
//  Created by Luis Enrique Perez Tapia on 04/07/25.
//

import Foundation
import SwiftUI


public struct OrderDetailView: View {
    
    let orderID: Int
    @StateObject private var viewModel = OrdersDetailViewModel()
    @State private var showAlert = false
    @State private var showConfirmAlert = false
    @State private var showMissingSerialAlert = false

    @State private var showEntregarAlert = false
    
    
    public var body: some View {
        
        NavigationStack{
            
            if let order = viewModel.order {
                
                VStack(alignment: .leading) {
                    if let order = viewModel.order {
                        Text(viewModel.statusText).font(.title)
                            .foregroundColor(.text)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                        HStack {
                            VStack(alignment: .leading) {
                                Text("#\(order.id)").bold()
                                    .foregroundColor(.text)
                                Text(order.createdAt).font(.caption)
                                    .foregroundColor(.text)
                            }
                            Spacer()
                            Text(order.status.capitalized)
                                .foregroundColor(.text)
                                .font(.caption)
                                .padding(6)
                                .background(tagColor(for: order.status))
                                .foregroundColor(tagTextColor(for: order.status))
                                .cornerRadius(6)
                        }.padding()

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Nombre: \(order.customer_name)")
                                .foregroundColor(.text)
                            Text("Teléfono: \(order.phone)")
                                .foregroundColor(.text)
                            Text("Email: \(order.email)")
                                .foregroundColor(.text)
                        }.padding(.horizontal)

                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(order.orderDetails) { item in
                                    OrderItemRow(item: item) {
                                        viewModel.selectedItem = item
                                        viewModel.showModal = true
                                    }
                                }
                            }.padding()
                        }

                        HStack {
                            Text("Total:").bold()
                                .foregroundColor(.text)
                            Spacer()
                            if let total = Double(order.totalAmount) {
                                //Text(String(format: "$%.2f MXN", total))
                                Text("$\(String(format: "%.2f", total)) MXN")
                                
                                    .foregroundColor(.text)
                            } else {
                                Text("$\(order.totalAmount) MXN")
                                
                                    .foregroundColor(.text)
                            }
                        }.padding()

                        if order.status == "Asignado" {
                            HStack {
                                Button("Rechazar") {
                                    showAlert = true
                                }
                                .alert("Rechazar", isPresented: $showAlert) {
                                            Button("Cancelar", role: .cancel) { }
                                            Button("Rechazar", role: .destructive) {
                                                // Acción al confirmar
                                                print("Acción confirmada")
                                                showAlert = false
                                                viewModel.updateOrderStatus(orderId: order.id, status: "Cancelado")
                                                
                                            }
                                        } message: {
                                            Text("¿Estás seguro de que deseas rechazar el pedido?")
                                        }
                                .padding().background(Color.red).foregroundColor(.white).cornerRadius(8)
                                Spacer()
                                Button("Confirmar") {
                                    // Check all serial numbers first
                                    let allFilled = order.orderDetails.allSatisfy { detail in
                                        detail.serialNumbers.allSatisfy { $0.numSerie != "" }
                                    }
                                    
                                    if !allFilled {
                                        showMissingSerialAlert = true
                                    } else {
                                        showConfirmAlert = true
                                    }
                                }
                                .padding().background(Color.green).foregroundColor(.white).cornerRadius(8)
                                .alert("Error", isPresented: $showMissingSerialAlert) {
                                    Button("Aceptar", role: .cancel) { }
                                } message: {
                                    Text("Falta ingresar un número de serie en uno o más productos")
                                }
                                .alert("Confirmar", isPresented: $showConfirmAlert) {
                                    Button("Cancelar", role: .cancel) { }
                                    Button("Confirmar", role: .destructive) {
                                        viewModel.updateOrderStatus(orderId: order.id, status: "Confirmado")
                                    }
                                } message: {
                                    Text("¿Estás seguro de que deseas Confirmar el pedido?")
                                }
                            
                            }.padding()
                        } else if order.status == "Confirmado" {
                            HStack{
                                Button("Entregar") {
                                    showEntregarAlert = true
                                }
                                    .padding().background(Color.blue).foregroundColor(.white).cornerRadius(8)
                                    .alert("Entregar", isPresented: $showEntregarAlert) {
                                        Button("Cancelar", role: .cancel) { }
                                        Button("Entregar", role: .destructive) {
                                            viewModel.updateOrderStatus(orderId: order.id, status: "Entregado")
                                        }
                                    } message: {
                                        Text("¿Estás seguro de que deseas Entregar el pedido?")
                                    }
                            }.padding()
                        }
                    }
                }
                
            }
            else{
                
                VStack{
                    Text("No se pudo cargar el pedido")
                    Button("Recargar Página") {
                        viewModel.refresh(orderId: orderID)
                    }
                }
                .background(.bg)
                
            }
            
        
            
        }
        .background(Color.bg)
        .onAppear {
            viewModel.loadOrder(orderId: orderID)
        }
        .sheet(isPresented: $viewModel.showModal) {
            if let item = viewModel.selectedItem, let order = viewModel.order {
                SerialNumberModalView(item: item, orderId: orderID, orderStatus: viewModel.order?.status ?? "Entregado" , onDismiss: {
                    viewModel.refresh(orderId: orderID)
                })
            }
        }
    }
    
    public func tagColor(for status: String) -> Color {
        switch status.lowercased() {
        case "asignado": return Color.yellow
        case "entregado": return Color.blue
        case "cancelado": return Color.red
        case "confirmado": return Color.green
        default: return Color.gray
        }
    }

    public func tagTextColor(for status: String) -> Color {
        switch status.lowercased() {
        case "asignado": return Color.black
        default: return Color.white
        }
    }
    
}


struct OrderItemRow: View {
    let item: OrderItemDto
    var onTap: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack{
                    Spacer()
                    AsyncImage(url: URL(string: item.image)) { phase in
                        switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 60, height: 60)
                            case .success(let image):
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .clipped()
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.gray)
                            @unknown default:
                                EmptyView()
                        }
                    }
                    
                    Spacer()
                }
                VStack(alignment: .leading) {
                    Text(item.productDescription).bold().foregroundStyle(.text)
                    Text(item.ean).font(.caption).foregroundColor(.gray)
                    VStack {
                        HStack{
                            Text("Cantidad: \(item.quantity)")
                                .foregroundStyle(.text)
                            Spacer()
                        }
                        //Spacer()
                        
                        HStack{
                            if let total = Double(item.unitPrice) {
                                Text("Precio Unitario: $\(String(format: "%.2f", total)) MXN")
                                    .foregroundStyle(.text)
                            } else {
                                Text("$\(item.unitPrice) MXN")
                                    .foregroundStyle(.text)
                            }
                            Spacer()
                        }
                        
                        
                    }.font(.caption)
                    if item.serialNumbers.isEmpty == false {
                        
                        let allFilled = item.serialNumbers.allSatisfy { $0.numSerie != "" }
                                
                        HStack{
                            
                            Text("número serie")
                                        .font(.caption2)
                                        .foregroundColor(allFilled ? .blue : .red)
                            Spacer()
                        }
                    }
                }
                .padding(.leading, 5)
                
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
        .onTapGesture {
            if item.serialNumbers.isEmpty == false {
                onTap?()
            }
        }
        
    }
}


#Preview {
    OrderDetailView(orderID: 1)
}
