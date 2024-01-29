//
//  DiaryCell.swift
//  MarvelKIS
//
//  Created by 임지은 on 1/24/24.
//
import RxSwift
import UIKit


class DiaryCell: UICollectionViewCell {
    //@IBOutlet private weak var memoTextView: UITextView!
    //@IBOutlet private weak var saveButton: UIButton!
    @IBOutlet weak var memoLabel: UILabel!
    
    var editMymemo: ((String) -> Void)?
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func bindData(_ data: Diary) {
        self.memoLabel.text = data.contentText
    }

//    override func bind(to viewModel: CellModel) {
//        guard let viewModel = viewModel as? DiaryCellModel else { return }
////        characterName.text = viewModel.item.name
////        guard let thumbnail = viewModel.item.thumbnail else { return }
////        let url = URL(string: thumbnail.path + "." + thumbnail.thumbnailExtension)
////        characterImage.kf.setImage(with: url)
//       // guard let delegate = viewModel.delegate else { return }
//        //saveButton.rx.throttleTap.map{ viewModel }.bind(to: delegate.textEditing).disposed(by: disposeBag)
//    }


}
