//
//  PokemonMainInteractor.swift
//  VIPER
//
//  Created by Omar Hernandez on 18/02/22.
//

import UIKit
import Combine

final class PokemonMainInteractorImplementation: PokeMainInteractor {
    private var pokemonUseCase: PokemonUseCase
    private var presenter: PokeMainInteractorOut?
    init(pokemonUseCase: PokemonUseCase) {
        self.pokemonUseCase = pokemonUseCase
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
    
    func fetchPokemonImage(url: String) -> AnyPublisher<UIImage?, Never> {
        return Empty().eraseToAnyPublisher()
    }
}

extension PokemonMainInteractorImplementation: PokemonUseCaseOut {
    func fetchPokemonsResponse(result: ApiResult<PokemonsDTO>) {
        switch result {
        case let .success(response):
            presenter?.fetchPokemonsSuccess(pokemons: response.pokemons)
        case let .failure(error):
            presenter?.failure(error: error.message ?? "error")
        }
    }
    
}
