//
//  CharacterViewController.swift
//  MarvelKIS
//
//  Created by Jeeeun Lim on 2022/04/09.
//
import Toast
import UIKit
import RxSwift
import RxCocoa

final class CharacterViewController: ViewController {
   @IBOutlet private weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }

    override func bindViewModel() {
        guard let viewModel = viewModel as? CharacterViewModel else { return }
        let output = viewModel.transform()
        output.cells.bind(to: collectionView.rx.cells).disposed(by: disposeBag)
        collectionView.rx.prefetchRows(pageSize: viewModel.pageSize).bind(to: viewModel.input.prefetch).disposed(by: disposeBag)

        collectionView.rx.modelSelected(CharactersCellModel.self)
        .asDriverOnErrorJustComplete()
        .drive(onNext: { [weak self] item in
            guard let self = self else { return }
            let viewModel: DetailViewModel = .init("\(MarvelAPIClientConfig.host)" + "/\(item.item.id)?")
            self.present(DetailViewController.make( "Main", viewModel: viewModel), animated: false)

        })
        .disposed(by: disposeBag)

        output.showToast.asDriverOnErrorJustComplete()
            .drive(onNext: { [weak self] str in
                guard let self = self else { return }
                self.view.makeToast(str)
            })
            .disposed(by: disposeBag)

    }

}

extension CharacterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let width = (screenWidth - 40) / 2
        return .init(width: CGFloat(width), height: 175)
    }
}
