//
//  FetchAPIs.swift
//  SampleAPI
//
//  Created by Johnny Toda on 2022/08/04.
//

import Foundation

// データを取得し、Swiftの型として利用可能にする処理をまとめた構造体
struct FetchAPIs {
    // D＆P世代までの全ポケモン493体分のデータのURLを取得するための範囲
    private  static let PokemonIDRange = 1...493

    // getURLメソッドにて取得するURLを切り分けるための列挙型
    enum TypeOfFetch {
        case pokemon
        case pokemonJaName
    }

    // 取得したポケモンのデータをSwiftの型として扱う為にデコード
    static func decodePokemonData(completion: @escaping ([Pokemon]) -> Void) {
        // データの取得を実行
        Self.fetchData(typeOfFetch: .pokemon) { dataArray in
            var jsons: [Pokemon] = []

            dataArray.forEach {
                // 取得したデータをJSONDecoderクラスのdecodeメソッドでパース
                do {
                    let json = try JSONDecoder().decode(Pokemon.self, from: $0)
                    // デコード完了後に変数jsonsに追加
                    jsons.append(json)
                } catch(let error) {
                    // パース失敗時のエラー処理
                    print(error)
                }
            }
            // 引数クロージャにjsonsを渡して実行
            completion(jsons)
        }
    }


    // 取得したポケモンの名前データをSwiftの型として扱う為にデコード
    static func decodePokemonNameData(completion: @escaping ([PokemonJaName]) -> Void) {
        // データの取得を実行
        Self.fetchData(typeOfFetch: .pokemonJaName) { dataArray in
            var jsons: [PokemonJaName] = []


            dataArray.forEach {
                // 取得したデータをJSONDecoderクラスのdecodeメソッドでパース
                do {
                    let json = try JSONDecoder().decode(PokemonJaName.self, from: $0)
                    // デコード完了後に変数jsonsに追加
                    jsons.append(json)
                } catch(let error) {
                    // パース失敗時のエラー処理
                    print(error)
                }
                // 引数クロージャにjsonsを渡して実行
                completion(jsons)
            }
        }
    }

    // データを取得
    private static func fetchData(typeOfFetch: TypeOfFetch, completion: @escaping ([Data]) -> Void) {
        // D＆P世代までの全ポケモン493体分のデータのURLを取得
        let stringURLs = getURLs(typeOfFetch: typeOfFetch, range: PokemonIDRange)

        // 取得したURLをString型からURL型に変換
        let urls = stringURLs.map { URL(string: $0) }

        // なぜdataArrayにデータを追加する必要があるのだろうか。
        var dataArray: [Data] = []


        urls.forEach {
            // タスクをセット
            let task = URLSession.shared.dataTask(with: $0!) { data, response, error in
                //　エラーが発生した場合はエラーを出力
                if let error = error {
                    print(error)
                    return
                }
                // データをdataArrayに追加
                if let data = data {
                    dataArray.append(data)
                }
                // 全てのデータをdataArrayに格納した場合、引数クロージャにdataArrayを渡して実行
                if urls.count == dataArray.count {
                    completion(dataArray)
                }
            }
            // 通信を実行
            task.resume()
        }
    }

    // D＆P世代までの全ポケモン493体分のデータのURLを取得
    private static func getURLs(typeOfFetch: TypeOfFetch, range: ClosedRange<Int>) -> [String] {
        let urls: [String] = range.map {
            let url: String
            // 指定したタイプごとに取得するURLを切り替え
            switch typeOfFetch {
            case .pokemon: url = "https://pokeapi.co/api/v2/pokemon/\($0)/"
            case .pokemonJaName: url = "https://pokeapi.co/api/v2/pokemon-species/\($0)/"
            }
            return url
        }
        return urls
    }
}
