//
//  PokemonJaName.swift
//  SampleAPI
//
//  Created by Johnny Toda on 2022/08/02.
//

import Foundation

// ポケモンの日本語名のデータ構造
struct PokemonJaName: Codable {
    // 各国ごとのポケモンの名前をまとめた配列
    let names: [Name]
    // 地方ごとのポケモン図鑑No.をまとめた配列
    let ids: [PokeDex]

    // デコードの際の代替キーをidsにセット
    enum CodingKeys: String, CodingKey {
        case names
        case ids = "pokedex_numbers"
    }
}

// ポケモンの名前のデータ構造
struct Name: Codable {
    // ポケモンの名前
    let name: String
}

// ポケモン図鑑のデータ構造
struct PokeDex: Codable {
    // ポケモンの図鑑No.
    let id: Int

    // デコードの際の代替キーをidにセット
    enum CodingKeys: String, CodingKey {
        case id = "entry_number"
    }
}
