//
//  VIPERTests.swift
//  VIPERTests
//
//  Created by Aldo Fuentes on 04/03/22.
//

import XCTest
import Combine
@testable import VIPER

class PokeMainPresenterTests: XCTestCase {
    
    func test_viewDidLoad_coordination() {
        //Arrange
        let sut = makeSUT()
        let presenter = sut.presenter
        
        // Act
        presenter.viewDidLoad()
        
        //Assert
        //1. Fetch pokemons
        //2. Fetch other API
        //3. Observe notifications
        //4. Setup view initial data
        //5. Setup view loading

        XCTAssertEqual(presenter.messages, [.fetchData, .observeNotifications, .setupView])
    }
    
    func test_interactorError_showError() {
        //Arrange
        let sut = makeSUT()
        let presenter = sut.presenter
        let view = sut.view
        
        // Act
        presenter.failure(error: "Error")
        
        // Assert
        XCTAssertEqual(view.messages, [.showError("Try later")])
    }
    
    func test_interactorSuccess_showPokemons() {
        
    }
    
    func test_didSelectRow_routeToDetail() {
        //Arrange
        let sut = makeSUT()
        let presenter = sut.presenter
        let router = sut.router
        let pokemons = testPokemons()
        let selectedIndex = 0
        let expectedPokemon = pokemons[selectedIndex]
        
        presenter.fetchPokemonsSuccess(pokemons: pokemons)
        
        // Act
        presenter.didSelectRowAt(row: 1)
        
        // Assert
        XCTAssertEqual(router.messages, [.showPokemonDetail(expectedPokemon)])
    }
    
    // MARK: - Helpers
    func makeSUT() -> (presenter: PokeMainPresenterSpy, view: PokeMainViewSpy, router: PokeMainViewRouterSpy, interactor: PokeMainInteractorSpy) {
        let view = PokeMainViewSpy()
        let interactor = PokeMainInteractorSpy()
        let router = PokeMainViewRouterSpy()
        let presenter = PokeMainPresenterSpy(view: view, router: router, interactor: interactor)
        return (presenter, view, router, interactor)
    }
    
    func testPokemons() -> [PokemonDTO] {
        [
            PokemonDTO(name: "1", url: ""),
            PokemonDTO(name: "2", url: "")
        ]
    }
    
    class PokeMainViewSpy: PokeMainView {
        enum Messages: Equatable {
            case showTitle(String)
            case showLoading
            case showPokemons([PokemonViewModel])
            case showError(String)
        }
        private(set) var messages: [Messages] = []
        
        func show(title: String) {
            messages.append(.showTitle(title))
        }
        func showLoading() {
            messages.append(.showLoading)
        }
        func show(pokemons: [PokemonViewModel]) {
            messages.append(.showPokemons(pokemons))
        }
        func showError(message: String) {
            messages.append(.showError(message))
        }
    }
    
    class PokeMainInteractorSpy: PokeMainInteractor {
        enum Messages: Equatable {
            case fetchPokemons
            case fetchPokemonImage(String)
            case fetchOtherAPI
            case observeNotifications
        }
        private(set) var messages: [Messages] = []
        
        func fetchPokemons() {
            messages.append(.fetchPokemons)
        }
        
        func observeNotifications(handler: @escaping () -> ()) {
            messages.append(.observeNotifications)
        }
        
        func fetchOtherAPI() {
            messages.append(.fetchOtherAPI)
        }
        
        func fetchPokemonImage(url: String) -> AnyPublisher<UIImage?, Never> {
            messages.append(.fetchPokemonImage(url))
            return Empty().eraseToAnyPublisher()
        }
    }
    
    class PokeMainViewRouterSpy: PokeMainViewRouter {
        enum Messages: Equatable {
            case showPokemonDetail(PokemonDTO)
        }
        private(set) var messages: [Messages] = []
        
        func showPokemonDetail(pokemon: PokemonDTO) {
            messages.append(.showPokemonDetail(pokemon))
        }
    }
    
    class PokeMainPresenterSpy: PokeMainPresenterImplementation {
        enum Messages: Equatable {
            case fetchData
            case fetchPokemons
            case observeNotifications
            case setupView
        }
        private(set) var messages: [Messages] = []
        
        override func observeNotifications() {
            messages.append(.observeNotifications)
            super.observeNotifications()
        }
        
        func fetchData() {
            messages.append(.fetchData)
        }
        
        func setupView() {
            messages.append(.setupView)
        }
    }
}
