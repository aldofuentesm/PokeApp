//  
//  PokemonDetailViewRouter.swift
//  VIPER
//
//  Created by Omar Hernandez on 17/02/22.
//

import UIKit

final class PokemonDetailRouterImplementation: PokemonDetailRouter {
    var controller: PokemonDetailViewController
    
    init(pokemon: PokemonDTO) {
        controller = PokemonDetailViewController()
        let presenter = PokemonDetailPresenterImplementation()
        let interactor = PokemonDetailInteractorImplementation()
        presenter.configure(view: controller, router: self, interactor: interactor)
        controller.configure(presenter: presenter)
        interactor.configure(presenter: presenter)
        presenter.pokemon = pokemon
    }
    
    deinit {
        debugPrint(String(describing: self), "deinit")
    }
    

}
