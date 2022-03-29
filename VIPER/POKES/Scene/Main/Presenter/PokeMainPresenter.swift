//  
//  PokeMainPresenter.swift
//  VIPER
//
//  Created by Omar Hernandez on 16/02/22.
//

import UIKit
import Combine

class PokeMainPresenterImplementation {
    fileprivate let view: PokeMainView
    fileprivate let router: PokeMainViewRouter
    fileprivate let interactor: PokeMainInteractor
    fileprivate var pokemons: [PokemonDTO]?
    
    init(view: PokeMainView, router: PokeMainViewRouter, interactor: PokeMainInteractor) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    func observeNotifications() {
        
    }
    
    func fetchPokemons() {
        interactor.fetchPokemons()
    }
    
    func map(pokemon: PokemonDTO) -> PokemonViewModel {
        PokemonViewModel(
            name: pokemon.name,
            image: interactor.fetchPokemonImage(url: pokemon.url))
    }
}

extension PokeMainPresenterImplementation: PokeMainPresenter {
    func viewDidLoad() {
        fetchPokemons()
        observeNotifications()
        // Other functions
        // Fetch other endpoints
    }
    
    func didSelectRowAt(row: Int) {
        guard let pokemon = pokemons?[row] else { return }
        router.showPokemonDetail(pokemon: pokemon)
    }
}

extension PokeMainPresenterImplementation: PokeMainInteractorOut {
    func fetchPokemonsSuccess(pokemons: [PokemonDTO]) {
        self.pokemons = pokemons
        let viewModels = pokemons.map(map(pokemon:))
        view.show(pokemons: viewModels)
    }
    
    func failure(error: String) {
        view.showError(message: "Try later")
    }
}
