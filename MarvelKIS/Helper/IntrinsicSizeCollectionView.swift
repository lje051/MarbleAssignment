//
//  IntrinsicSizeCollectionView.swift
//  MarvelKIS
//
//  Created by 임지은 on 1/24/24.
//

import UIKit

final class IntrinsicSizeCollectionView: UICollectionView {
    override var intrinsicContentSize: CGSize {
        return collectionViewLayout.collectionViewContentSize
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }

    override func reloadData() {
        super.reloadData()
        invalidateIntrinsicContentSize()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        isScrollEnabled = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        bounces = false
        bouncesZoom = false
    }
}

final class TestCollectionView: UICollectionView {
    override var intrinsicContentSize: CGSize {
        return .init(width: frame.width, height: collectionViewLayout.collectionViewContentSize.height)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }

    override func reloadData() {
        super.reloadData()
        invalidateIntrinsicContentSize()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
