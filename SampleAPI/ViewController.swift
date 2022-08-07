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

    private var dataArray: [Pokemon] = []
    private var jaNameDataArray: [PokemonJaName] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableViewCell()
        fetchData()
        fetchJaNameData()
    }

    private func setUpTableViewCell() {
        pokemonListTableView.delegate = self
        pokemonListTableView.dataSource = self
        pokemonListTableView.register(PokemonListTableViewCell.nib, forCellReuseIdentifier: PokemonListTableViewCell.identifier)
    }

    private func fetchData() {
        FetchAPIs.decodePokemonData { [self] in
            dataArray = $0
            DispatchQueue.main.async { [self] in
                self.pokemonListTableView.reloadData()
            }
        }
    }

    private func fetchJaNameData() {
        FetchAPIs.decodePokemonNameData { [self] in
            jaNameDataArray = $0
            DispatchQueue.main.async { [self] in
                pokemonListTableView.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        jaNameDataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = pokemonListTableView.dequeueReusableCell(withIdentifier: PokemonListTableViewCell.identifier, for: indexPath) as! PokemonListTableViewCell

        cell.configure(imageURL: URL(string: dataArray[indexPath.row].sprites.frontImage)!, id: "\(dataArray[indexPath.row].id)", enName: dataArray[indexPath.row].name, jaName: jaNameDataArray[indexPath.row].names[0].name)

        return cell
    }
}
