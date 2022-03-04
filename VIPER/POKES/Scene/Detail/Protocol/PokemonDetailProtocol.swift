//
//  PokemonDetailProtocol.swift
//  VIPER
//
//  Created by Omar Hernandez on 24/02/22.
//

// MARK: - Presenter -> View
protocol PokemonDetailView: AnyObject {
    func configure(presenter: PokemonDetailPresenter)
    func configure(name: String)
    func configureView(pokemonDetail: PokemonDetailDTO)
}

// MARK: - View -> Presnrer
protocol PokemonDetailPresenter: AnyObject {
    func configure(view: PokemonDetailView, router: PokemonDetailRouter, interactor: PokemonDetailInteractor)
    var pokemon: PokemonDTO? { get set }
    func viewDidLoad()
}

// MARK: - Presenter -> Router
protocol PokemonDetailRouter: AnyObject {
}

// MARK: Presenter -> Interactor
protocol PokemonDetailInteractor: AnyObject {
   func fetchPokemonDetail(name: String)
}

// MARK: - Interactor -> Presenter
protocol PokemonDetailInteractorOut: AnyObject {
    func fetchPokemonSuccess(pokemon: PokemonDetailDTO)
    func failure(message: String)
}

