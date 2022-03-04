//
//  PokemonDetailInteractor.swift
//  VIPER
//
//  Created by Omar Hernandez on 24/02/22.
//

import Foundation
final class PokemonDetailInteractorImplementation: PokemonDetailInteractor {
    private var pokemonUseCase: PokemonUseCase?
    private weak var presenter: PokemonDetailInteractorOut?
    
    init() {
        // ApiClient
        let apiClient = ApiClientImplementation()
        // Gateway
        let apiGateway = PokemonsApiGatewayImplementation(apiClient: apiClient)
        // UseCase
        pokemonUseCase = PokemonUseCaseImplementation(apiGateway: apiGateway)
    }
    
    func configure(presenter: PokemonDetailInteractorOut?) {
        self.presenter = presenter
        pokemonUseCase?.interactor = self
    }
    
    func fetchPokemonDetail(name: String) {
        let request = PokemonDetail.Request(name: name)
        pokemonUseCase?.fetchPokemonDetail(parameters: request)
    }
    deinit {
        debugPrint(String(describing: self), "deinit")
    }
}

extension PokemonDetailInteractorImplementation: PokemonUseCaseOut {
    func fetchPokemonDetailResponse(result: ApiResult<PokemonDetailDTO>) {
        switch result {
        case let .success(response):
            presenter?.fetchPokemonSuccess(pokemon: response)
        case let .failure(error):
            presenter?.failure(message: error.localizedDescription)
        }
    }
}
