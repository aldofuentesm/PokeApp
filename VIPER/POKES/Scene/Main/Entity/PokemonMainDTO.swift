//
//  PokemonMainDTO.swift
//  VIPER
//
//  Created by Omar Hernandez on 17/02/22.
//

import Foundation

struct PokemonsDTO {
    let pokemons: [PokemonDTO]
    init(response: Pokemon.Response) {
        pokemons = response.results.map({ poke in
            return PokemonDTO(name: poke.name, url: poke.url)
        })
    }
}

struct PokemonDTO: Equatable {
    let name: String
    let url: String
}


