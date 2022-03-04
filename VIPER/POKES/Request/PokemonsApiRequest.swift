//
//  PokemonsApiRequest.swift
//  VIPER
//
//  Created by Omar Hernandez on 16/02/22.
//
import Foundation

struct PokemonsApiRequest: ApiRequest {
    let parameters: Pokemon.Request
    let strURL: String = "https://pokeapi.co/api/v2/pokemon?limit=%@&offset=%@"
    
    var urlRequest: URLRequest? {
        let urlString = String(format: strURL, parameters.limit, parameters.offset)
        guard let url = URL(string: urlString) else { return nil }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = URLRequest.baseHeaders
        request.httpMethod = HttpMethod.GET
        return request
    }
    
    init(parameters: Pokemon.Request) {
        self.parameters = parameters
    }
}
