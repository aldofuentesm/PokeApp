//
//  PokemonAbilityEntity.swift
//  VIPER
//
//  Created by Omar Hernandez on 16/02/22.
//

import Foundation

enum Pokemon {
    // MARK: - Request
    struct Request: Encodable {
        let limit: String
        let offset: String
    }
    
    // MARK: - Response
    struct Response: Decodable, InitializableWithData {
        let count: Int
        let next, previous: String
        let results: [Result]
        
        init(data: Data?) throws {
            guard let data = data else { throw NSError.createParseError() }
            self = try Pokemon.Response.decode(data: data)
        }
    }

    // MARK: - Result
    struct Result: Codable {
        let name: String
        let url: String
    }
}
