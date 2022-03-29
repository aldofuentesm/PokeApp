//
//  PokemonCell.swift
//  VIPER
//
//  Created by Omar Hernandez on 17/02/22.
//

import UIKit

class PokemonCell: UITableViewCell {

    @IBOutlet private weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
        
    func configure(viewModel: PokemonViewModel) {
        lblName.text = viewModel.name
    }
}
