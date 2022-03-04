//
//  PokemonMainInteractor.swift
//  VIPER
//
//  Created by Omar Hernandez on 18/02/22.
//

final class PokemonMainInteractorImplementation: PokeMainInteractor {
    private var pokemonUseCase: PokemonUseCase
    private var presenter: PokeMainInteractorOut?
    init() {
        // ApiClient
        let apiClient = ApiClientImplementation()
        // Gateway
        let apiGateway = PokemonsApiGatewayImplementation(apiClient: apiClient)
        // UseCase
        pokemonUseCase = PokemonUseCaseImplementation(apiGateway: apiGateway)
    }
    
    func configure(presenter: PokeMainInteractorOut) {
        self.presenter = presenter
        pokemonUseCase.interactor = self
    }
}

extension PokemonMainInteractorImplementation {
    func fetchPokemons() {
        pokemonUseCase.fetchPokemons(parameters: Pokemon.Request(limit: "100", offset: "200"))
    }
}

extension PokemonMainInteractorImplementation: PokemonUseCaseOut {
    func fetchPokemonsResponse(result: ApiResult<pokemonsDTO>) {
        switch result {
        case let .success(response):
            presenter?.fetchPokemonsSuccess(pokemons: response.Pokemons)
        case let .failure(error):
            presenter?.failure(message: error.message ?? "error")
        }
    }
    
}
