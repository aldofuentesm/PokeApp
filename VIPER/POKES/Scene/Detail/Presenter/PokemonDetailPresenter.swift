//  
//  PokemonDetailPresenter.swift
//  VIPER
//
//  Created by Omar Hernandez on 17/02/22.
//

import UIKit

final class PokemonDetailPresenterImplementation: PokemonDetailPresenter {
    
    fileprivate weak var view: PokemonDetailView?
    fileprivate var router: PokemonDetailRouter?
    fileprivate var interactor: PokemonDetailInteractor?

    var pokemon: PokemonDTO?
    var pokemonDetail: PokemonDetailDTO?
    
    func configure(view: PokemonDetailView, router: PokemonDetailRouter, interactor: PokemonDetailInteractor) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    deinit {
        debugPrint(String(describing: self), "deinit")
    }
}

extension PokemonDetailPresenterImplementation {
    func viewDidLoad() {
        guard let name = pokemon?.name else { return }
        interactor?.fetchPokemonDetail(name: name)
        view?.configure(name: name)
    }
}

extension PokemonDetailPresenterImplementation: PokemonDetailInteractorOut {
    func fetchPokemonSuccess(pokemon: PokemonDetailDTO) {
        view?.configureView(pokemonDetail: pokemon)
    }
    
    func failure(message: String) {
        print(message)
    }
}
