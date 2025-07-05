//
//  HomeViewModel.swift
//  Pickup
//
//  Created by Luis Enrique Perez Tapia on 04/07/25.
//

import Foundation


class OrdersListViewModel: ObservableObject {
    @Published var orders: [OrderDto] = []
    @Published var filter: String = "todos" {
        didSet {
            if oldValue != filter {
                debounceLoadOrders()
            }
        }
    }
    @Published var searchQuery: String = "" {
        didSet {
            if oldValue != searchQuery {
                debounceLoadOrders()
            }
        }
    }
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    
    private var debounceTimer: Timer?
    private let debounceDelay: TimeInterval = 0.5

    init() {
        loadOrders()
    }

    private func debounceLoadOrders() {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: debounceDelay, repeats: false) { _ in
            self.loadOrders()
        }
    }

    func loadOrders() {
        isLoading = true
        errorMessage = nil
        
        // Convert "todos" to nil (no filter)
        let statusFilter = filter == "todos" ? nil : filter
        
        // Use empty string as nil for query
        let searchQuery = searchQuery.isEmpty ? nil : searchQuery
        
        APIService.shared.fetchOrders(status: statusFilter, query: searchQuery) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let orders):
                    self?.orders = orders
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("Failed to load orders: \(error)")
                }
            }
        }
    }

    func refresh() {
        loadOrders()
    }
}
