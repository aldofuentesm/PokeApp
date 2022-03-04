//
//  PokemonDetailDTO.swift
//  VIPER
//
//  Created by Omar Hernandez on 18/02/22.
//

import Foundation

class PokemonDetailDTO {
    let name: String
    let urlImage: String
    let type: [String]
    let moves: [String]
    init(entity: PokemonDetail.Response) {
        self.name = entity.name
        self.urlImage = entity.sprites.other?.officialArtwork.frontDefault ?? entity.sprites.frontDefault
        self.type = entity.types.map({ type in
            return type.type.name
        })
        self.moves = entity.moves.map({ move in
            return move.move.name
        })
    }
}
