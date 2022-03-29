//
//  PokemonViewModel.swift
//  VIPER
//
//  Created by Aldo Fuentes on 04/03/22.
//

import UIKit
import Combine

struct PokemonViewModel: Equatable {
    let name: String
    let image: AnyPublisher<UIImage?, Never>
    
    static func == (lhs: PokemonViewModel, rhs: PokemonViewModel) -> Bool {
        lhs.name == rhs.name
    }
}
