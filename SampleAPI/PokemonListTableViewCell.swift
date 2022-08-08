//
//  PokemonListTableViewCell.swift
//  SampleAPI
//
//  Created by Johnny Toda on 2022/08/07.
//

import UIKit
import Kingfisher

final class PokemonListTableViewCell: UITableViewCell {
    @IBOutlet private weak var imageIcon: UIImageView!
    @IBOutlet private weak var idLabel: UILabel!
    @IBOutlet private weak var addFavoriteButton: UIButton!
    @IBOutlet private weak var enNameLabel: UILabel!
    @IBOutlet private weak var jaNameLabel: UILabel!

    static let nib = UINib(nibName: String(describing: PokemonListTableViewCell.self), bundle: nil)
    static let identifier = String(describing: PokemonListTableViewCell.self)
    
    func configure(imageURL: URL, id: String, enName: String, jaName: String) {
        imageIcon.kf.setImage(with: imageURL)
        idLabel.text = id
        enNameLabel.text = enName
        jaNameLabel.text = jaName
    }
}
