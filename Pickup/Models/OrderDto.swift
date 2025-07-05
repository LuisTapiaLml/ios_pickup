//
//  OrderDto.swift
//  Pickup
//
//  Created by Luis Enrique Perez Tapia on 04/07/25.
//

import Foundation


struct OrderDto: Codable , Identifiable {
    let id : Int
    let userId : Int
    let customer_name: String
    let orderDate : String
    let totalAmount : String
    let status : String
    let createdAt: String
    let updatedAt : String
    let phone : String
    let email: String
    //let user : UserDto
    let orderDetails: [OrderItemDto]
}


