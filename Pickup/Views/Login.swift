//
//  Login.swift
//  Pickup
//
//  Created by Luis Enrique Perez Tapia on 04/07/25.
//

import Foundation
import SwiftUI


struct Login : View {
    
    @StateObject private var viewModel = LoginViewModel()
    @State private var isLoggedIn = false

    
    var body: some View {
        
        NavigationStack{
            VStack(spacing: 10) {
                    
                Spacer().frame(height: UIScreen.main.bounds.height * 0.1)
                Image("logo").resizable().scaledToFit().frame(height: 100)
                
                //user
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(Color.text)
                    TextField("", text:$viewModel.email,prompt: Text("Email").foregroundColor(Color.text))
                        .keyboardType(.emailAddress).autocapitalization(.none)
                        .foregroundColor(Color.text)
                        
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                
                
                //password
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(Color.text)
                    SecureField("", text:$viewModel.password,prompt: Text("Password").foregroundColor(Color.text))
                        .foregroundColor(.text)
                        
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                
                
                //button
                Button("Login"){
                    print("Se envia login")
                    viewModel.login(onSuccess: {
                        print("se logeo bien --------------------")
                        isLoggedIn = true
                    })
                }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                
                Spacer()
                
            }.padding()
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(
                        title: Text(viewModel.alertTitle),
                        message: Text(viewModel.alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .navigationBarHidden(true)
                .background(Color.bg.ignoresSafeArea(edges: .all))
                .navigationDestination(isPresented: $isLoggedIn) {
                    Home()
                }
        }
        
    }
    
    
}



struct LoginPreview: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
