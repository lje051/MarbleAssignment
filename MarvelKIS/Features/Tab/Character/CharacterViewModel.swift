//
//  CharacterViewModel.swift
//  MarvelKIS
//
//  Created by Jeeeun Lim on 2022/04/09.
//
import RxSwift
import UIKit

protocol FavoriteDelegate: AnyObject {
    var favoriteTapped: PublishSubject<CharactersCellModel> { get }
}

final class CharacterViewModel: ViewModel, ViewModelProtocol, FavoriteDelegate {
    struct Input {
        let prefetch: PublishSubject<Int> = .init()
    }

    struct Output {
        let showToast: PublishSubject<String> = .init()
        let showDetail: PublishSubject<Character> = .init()
        let cells: PublishSubject<[CellModel]> = .init()
    }
    let input: Input = .init()
    let pageSize: Int = 10
    let favoriteTapped: PublishSubject<CharactersCellModel> = .init()

    func transform() -> Output {
        let output: Output = .init()
        let refreshData: PublishSubject<Void> = .init()

        input.prefetch.distinctUntilChanged()
            .flatMap { [unowned self] pagenum in
                fetchMainList(urlString: "\(MarvelAPIClientConfig.host)?orderBy=name&limit=20&ts=1&offset=\(pagenum * pageSize)&") }
            .compactMap { item ->  [CharactersCellModel] in
                var list: [CharactersCellModel] = []
                item.data.items.forEach { character in
                    list.append(.init(character, delegate: self))
                }
                return list
            }
            .withLatestFrom(output.cells) { $1 + $0 }
            .bind(to: output.cells)
            .disposed(by: disposeBag)

        favoriteTapped
            .subscribe(onNext: { favorite in
                 do {
                     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                     let items = try context.fetch(MyFavorite.fetchRequest())
                     for saveditem in items where saveditem.id == favorite.item.id {
                         return
                     }
                     let newItem = MyFavorite(context: context)
                     newItem.id = Int64(favorite.item.id)
                     if let thumbnail = favorite.item.thumbnail {
                         newItem.path = thumbnail.path
                         newItem.thumbnailExtension = thumbnail.thumbnailExtension
                     }
                     newItem.name = favorite.item.name
                     try context.save()
                     output.showToast.onNext("즐겨찾기 추가되었습니다.")
                 }
                 catch {

                 }
            })
            .disposed(by: disposeBag)

        refreshData
            .flatMap {
                self.fetchMainList(urlString: "\(MarvelAPIClientConfig.host)?orderBy=name&limit=20&ts=1&offset=1&")
            }
            .map { item -> [CharactersCellModel] in
                var list: [CharactersCellModel] = []
                item.data.items.forEach { character in
                    list.append(.init(character, delegate: self))
                }
                return list
            }
            .bind(to: output.cells)
            .disposed(by: disposeBag)

        refreshData.onNext(())

        return output
    }

    func fetchMainList(urlString: String) -> Observable<MainList> {
        return MarvelAPIClient.request(urlString, method: .get, headers: [:])
            .expectType(MainList.self)
    }
}
