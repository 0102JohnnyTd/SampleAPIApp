//
//  PokemonJaName.swift
//  SampleAPI
//
//  Created by Johnny Toda on 2022/08/02.
//

import Foundation

struct PokemonJaName: Codable {
    let names: [Name]
    let ids: [PokeDex]

    enum CodingKeys: String, CodingKey {
        case names
        case ids = "pokedex_numbers"
    }
}

struct Name: Codable {
    let name: String
}

struct PokeDex: Codable {
    let id: Int

    enum CodingKeys: String, CodingKey {
        case id = "entry_number"
    }
}
