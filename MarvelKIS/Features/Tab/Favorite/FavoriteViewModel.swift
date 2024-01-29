//
//  FavoriteViewModel.swift
//  MarvelKIS
//
//  Created by Jeeeun Lim on 2022/04/11.
//

import RxSwift
import UIKit

final class FavoriteViewModel: ViewModel, ViewModelProtocol {

    struct Input {
    }

    struct Output {
        let showToast: PublishSubject<String> = .init()
        let showDetail: PublishSubject<Character> = .init()
        let cells: PublishSubject<[CellModel]> = .init()
    }
    let deleteItem: PublishSubject<Character> = .init()
    let viewWillAppear: PublishSubject<Void> = .init()
    let input: Input = .init()


    func transform() -> Output {
        let output: Output = .init()

        deleteItem.subscribe(onNext: { [weak self] favorite in
            do {
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let items = try context.fetch(MyFavorite.fetchRequest())
                for saveditem in items where saveditem.id == favorite.id {
                    context.delete(saveditem)
                }
                try context.save()
                output.showToast.onNext("즐겨찾기 삭제되었습니다.")
                self?.viewWillAppear.onNext(())
            }
            catch {

            }
        })
        .disposed(by: disposeBag)

        viewWillAppear
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                do {
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    let items = try context.fetch(MyFavorite.fetchRequest())
                    var list: [FavoriteCellModel] = []
                    items.forEach { character in
                        let character: Character = .init(id: Int(character.id), name: character.name ?? "", thumbnail: .init(path: character.path ?? "", thumbnailExtension: character.thumbnailExtension ?? ""))
                        let cell: FavoriteCellModel = .init(character)
                        cell.deleteItem.bind(to: self.deleteItem).disposed(by: self.disposeBag)
                        list.append(cell)
                    }
                    output.cells.onNext(list)
                    return
                }
                catch {
                }
            })
            .disposed(by: disposeBag)

        return output
    }

    func fetchMainList(urlString: String) -> Observable<MainList> {
        return MarvelAPIClient.request(urlString, method: .get, headers: [:])
            .expectType(MainList.self)
    }
}
