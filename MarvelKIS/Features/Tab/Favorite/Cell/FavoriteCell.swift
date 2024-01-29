//
//  FavoriteCell.swift
//  MarvelKIS
//
//  Created by Jeeeun Lim on 2022/04/11.
//
import RxSwift
import Kingfisher
import Foundation
import UIKit

final class FavoriteCellModel: CellModel {
    let item: Character
    let deleteItem: PublishSubject<Character> = .init()

    init(_ item: Character) {
        self.item = item
        super.init(cellID: "FavoriteCell")
    }

}

final class FavoriteCell: RxCollectionViewCell {
    @IBOutlet private weak var characterImage: UIImageView!
    @IBOutlet private weak var characterName: UILabel!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var deleteButton: UIButton!

    override func makeUI() {
        super.makeUI()
    }

    override func bind(to viewModel: CellModel) {
        guard let viewModel = viewModel as? FavoriteCellModel else { return }
        characterName.text = viewModel.item.name
        guard let thumbnail = viewModel.item.thumbnail else { return }
        let url = URL(string: thumbnail.path + "." + thumbnail.thumbnailExtension)
        characterImage.kf.setImage(with: url)
        deleteButton.rx.throttleTap.map{ viewModel.item }.bind(to: viewModel.deleteItem).disposed(by: disposeBag)
    }


}
