//
//  NetworkService.swift
//  TimeCapsule
//
//  Created by Beomcheol Kwon on 2021/03/12.
//


import Foundation
import Alamofire

enum APIError: Error {
    case response
}

struct NetworkService {
    static func getData<T: Codable>(type: URLType, headers: HTTPHeaders?, parameters: [String: String]?, completion: @escaping (Result<T,APIError>) -> Void) {
        AF.request(type.makeURL, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .responseDecodable(of: T.self) { response in
                guard let target = response.value else {
                    return completion(.failure(.response))
                }
                completion(.success(target))
            }
    }
    
    static func getQueryData<T: Codable>(type: URLType, headers: HTTPHeaders?, parameters: [String: String]?, completion: @escaping (Result<T,APIError>) -> Void) {
        AF.request(type.makeURL, parameters: parameters, encoder: URLEncodedFormParameterEncoder(destination: .queryString), headers: headers)
            .responseDecodable(of: T.self) { response in
                guard let target = response.value else {
                    return completion(.failure(.response))
                }
                completion(.success(target))
            }
    }
    
    static func postData<T: Codable>(type: URLType, headers: HTTPHeaders?, parameters: [String: String]?, completion: @escaping (Result<T,APIError>) -> Void) {
        AF.request(type.makeURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .responseDecodable(of: T.self, decoder: JSONDecoder()) { response in
                print(response)
                guard let target = response.value else {
                    return completion(.failure(.response))
                }
                completion(.success(target))
            }
    }
}



