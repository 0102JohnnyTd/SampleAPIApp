//
//  Pokemon.swift
//  SampleAPI
//
//  Created by Johnny Toda on 2022/08/02.
//

import Foundation

struct Pokemon: Codable {
    let name: String
    let id: Int
    let sprites: Image
}

struct Image: Codable {
    let frontImage: String

    enum codingKeys: String, CodingKey {
        case frontImage = "front_default"
    }
}
