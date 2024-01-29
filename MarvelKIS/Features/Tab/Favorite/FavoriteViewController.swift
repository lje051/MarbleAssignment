//
//  FavoriteViewController.swift
//  MarvelKIS
//
//  Created by Jeeeun Lim on 2022/04/11.
//

import UIKit
import RxSwift
import RxCocoa

final class FavoriteViewController: ViewController {
   @IBOutlet weak var collectionView: UICollectionView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }

    override func bindViewModel() {
        guard let viewModel = viewModel as? FavoriteViewModel else { return }
        let output = viewModel.transform()
        output.cells.bind(to: collectionView.rx.cells).disposed(by: disposeBag)
        rx.viewWillAppear.map { _ in }.bind(to: viewModel.viewWillAppear).disposed(by: disposeBag)
        output.showDetail
            .asDriverOnErrorJustComplete()
            .drive(onNext: { character in
                let viewModel: DetailViewModel = .init("\(MarvelAPIClientConfig.host)" + "/\(character.id)?")
                self.present(DetailViewController.make( "Main", viewModel: viewModel), animated: false)
            })
            .disposed(by: disposeBag)

        collectionView.rx.modelSelected(FavoriteCellModel.self)
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

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let width = (screenWidth - 40) / 2
        return .init(width: CGFloat(width), height: 175)
    }
}
