//
//  PokemonMainDTO.swift
//  VIPER
//
//  Created by Omar Hernandez on 17/02/22.
//

import Foundation

struct pokemonsDTO {
    let Pokemons: [PokemonDTO]
    init(entity: Pokemon.Response) {
        Pokemons = entity.results.map({ poke in
            return PokemonDTO(name: poke.name, url: poke.url)
        })
    }
}

struct PokemonDTO {
    let name: String
    let url: String
}
