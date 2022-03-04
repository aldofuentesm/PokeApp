//  
//  PokeMainPresenter.swift
//  VIPER
//
//  Created by Omar Hernandez on 16/02/22.
//

import UIKit

final class PokeMainPresenterImplementation: PokeMainPresenter {
    fileprivate let view: PokeMainView
    fileprivate let router: PokeMainViewRouter
    fileprivate let interactor: PokeMainInteractor
    fileprivate var pokemons: [PokemonDTO]?
    
    init(view: PokeMainView, router: PokeMainViewRouter, interactor: PokeMainInteractor) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
}
extension PokeMainPresenterImplementation {
    func viewDidLoad() {
        interactor.fetchPokemons()
    }
    
    func didSelectRowAt(row: Int) {
        guard let pokemon = pokemons?[row] else { return }
        router.showPokemonDetail(pokemon: pokemon)
    }
}
extension PokeMainPresenterImplementation: PokeMainInteractorOut {
    func fetchPokemonsSuccess(pokemons: [PokemonDTO]) {
        self.pokemons = pokemons
        view.show(pokemons: pokemons)
    }
    
    func failure(message: String) {
    }
}
