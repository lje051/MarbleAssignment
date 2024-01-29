//
//  TitleTableViewCell.swift
//  MarvelKIS
//
//  Created by Jeeeun Lim on 2022/04/11.
//

import Foundation
import UIKit

final class TitleTableViewCellModel: CellModel {
    let name: String
    let count: Int

    init(_ name: String, _ count: Int) {
        self.name = name
        self.count = count
        super.init(cellID: "TitleTableViewCell")
    }

}

class TitleTableViewCell: RxTableViewCell {
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!

    override func bind(to viewModel: CellModel) {
        guard let viewModel = viewModel as? TitleTableViewCellModel else { return }
        titleLabel.text = viewModel.name
        countLabel.text = String(viewModel.count)
    }
}

