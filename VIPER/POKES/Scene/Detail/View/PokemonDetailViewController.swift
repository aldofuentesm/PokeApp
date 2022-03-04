//  
//  PokemonDetailViewController.swift
//  VIPER
//
//  Created by Omar Hernandez on 17/02/22.
//

import UIKit

protocol PokemonDetailViewResponder {
    func viewDidLoad()
}

final class PokemonDetailViewController: UIViewController {
    ///////////////////////////////////////
    // MARK: Outlets
    ///////////////////////////////////////
    @IBOutlet weak private var imgPokemon: UIImageView!
    @IBOutlet weak private var lblType: UILabel!
    @IBOutlet weak private var lblMoves: UILabel!
    
    ///////////////////////////////////////
    // MARK: Properties
    ///////////////////////////////////////
    private var presenter: PokemonDetailPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    func configure(presenter: PokemonDetailPresenter) {
        self.presenter = presenter
    }
    
    deinit {
        debugPrint(String(describing: self), "deinit")
    }
}

extension PokemonDetailViewController: PokemonDetailView {
    func configure(name: String) {
        title = name
    }
    
    func configureView(pokemonDetail: PokemonDetailDTO) {
        imgPokemon.downloaded(from: pokemonDetail.urlImage)
        lblType.text = pokemonDetail.type.joined(separator: ", ")
        lblMoves.text = pokemonDetail.moves.joined(separator: ", ")
    }
}
