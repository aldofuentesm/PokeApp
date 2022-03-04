//  
//  PokeMainViewRouter.swift
//  VIPER
//
//  Created by Omar Hernandez on 16/02/22.
//

import UIKit

final class PokeMainViewRouterImplementation: PokeMainViewRouter {
    var navigationController: UINavigationController!
    
    init() {
        let controller = PokeMainViewController()
        let interactor = PokemonMainInteractorImplementation()
        let presenter = PokeMainPresenterImplementation(view: controller,
                                                        router: self,
                                                        interactor: interactor)
        controller.configure(presenter: presenter)
        interactor.configure(presenter: presenter)
        navigationController = UINavigationController(rootViewController: controller)
    }
    
    func showPokemonDetail(pokemon: PokemonDTO) {
        let router = PokemonDetailRouterImplementation(pokemon: pokemon)
        navigationController.pushViewController(router.controller, animated: true)
    }
    
    
}
