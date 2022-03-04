//
//  PokemonMainProtocol.swift
//  VIPER
//
//  Created by Omar Hernandez on 18/02/22.
//

// MARK: - Presenter -> View
protocol PokeMainView {
    func show(pokemons: [PokemonDTO])
}

// MARK: - View -> Presnrer
protocol PokeMainPresenter {
    func viewDidLoad()
    func didSelectRowAt(row: Int)
}

// MARK: - Presenter -> Router
protocol PokeMainViewRouter {
    func showPokemonDetail(pokemon: PokemonDTO)
}

// MARK: Presenter -> Interactor
protocol PokeMainInteractor {
    func fetchPokemons()
}

// MARK: - Interactor -> Presenter
protocol PokeMainInteractorOut {
    func fetchPokemonsSuccess(pokemons: [PokemonDTO])
    func failure(message: String)
}
