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
        // ApiClient
        let apiClient = ApiClientImplementation()
        // Gateway
        let apiGateway = PokemonsApiGatewayImplementation(apiClient: apiClient)
        // UseCase
        let useCase = PokemonUseCaseImplementation(apiGateway: apiGateway)
        let interactor = PokemonMainInteractorImplementation(pokemonUseCase: useCase)
        let controller = PokeMainViewController()
        let presenter = PokeMainPresenterImplementation(view: controller,
                                                        router: self,
                                                        interactor: interactor)
        controller.configure(responder: presenter)
        interactor.configure(presenter: presenter)
        navigationController = UINavigationController(rootViewController: controller)
    }
    
    func showPokemonDetail(pokemon: PokemonDTO) {
        let router = PokemonDetailRouterImplementation(pokemon: pokemon)
        navigationController.pushViewController(router.controller, animated: true)
    }
    
    
}
