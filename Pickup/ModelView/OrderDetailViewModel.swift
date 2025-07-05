//
//  OrderDetailViewModel.swift
//  Pickup
//
//  Created by Luis Enrique Perez Tapia on 04/07/25.
//

import Foundation


class OrdersDetailViewModel: ObservableObject {
    
    @Published var order: OrderDto? = nil
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedItem: OrderItemDto?
    @Published var showModal = false
    @Published var statusText: String = ""
    
    func loadOrder(orderId: Int) {
        isLoading = true
        errorMessage = nil
        
        APIService.shared.fetchOrderByID(orderId: orderId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let order):
                    self?.order = order
                    self?.statusText = self?.mapStatusText(order.status) ?? ""
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("Failed to load order: \(error)")
                }
            }
        }
    }
    
    func updateOrderStatus(orderId: Int, status : String ) {
        isLoading = true
        errorMessage = nil
        
        APIService.shared.updateOrderStatus(orderId: orderId,status : status ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let order):
                    
                    print("actualizando orden")
                    self?.errorMessage = "Estatus Actualizado con éxito."
                    self?.refresh(orderId: orderId)
                    
                case .failure(let error):
                    print("error al actualizar orden")
                    self?.errorMessage = "Error al actualizar estatus de pedido."
                    print("Failed to load order: \(error)")
                }
            }
        }
    }

    func refresh(orderId: Int) {
        loadOrder(orderId: orderId)
    }
    
    private func mapStatusText(_ status: String) -> String {
        switch status.lowercased() {
        case "asignado": return "Confirmación de Pedido"
        case "confirmado": return "Entregar Pedido"
        case "cancelado": return "Pedido Cancelado"
        case "entregado": return "Pedido Entregado"
        default: return ""
        }
    }
}

