import SwiftUI


struct Home: View {
    
    
    var onLogout: () -> Void
    
    @StateObject private var viewModel = OrdersListViewModel()
    
    //@State private var isLoggedIn: Bool = true;

    var body: some View {
        NavigationStack{
            VStack(spacing: 16) {
                // Header
                HStack {
                    Image("logo").resizable().frame(width: 60, height: 40)
                    Spacer()
                    Text(viewModel.username).foregroundColor(.text)
                    Menu {
                        Button("Logout", role: .destructive) {
                            UserDefaultsManager.clearUserData()
                            //isLoggedIn = false
                            onLogout()
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .resizable().frame(width: 30, height: 30)
                            .foregroundColor(.text)
                    }
                }
                .padding()
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.text)
                    TextField("Buscar pedido", text: $viewModel.searchQuery)
                        .foregroundColor(.text)
                }
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Filter Buttons
                HStack {
                    ForEach(["Activos", "Finalizados", "Todos"], id: \.self) { filter in
                        Button(action: {
                            viewModel.filter = filter.lowercased()
                        }) {
                            Text(filter)
                                .padding(6)
                                .background(viewModel.filter == filter.lowercased() ? Color.blue : Color.gray.opacity(0.3))
                                .foregroundColor(.text)
                                .cornerRadius(10)
                        }
                    }
                    Spacer()
                    
                        Button(action: {
                            viewModel.refresh()
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .resizable().frame(width: 20, height: 20)
                                .foregroundColor(.blue)
                                .padding(.trailing, 10)
                                
                                
                        }
                    
                }
                .padding(.horizontal)
                
                // Content
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxHeight: .infinity)
                        .background(.bg)
                } else if let error = viewModel.errorMessage {
                    VStack {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                        Button("Reintentar") {
                            viewModel.refresh()
                        }
                    }
                    .frame(maxHeight: .infinity)
                    .background(.bg)
                } else {
                    List {
                        ForEach(viewModel.orders) { order in
                            NavigationLink(destination: OrderDetailView(orderID: order.id)) {
                                VStack(alignment: .leading) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("#\(order.id)")
                                                .foregroundColor(.text)
                                            
                                            Text(order.customer_name)
                                                .font(.headline)
                                                .foregroundColor(.text)
                                        }
                                        Spacer()
                                        Text(order.status.capitalized)
                                            .font(.caption)
                                            .padding(6)
                                            .background(tagColor(for: order.status))
                                            .foregroundColor(tagTextColor(for: order.status))
                                            .cornerRadius(6)
                                    }
                                    Text(order.createdAt)
                                        .font(.caption)
                                        .foregroundColor(.text)
                                }
                                .padding(10)
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                            }
                            .listRowBackground(Color.bg)
                            .listRowSeparator(.hidden)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.bg)
                }
            }
            .background(Color.bg)
            .navigationBarHidden(true)
            .onAppear { viewModel.loadOrders() }
            
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

struct HomePreview: PreviewProvider {
    static var previews: some View {
        Home(onLogout: {
            
        })
    }
}
