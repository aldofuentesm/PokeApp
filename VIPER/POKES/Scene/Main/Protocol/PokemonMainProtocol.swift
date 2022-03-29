//
//  PokemonMainProtocol.swift
//  VIPER
//
//  Created by Omar Hernandez on 18/02/22.
//

import Combine
import UIKit

// MARK: - Presenter -> View INPUT
protocol PokeMainView {
    func show(pokemons: [PokemonViewModel])
    func showError(message: String)
}

// MARK: - View -> Presenter OUTPUT 
protocol PokeMainPresenter {
    func viewDidLoad()
    func didSelectRowAt(row: Int)
}

// MARK: Presenter -> Interactor INPUT
protocol PokeMainInteractor {
    func fetchPokemons()
    func fetchPokemonImage(url: String) -> AnyPublisher<UIImage?, Never>
}

// MARK: - Interactor -> Presenter OUTPUT
protocol PokeMainInteractorOut {
    func fetchPokemonsSuccess(pokemons: [PokemonDTO])
    func failure(error: String)
}

// MARK: - Presenter -> Router
protocol PokeMainViewRouter {
    func showPokemonDetail(pokemon: PokemonDTO)
}
