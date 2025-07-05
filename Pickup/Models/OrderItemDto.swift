//
//  OrderDetailDto.swift
//  Pickup
//
//  Created by Luis Enrique Perez Tapia on 04/07/25.
//

import Foundation

struct OrderItemDto : Codable, Identifiable {
    var id: Int { orderDetaiId }
    var orderDetaiId : Int
    var orderId : Int
    var ean : String
    var productDescription : String
    var quantity : Int
    var unitPrice : String
    var subtotal : String
    var image : String
    var serialNumbers : [serialNumbersDto]
}


struct serialNumbersDto: Codable , Identifiable {
    var numSerie: String
    var id: Int
    var orderDetaiId: Int
}


struct SerialNumberPayload: Codable {
    var ean: String
    var serialNumbers: [serialNumbersDto]
}
