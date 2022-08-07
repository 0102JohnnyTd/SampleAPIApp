//
//  ViewController.swift
//  SampleAPI
//
//  Created by Johnny Toda on 2022/08/02.
//

import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var pokemonListTableView: UITableView!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableViewCell()
    }

    private func setUpTableViewCell() {
        pokemonListTableView.delegate = self
        pokemonListTableView.dataSource = self
        pokemonListTableView.register(PokemonListTableViewCell.nib, forCellReuseIdentifier: PokemonListTableViewCell.identifier)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        493
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        pokemonListTableView.dequeueReusableCell(withIdentifier: PokemonListTableViewCell.identifier, for: indexPath) as! PokemonListTableViewCell
    }
}
