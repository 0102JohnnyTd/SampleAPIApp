//
//  FetchAPIs.swift
//  SampleAPI
//
//  Created by Johnny Toda on 2022/08/04.
//

import Foundation

struct FetchAPIs {
    private  static let PokemonIDRange = 1...493

    enum TypeOfFetch {
        case pokemon
        case pokemonJaName
    }

    static func decodePokemonData(completion: @escaping ([Pokemon]) -> Void) {
        Self.fetchData(typeOfFetch: .pokemon) { dataArray in
            var jsons: [Pokemon] = []

            dataArray.forEach { data in
                do {
                    let json = try JSONDecoder().decode(Pokemon.self, from: data)
                    jsons.append(json)
                } catch(let error) {
                    print(error)
                }
            }
            completion(jsons)
        }
    }

    static func decodePokemonNameData(completion: @escaping ([PokemonJaName]) -> Void) {
        Self.fetchData(typeOfFetch: .pokemonJaName) { dataArray in
            var jsons: [PokemonJaName] = []

            dataArray.forEach { data in
                do {
                    let json = try JSONDecoder().decode(PokemonJaName.self, from: data)
                    jsons.append(json)
                } catch(let error) {
                    print(error)
                }
                completion(jsons)
            }
        }
    }

    // そもそもcompletionに渡す意味とは
    private static func fetchData(typeOfFetch: TypeOfFetch, completion: @escaping ([Data]) -> Void) {
        let stringURLs = getURLs(typeOfFetch: typeOfFetch, range: PokemonIDRange)

        let urls = stringURLs.map { URL(string: $0) }
        var dataArray: [Data] = []

        urls.forEach {
            let task = URLSession.shared.dataTask(with: $0!) { data, response, error in
                if let error = error {
                    print(error)
                    return
                }

                if let data = data {
                    dataArray.append(data)
                }

                if urls.count == dataArray.count {
                    completion(dataArray)
                }
            }
            task.resume()
        }
    }

    private static func getURLs(typeOfFetch: TypeOfFetch, range: ClosedRange<Int>) -> [String] {
        let urls: [String] = range.map {
            let url: String
            switch typeOfFetch {
            case .pokemon: url = "https://pokeapi.co/api/v2/pokemon/\($0)/"
            case .pokemonJaName: url = "https://pokeapi.co/api/v2/pokemon-species/\($0)/"
            }
            return url
        }
        return urls
    }
}
