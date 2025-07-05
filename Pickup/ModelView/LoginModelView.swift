//
//  LoginModelView.swift
//  Pickup
//
//  Created by Luis Enrique Perez Tapia on 04/07/25.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var alertTitle = ""
    
    
    func login(onSuccess: (() -> Void)?) {
        
        if(email.isEmpty || password.isEmpty){
            alertMessage = "Debes completar todos los campos."
            alertTitle = "Error"
            showAlert = true
            return
        }
        
        APIService.shared.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    
                        UserDefaults.standard.set(user.token, forKey: "token")
                        UserDefaults.standard.set(user.name, forKey: "username")
                        UserDefaults.standard.set(user.id, forKey: "id")
                    
                        onSuccess?()
                    
                case .failure(let error):
                                    // Handle error
                                    if let apiError = error as? APIError {
                                        self?.alertTitle = "Error"
                                        self?.alertMessage = apiError.error
                                    } else {
                                        self?.alertTitle = "Error"
                                        self?.alertMessage = error.localizedDescription
                                    }
                                    self?.showAlert = true
                }
            }
        }
    }
}
