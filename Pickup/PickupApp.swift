//
//  PickupApp.swift
//  Pickup
//
//  Created by Luis Enrique Perez Tapia on 27/06/25.
//

import SwiftUI

@main
struct PickupApp: App {
    
    @State private var isLoggedIn: Bool = UserDefaultsManager.isLoggedIn()
    
    

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                        Home(onLogout: {
                            isLoggedIn = false
                        })
                    } else {
                        Login(onLogin: {
                                        isLoggedIn = true
                                    })
                    }
            
        }
    }
}
