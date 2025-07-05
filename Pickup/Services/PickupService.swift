//
//  PickupService.swift
//  Pickup
//
//  Created by Luis Enrique Perez Tapia on 04/07/25.
//

import Alamofire
import Foundation


class APIService {
    static let shared = APIService()
    private init() {}
    private let baseURL =  "http://192.168.50.100:3000/api"
    
    private var headers: HTTPHeaders {
        if let token = UserDefaults.standard.string(forKey: "token") {
            return ["Authorization": "Bearer \(token)"]
        }
        return [:]
    }
    
    func login(email: String, password: String, completion: @escaping (Result<UserDto, Error>) -> Void) {
            let params = ["email": email, "password": password]
            let url = "\(baseURL)/auth/login"
            
            print("url: \(url)")
            print("params: \(params)")
            
            AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default)
                .validate(statusCode: 200..<300) 
                .responseDecodable(of: UserDto.self) { response in
                    print(response)
                    
                    switch response.result {
                    case .success(let value):
                        completion(.success(value))
                        
                    case .failure(let error):
                        // Handle specific error cases
                        if let data = response.data,
                           let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
                            // Custom error from backend
                            completion(.failure(APIError.custom(message: apiError.error)))
                        } else if response.response?.statusCode == 401 {
                            // Unauthorized error
                            completion(.failure(APIError.custom(message: "Invalid credentials")))
                        } else {
                            // Other AF errors
                            completion(.failure(error))
                        }
                    }
                }
        }
    
    
    func fetchOrders(status: String? = nil,query: String? = nil,completion: @escaping (Result<[OrderDto], Error>) -> Void) {
        
        var urlComponents = URLComponents(string: "\(baseURL)/orders")!
        var queryItems: [URLQueryItem] = []
                
                // Add status filter if provided and not "todos"
        if let status = status, status != "todos" {
            queryItems.append(URLQueryItem(name: "status", value: status))
        }
                
                // Add search query if provided and not empty
        if let query = query, !query.isEmpty {
            queryItems.append(URLQueryItem(name: "query", value: query))
        }
                
        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }
                
        let url = urlComponents.url!.absoluteString
                
        
        print("url: \(url)")
        
        AF.request(url, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [OrderDto].self) { response in
                print(response)
                
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                    
                case .failure(let error):
                    // Handle specific error cases
                    if let data = response.data,
                       
                       let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
                        // Custom error from backend
                        completion(.failure(APIError.custom(message: apiError.error)))
                    } else if response.response?.statusCode == 401 {
                        // Unauthorized error
                        completion(.failure(APIError.custom(message: "Invalid credentials")))
                    } else {
                        // Other AF errors
                        print("mi error-------")
                        completion(.failure(error))
                    }
                }
            }
    }
    
    func fetchOrderByID(orderId: Int ,completion: @escaping (Result<OrderDto, Error>) -> Void) {
        
        var urlComponents = URLComponents(string: "\(baseURL)/orders/\(orderId)")!
        let url = urlComponents.url!.absoluteString
        
        print("url: \(url)")
        
        AF.request(url, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: OrderDto.self) { response in
                print(response)
                
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                    
                case .failure(let error):
                    // Handle specific error cases
                    if let data = response.data,
                       
                       let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
                        // Custom error from backend
                        completion(.failure(APIError.custom(message: apiError.error)))
                    } else if response.response?.statusCode == 401 {
                        // Unauthorized error
                        completion(.failure(APIError.custom(message: "Invalid credentials")))
                    } else {
                        // Other AF errors
                        print("mi error-------")
                        completion(.failure(error))
                    }
                }
            }
    }
    
    
    func sendSerialNumbers( payload: SerialNumberPayload , orderId: Int , completion: @escaping (Result<msg, Error>) -> Void) {
        print("------------------- envio codigos ---------------------")
        let url = "\(baseURL)/orders/serialnumber/\(orderId)"
        
        print(url)
        
        print(payload)
        
        AF.request(url, method: .patch, parameters: payload, encoder: JSONParameterEncoder.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: msg.self) { response in
                
                if let code = response.response?.statusCode, code == 304 {
                        print("⚠️ Nada fue modificado")
                    completion(.failure(APIError.custom(message: "No se actualizó número de serie")))
                        return
                    }
                    
                
                switch response.result {
                case .success(let value):
                    
                    completion(.success(value))
                    
                case .failure(let error):
                    // Handle specific error cases
                    print("error: \(error)")
                    
                    if let data = response.data {
                            let rawResponse = String(data: data, encoding: .utf8) ?? "No readable data"
                            print("📦 Raw server response: \(rawResponse)")
                        }
                    
                    if let data = response.data,  let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
                        // Custom error from backend
                        completion(.failure(APIError.custom(message: apiError.error)))
                        
                    }else if response.response?.statusCode == 401 {
                        // Unauthorized error
                        completion(.failure(APIError.custom(message: "Invalid credentials")))
                    } else {
                        // Other AF errors
                        print("mi error-------")
                        print(error)
                        completion(.failure(error))
                    }
                }
            }
    }
    
    
    
    func updateOrderStatus(orderId: Int , status : String ,completion: @escaping (Result<OrderDto, Error>) -> Void) {
        
        let params = ["status": status ]
        
        let urlComponents = URLComponents(string: "\(baseURL)/orders/\(orderId)/status")!
        let url = urlComponents.url!.absoluteString
        
        print("url: \(url)")
        
        AF.request(url,method: .patch, parameters : params, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: OrderDto.self) { response in
                print(response)
                
                switch response.result {
                case .success(let value):
                    
                    completion(.success(value))
                    
                case .failure(let error):
                    // Handle specific error cases
                    if let data = response.data,
                       
                       let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
                        // Custom error from backend
                        completion(.failure(APIError.custom(message: apiError.error)))
                    } else if response.response?.statusCode == 401 {
                        // Unauthorized error
                        completion(.failure(APIError.custom(message: "Invalid credentials")))
                    } else {
                        // Other AF errors
                        print("mi error-------")
                        completion(.failure(error))
                    }
                }
            }
    }
    
}


struct APIError: Decodable, Error {
    let error: String
}

struct msg: Decodable {
    let msg: String
}

extension APIError {
    static func custom(message: String) -> APIError {
        return APIError(error: message)
    }
}
