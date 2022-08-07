//
//  PokemonListTableViewCell.swift
//  SampleAPI
//
//  Created by Johnny Toda on 2022/08/07.
//

import UIKit

final class PokemonListTableViewCell: UITableViewCell {
    @IBOutlet private weak var imageIcon: UIImageView!
    @IBOutlet private weak var idLabel: UILabel!
    @IBOutlet private weak var enNameLabel: UILabel!
    @IBOutlet private weak var jaNameLabel: UILabel!

    func configure(id: String, enName: String, jaName: String) {
        idLabel.text = id
        enNameLabel.text = enName
        jaNameLabel.text = jaName
    }
}
