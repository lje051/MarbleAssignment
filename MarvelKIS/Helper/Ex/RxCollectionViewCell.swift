//
//  RxCollectionViewCell.swift
//  MarvelKIS
//
//  Created by Jeeeun Lim on 2022/04/09.

import UIKit
import Foundation
import RxCocoa
import RxSwift

class RxTableViewCell: UITableViewCell {
    var isDisabled: Bool = false
    var disposeBag: DisposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        makeUI()
    }

    func makeUI() {
        layer.masksToBounds = true
        selectionStyle = .none

        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }

    func setDisable() {
        isDisabled = true
        isUserInteractionEnabled = false
    }

    func setEnable() {
        isDisabled = false
        isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        guard !isDisabled else { return }
        super.setSelected(selected, animated: animated)
    }

    func bind(to viewModel: CellModel) { }
}

class RxCollectionViewCell: UICollectionViewCell {
    var disposeBag: DisposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        makeUI()
    }

    func makeUI() {
        layer.masksToBounds = true

        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }

    func bind(to viewModel: CellModel) { }
}
