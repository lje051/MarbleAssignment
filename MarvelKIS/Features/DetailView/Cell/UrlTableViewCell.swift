//
//  UrlTableViewCell.swift
//  MarvelKIS
//
//  Created by Jeeeun Lim on 2022/04/10.
//

import Foundation
import UIKit

final class DetailTableViewCellModel: CellModel {
    let item: UrlItem
    init(_ item: UrlItem) {
        self.item = item
        super.init(cellID: "UrlTableViewCell")
    }

}

final class UrlTableViewCellModel: CellModel {
    let item: URLElement

    init(_ item: URLElement) {
        self.item = item
        super.init(cellID: "UrlTableViewCell")
    }
}

class UrlTableViewCell: RxTableViewCell {
    @IBOutlet private weak var urlLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!

    override func bind(to viewModel: CellModel) {
        if let viewModel = viewModel as? UrlTableViewCellModel {
            urlLabel.text = viewModel.item.url
            titleLabel.text = viewModel.item.type
        }
        if let viewModel = viewModel as? DetailTableViewCellModel {
            urlLabel.text = viewModel.item.resourceURI
            titleLabel.text = viewModel.item.name
        }
    }
}
