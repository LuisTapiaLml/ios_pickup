//
//  defaultManager.swift
//  Pickup
//
//  Created by Luis Enrique Perez Tapia on 04/07/25.
//

import Foundation

struct UserDefaultsManager {
    
    private static let  tokenKey = "token"
    private static let usernameKey = "username"
    
    static func clearUserData() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
        UserDefaults.standard.removeObject(forKey: usernameKey)
    }
    
    static func getToken() -> String? {
            UserDefaults.standard.string(forKey: tokenKey)
        }

        static func getUsername() -> String {
            UserDefaults.standard.string(forKey: usernameKey) ?? "Usuario"
        }

        static func isLoggedIn() -> Bool {
            getToken() != nil
        }

    
}
