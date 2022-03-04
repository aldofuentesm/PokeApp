//
//  PokemonDetailApiRequest.swift
//  VIPER
//
//  Created by Omar Hernandez on 18/02/22.
//

import Foundation

struct PokemonDetailApiRequest: ApiRequest {
    let parameters: PokemonDetail.Request
    let strURL: String = "https://pokeapi.co/api/v2/pokemon/%@"
    
    var urlRequest: URLRequest? {
        let urlString = String(format: strURL, parameters.name)
        guard let url = URL(string: urlString) else { return nil }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = URLRequest.baseHeaders
        request.httpMethod = HttpMethod.GET
        return request
    }
    
    init(parameters: PokemonDetail.Request) {
        self.parameters = parameters
    }
}
