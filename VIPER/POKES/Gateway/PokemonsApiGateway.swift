//
//  PokemonsApiGateway.swift
//  VIPER
//
//  Created by Omar Hernandez on 17/02/22.
//

import Foundation

typealias PokemonCompletionHandler = (_ result: ApiResult<Pokemon.Response>) -> Void
typealias PokemonDetailCompletionHandler = (_ result: ApiResult<PokemonDetail.Response>) -> Void


protocol PokemonsApiGateway {
    func fetchPokemons(parameters: Pokemon.Request,
                   completion: @escaping PokemonCompletionHandler)
    func fetchPokemonDetail(parameters: PokemonDetail.Request,
                   completion: @escaping PokemonDetailCompletionHandler)
}
class PokemonsApiGatewayImplementation: PokemonsApiGateway {
    let apiClient: ApiClient
    
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    func fetchPokemons(parameters: Pokemon.Request,
                       completion: @escaping PokemonCompletionHandler) {
        let request = PokemonsApiRequest(parameters: parameters)
        apiClient.execute(request: request) { (result: ApiResult<ApiResponse<Pokemon.Response>>) in
            switch result {
            case let .success(response):
                let entity = response.entity
                completion(.success(entity!))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchPokemonDetail(parameters: PokemonDetail.Request,
                            completion: @escaping PokemonDetailCompletionHandler) {
        let request = PokemonDetailApiRequest(parameters: parameters)
        apiClient.execute(request: request) { (result: ApiResult<ApiResponse<PokemonDetail.Response>>) in
            switch result {
            case let .success(response):
                let entity = response.entity
                completion(.success(entity!))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
