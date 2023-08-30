//
//  NetworkManager.swift
//  Natife Post App
//
//  Created by Ivan Behichev on 30.08.2023.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private let url = URL(string: "https://raw.githubusercontent.com/anton-natife/jsons/master/api/main.json")
    
    func getPosts<T: Codable>(complition: @escaping (T?) -> Void) {
        
        guard let safeURL = url else {
            print("Bad url")
            return 
        }
        
        let session = URLSession(configuration: .default)
        let request = URLRequest(url: safeURL)
        
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Client error")
                return
            }
            
            guard let data = data else {
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedData = try decoder.decode(T.self, from: data)
                complition(decodedData)
            } catch {
                print(error)
                complition(nil)
            }
        }.resume()
    }
}
