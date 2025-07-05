//
//  SerialNumberViewModel.swift
//  Pickup
//
//  Created by Luis Enrique Perez Tapia on 04/07/25.
//

import Foundation

class SerialNumberViewModel: ObservableObject {
    @Published var scannedCodes : [serialNumbersDto] = []
    @Published var errorMessage = ""
    @Published var showAlert = false
    

    init(codes: [serialNumbersDto]) {
        
        for code in codes {
            self.scannedCodes.append(
                serialNumbersDto(
                    numSerie: code.numSerie,
                    id: code.id,
                    orderDetaiId: code.orderDetaiId
                )
            )
        }
    }
    
    func confirm( ean: String, orderId: Int) {
        
        let payload = SerialNumberPayload( ean: ean, serialNumbers: scannedCodes)
        
        print("************************ PAYLOAD *************************************")
        print("payload: \(payload)")
        
        APIService.shared.sendSerialNumbers(payload: payload ,orderId: orderId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let msg):
                    self?.errorMessage = msg.msg
                case .failure(let err):
                    if let apiError = err as? APIError {
                        self?.errorMessage = apiError.error
                    } else {
                        self?.errorMessage = err.localizedDescription
                    }
                }
                self?.showAlert = true
            }
        }
    }
}
