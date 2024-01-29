//
//  DetailViewController.swift
//  MarvelKIS
//
//  Created by Jeeeun Lim on 2022/04/10.
//
import Kingfisher
import UIKit
import RxSwift
import RxCocoa

final class DetailViewController: ViewController {
    @IBOutlet private weak var descLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var subTableView: UITableView!
    @IBOutlet private weak var imageButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!

    override func bindViewModel() {
        guard let viewModel = viewModel as? DetailViewModel else { return }
        let output = viewModel.transform()
        output.subCell.bind(to: subTableView.rx.cells).disposed(by: disposeBag)
        imageButton.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        output.nameText.bind(to: nameLabel.rx.text).disposed(by: disposeBag)
        output.descText.bind(to: descLabel.rx.text).disposed(by: disposeBag)

        output.thumbnailUrl
            .asDriverOnErrorJustComplete()
            .drive(onNext: { [weak self] str in
                guard let self = self else { return }
                self.imageView.kf.setImage(with: URL.init(string: str))
            })
            .disposed(by: disposeBag)

        subTableView.rx.modelSelected(CellModel.self)
        .asDriverOnErrorJustComplete()
        .drive(onNext: { [weak self] item in
            guard let self = self else { return }
            if let item = item as? DetailTableViewCellModel {
                let viewModel: DetailViewModel = .init(item.item.resourceURI + "?")
                self.present(DetailViewController.make( "Main", viewModel: viewModel), animated: false)
                return
            }
            if let item = item as? UrlTableViewCellModel {
                let viewModel: WebViewModel = .init(item.item.url)
                self.present(WebViewController.make( "Main", viewModel: viewModel), animated: false)
            }

        })
        .disposed(by: disposeBag)

        
    }

    @objc func saveImage() {
        guard let selectedImage = self.imageView.image else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    //MARK: - Save Image callback
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print(error.localizedDescription)
            self.view.makeToast("앨범 저장에 실패했습니다.")
        } else {
            print("Success")
            self.view.makeToast("사진이 앨범에 추가되었습니다.")
        }
    }

}
