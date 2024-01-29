//
//  CharactersCell.swift
//  MarvelKIS
//
//  Created by Jeeeun Lim on 2022/04/09.
//
import Kingfisher
import Foundation
import UIKit

final class CharactersCellModel: CellModel {
    let item: Character
    weak var delegate: FavoriteDelegate?

    init(_ item: Character, delegate: FavoriteDelegate? = nil) {
        self.item = item
        self.delegate = delegate
        super.init(cellID: "CharactersCell")
    }

}

final class CharactersCell: RxCollectionViewCell {
    @IBOutlet private weak var characterImage: UIImageView!
    @IBOutlet private weak var characterName: UILabel!
    @IBOutlet private weak var saveButton: UIButton!

    override func bind(to viewModel: CellModel) {
        guard let viewModel = viewModel as? CharactersCellModel else { return }
        characterName.text = viewModel.item.name
        guard let thumbnail = viewModel.item.thumbnail else { return }
        let url = URL(string: thumbnail.path + "." + thumbnail.thumbnailExtension)
        characterImage.kf.setImage(with: url)
        guard let delegate = viewModel.delegate else { return }
        saveButton.rx.throttleTap.map{ viewModel }.bind(to: delegate.favoriteTapped).disposed(by: disposeBag)
    }


}
