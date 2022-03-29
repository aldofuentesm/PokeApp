//
//  PokemonUseCase.swift
//  VIPER
//
//  Created by Omar Hernandez on 17/02/22.
//

import Foundation
typealias getPokemonModelCompletionHandler = (_ result: ApiResult<PokemonsDTO>) -> Void
typealias getPokemonDetailModelCompletionHandler = (_ result: ApiResult<PokemonDetailDTO>) -> Void

protocol PokemonUseCase {
    var interactor: PokemonUseCaseOut? { get set }
    func fetchPokemons(parameters: Pokemon.Request)
    func fetchPokemonDetail(parameters: PokemonDetail.Request)
}

protocol PokemonUseCaseOut: AnyObject {
    func fetchPokemonsResponse(result: ApiResult<PokemonsDTO>)
    func fetchPokemonDetailResponse(result: ApiResult<PokemonDetailDTO>)
}

extension PokemonUseCaseOut {
    func fetchPokemonsResponse(result: ApiResult<PokemonsDTO>) {}
    func fetchPokemonDetailResponse(result: ApiResult<PokemonDetailDTO>) {}
}

class PokemonUseCaseImplementation: PokemonUseCase {
    let apiGateway: PokemonsApiGateway
    weak var interactor: PokemonUseCaseOut?
    
    init(apiGateway: PokemonsApiGateway) {
        self.apiGateway = apiGateway
    }
    
    func fetchPokemons(parameters: Pokemon.Request) {
        apiGateway.fetchPokemons(parameters: parameters) { [weak self] (result) in
            switch result {
            case let .success(response):
                let dto = PokemonsDTO(response: response)
                self?.interactor?.fetchPokemonsResponse(result: .success(dto))
            case let .failure(error):
                self?.interactor?.fetchPokemonsResponse(result: .failure(error))
            }
        }
    }
    
    func fetchPokemonDetail(parameters: PokemonDetail.Request) {
        apiGateway.fetchPokemonDetail(parameters: parameters) { [weak self] (result) in
            switch result {
            case let .success(response):
                let dto = PokemonDetailDTO(entity: response)
                self?.interactor?.fetchPokemonDetailResponse(result: .success(dto))
            case let .failure(error):
                self?.interactor?.fetchPokemonDetailResponse(result: .failure(error))
            }
        }
    }
}
