//
//  ViewController.swift
//  SampleAPI
//
//  Created by Johnny Toda on 2022/08/02.
//

import UIKit
import RealmSwift

final class ViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!

    @IBOutlet private weak var segmentedControl: UISegmentedControl!

    @IBOutlet private weak var pokemonListTableView: UITableView!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!

    @IBAction private func segmentedControl(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            fileteredJaNameDataArray = nameDataArrayManager
            pokemonListTableView.reloadData()
        case 1:
            nameDataArrayManager = fileteredJaNameDataArray
            fileteredJaNameDataArray = favoriteJaNameDataArray
            pokemonListTableView.reloadData()
        default: break
        }
    }

    private var dataArray: [Pokemon] = []
    private var jaNameDataArray: [PokemonJaName] = []
    private var fileteredJaNameDataArray: [PokemonJaName] = []
    private var nameDataArrayManager: [PokemonJaName] = []
    private var favoriteJaNameDataArray: [PokemonJaName] = []

    private var isFavorite = false
    private let realm = try! Realm()


    override func viewDidLoad() {
        super.viewDidLoad()
        startIndicator()
        setUpTableViewCell()
        setUpSearchBar()
        fetchData()
    }

    private func setUpTableViewCell() {
        pokemonListTableView.delegate = self
        pokemonListTableView.dataSource = self
        pokemonListTableView.register(PokemonListTableViewCell.nib, forCellReuseIdentifier: PokemonListTableViewCell.identifier)
    }

    private func setUpSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "ポケモンのおなまえをけんさく"
    }

    private func fetchData() {
        FetchAPIs.decodePokemonNameData { [self] in
            jaNameDataArray = $0
            jaNameDataArray.sort { $0.ids[0].id < $1.ids[0].id }
            fileteredJaNameDataArray = jaNameDataArray
        }

        FetchAPIs.decodePokemonData { [self] in
            dataArray = $0
            dataArray.sort { $0.id < $1.id }
            DispatchQueue.main.async { [self] in
                self.pokemonListTableView.reloadData()
                stopIndicator()
            }
        }
    }

    private func startIndicator() {
        indicator.startAnimating()
        view.alpha = 0.5
    }

    private func stopIndicator() {
        indicator.stopAnimating()
        indicator.isHidden = true
        view.alpha = 1
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    @objc func addFavoriteList(sender: UIButton) {
        isFavorite.toggle()
        sender.tintColor = isFavorite ? .systemYellow : .systemGray4
        pokemonListTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fileteredJaNameDataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = pokemonListTableView.dequeueReusableCell(withIdentifier: PokemonListTableViewCell.identifier, for: indexPath) as! PokemonListTableViewCell

        let pokeDexID = fileteredJaNameDataArray[indexPath.row].ids[0].id - 1

        cell.configure(imageURL: URL(string: dataArray[pokeDexID].sprites.frontImage)!, id: "\(dataArray[pokeDexID].id)", enName: dataArray[pokeDexID].name, jaName: fileteredJaNameDataArray[indexPath.row].names[0].name)

//        cell.addFavoriteButton.tag = indexPath.row
        cell.addFavoriteButton.addTarget(self, action: #selector(addFavoriteList(sender:)), for: .touchUpInside)
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fileteredJaNameDataArray = []

        if searchText.isEmpty {
            fileteredJaNameDataArray = jaNameDataArray
        } else {
            jaNameDataArray.forEach {
                if $0.names[0].name.contains(searchText.hiraganaToKatakana()) {
                    fileteredJaNameDataArray.append($0)
                }
            }
        }
        pokemonListTableView.reloadData()
    }
}
