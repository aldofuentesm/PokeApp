//  
//  PokeMainViewController.swift
//  VIPER
//
//  Created by Omar Hernandez on 16/02/22.
//

import UIKit
final class PokeMainViewController: UIViewController {
    ///////////////////////////////////////
    // MARK: Outlets
    ///////////////////////////////////////
    @IBOutlet weak var tableview: UITableView!
    
    ///////////////////////////////////////
    // MARK: Properties
    ///////////////////////////////////////
    private var presenter: PokeMainPresenter!
    private var cellReuseIdentifier = "PokemonCell"
    private var pokemons: [PokemonDTO]?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        presenter.viewDidLoad()
    }
    
    func configure(presenter: PokeMainPresenter) {
        self.presenter = presenter
    }
    
    private func configureTable() {
        let nibCell = UINib(nibName: cellReuseIdentifier, bundle: nil)
        tableview.register(nibCell, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
}
extension PokeMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let dataForRow = pokemons?[indexPath.row].name,
               let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier,
                                                        for: indexPath) as? PokemonCell else {
                   return UITableViewCell()
               }
        cell.configure(name: dataForRow)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRowAt(row: indexPath.row)
    }
}

extension PokeMainViewController: PokeMainView {
    func show(pokemons: [PokemonDTO]) {
        self.pokemons = pokemons
        tableview.reloadData()
    }
}
