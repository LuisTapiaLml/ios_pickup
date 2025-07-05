//
//  UserDto.swift
//  Pickup
//
//  Created by Luis Enrique Perez Tapia on 04/07/25.
//

import Foundation


struct UserDto: Codable {
    let id: Int
    let name: String
    let email: String
    let createdAt: String
    let token : String
}


