//
//  ViewController.swift
//  SampleAPI
//
//  Created by Johnny Toda on 2022/08/02.
//

import UIKit
import RealmSwift

final class PokemonListViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!

    @IBOutlet private weak var segmentedControl: UISegmentedControl!

    @IBOutlet private weak var pokemonListTableView: UITableView!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!


    @IBAction private func segmentedControl(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        // お気に入り→図鑑に切り替えた時
        case 0:
            // 保管しておいたデータを再度代入
            fileteredJaNameDataArray = nameDataArrayManager
            // tableViewを更新
            pokemonListTableView.reloadData()
        // 図鑑→お気に入りに切り替えた時
        case 1:
            // 再び図鑑に切り替えた時の為にデータを保管しておく
            nameDataArrayManager = fileteredJaNameDataArray
            // お気に入り登録したPokemonのデータを代入
            fileteredJaNameDataArray = favoriteJaNameDataArray
            // tableViewを更新
            pokemonListTableView.reloadData()
        default: break
        }
    }

    // Pokemonの画像や英語名、図鑑No.のデータを保管している配列
    private var dataArray: [Pokemon] = []

    // 各国のPokemonの名前のDataを保管している配列
    private var jaNameDataArray: [PokemonJaName] = []
    // TableViewに表示させる各国のPokemonの名前のdataを保管している配列
    private var fileteredJaNameDataArray: [PokemonJaName] = []

    // 図鑑モードからお気に入りPokemon図鑑モードに切り替えた際、図鑑モードのデータを保管しておく為の配列
    private var nameDataArrayManager: [PokemonJaName] = []

    // お気に入り登録したPokemonのデータを保管する配列
    private var favoriteJaNameDataArray: [PokemonJaName] = []
    
    private var isFavorite = false
    private let realm = try! Realm()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Indicatorを起動
        startIndicator()

        // Cellの登録
        setUpTableViewCell()
        // 検索barに関する設定
        setUpSearchBar()

        // dataを取得
        fetchData()
    }

    // Cellの登録
    private func setUpTableViewCell() {
        pokemonListTableView.delegate = self
        pokemonListTableView.dataSource = self
        pokemonListTableView.register(PokemonListTableViewCell.nib, forCellReuseIdentifier: PokemonListTableViewCell.identifier)
    }

    // 検索barに関する設定
    private func setUpSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Pokemonのおなまえをけんさく"
    }

    // API通信を実行してdataを取得し、parse
    private func fetchData() {
        // 各国のPokemonの名前のdataを取得してdecode
        FetchAPIs.decodePokemonNameData { [self] in
            // 定義した配列に格納
            jaNameDataArray = $0
            // 図鑑番号順(昇順)に要素の順番を並び替え
            jaNameDataArray.sort { $0.ids[0].id < $1.ids[0].id }
            // tableViewに表示する用の配列にデータを代入
            fileteredJaNameDataArray = jaNameDataArray
        }

        // Pokemonのdataを取得してデコード
        FetchAPIs.decodePokemonData { [self] in
            // 定義した配列に格納
            dataArray = $0
            // 図鑑番号順(昇順)に要素の順番を並び替え
            dataArray.sort { $0.id < $1.id }
            // data取得後に、TableViewを更新し、Indicatorをstopする
            DispatchQueue.main.async { [self] in
                self.pokemonListTableView.reloadData()
                stopIndicator()
            }
        }
    }

    // Indicatorを起動
    private func startIndicator() {
        indicator.startAnimating()
        view.alpha = 0.5
    }

    // Indicatorを停止
    private func stopIndicator() {
        indicator.stopAnimating()
        indicator.isHidden = true
        view.alpha = 1
    }
}

extension PokemonListViewController: UITableViewDelegate, UITableViewDataSource {
    @objc func addFavoriteList(sender: UIButton) {
        isFavorite.toggle()
        sender.tintColor = isFavorite ? .systemYellow : .systemGray4
        pokemonListTableView.reloadData()
    }

    // Cellの高さを指定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }

    // 生成するCellの数を指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fileteredJaNameDataArray.count
    }

    // Cellを生成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを生成
        let cell = pokemonListTableView.dequeueReusableCell(withIdentifier: PokemonListTableViewCell.identifier, for: indexPath) as! PokemonListTableViewCell

        // 配列のインデックス番号は0からだが、Pokemon図鑑No.は1から始まる為、差分の1を引く
           // ids[0] = 全国版Pokemon図鑑
        let pokeDexID = fileteredJaNameDataArray[indexPath.row].ids[0].id - 1

        // 引数に取得したdataを指定してCell上のオブジェクトにセット
        cell.configure(imageURL: URL(string: dataArray[pokeDexID].sprites.frontImage)!, id: "\(dataArray[pokeDexID].id)", enName: dataArray[pokeDexID].name, jaName: fileteredJaNameDataArray[indexPath.row].names[0].name)

//        cell.addFavoriteButton.tag = indexPath.row
        cell.addFavoriteButton.addTarget(self, action: #selector(addFavoriteList(sender:)), for: .touchUpInside)
        return cell
    }
}

// 検索barのデリゲートメソッド
extension PokemonListViewController: UISearchBarDelegate {
    // 検索barに文字を入力、または削除した場合に実行
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 重複を避ける為、一度配列の中身を空にする
        fileteredJaNameDataArray = []
        // 検索barの文字列が空だった場合
        if searchText.isEmpty {
            // 再度取得した全てのdataを代入する
            fileteredJaNameDataArray = jaNameDataArray
        } else {
            jaNameDataArray.forEach {
                // 配列namesの0番目の日本語名の要素を指定し、Pokemonの名前が検索キーワード(ひらがな、カタカナ)と一致した場合
                if $0.names[0].name.contains(searchText.hiraganaToKatakana()) {
                    // TableViewに表示する配列に要素を追加
                    fileteredJaNameDataArray.append($0)
                }
            }
        }
        // TableViewを更新
        pokemonListTableView.reloadData()
    }
}
