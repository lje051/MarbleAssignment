//
//  DetailViewModel.swift
//  MarvelKIS
//
//  Created by Jeeeun Lim on 2022/04/10.
//

import RxSwift
import UIKit

final class DetailViewModel: ViewModel, ViewModelProtocol {
    struct Input {
        let prefetch: PublishSubject<Int> = .init()
        let modelSelect: PublishSubject<CellModel> = .init()
        let imageTapped: PublishSubject<Void> = .init()
    }

    struct Output {
        let subCell: BehaviorSubject<[CellModel]> = .init(value: [])
        let showDetail: PublishSubject<Character> = .init()
        let descText: BehaviorSubject<String> = .init(value: "")
        let thumbnailUrl: PublishSubject<String> = .init()
        let nameText:  BehaviorSubject<String> = .init(value: "")
    }

    let input: Input = .init()
    let urlString: String
    let pageSize: Int = 10

    init(_ urlString: String) {
        self.urlString = urlString
    }

    func transform() -> Output {
        let output: Output = .init()
        let refreshData: PublishSubject<Void> = .init()

        refreshData
            .flatMap { [unowned self] in
                fetchDetailInfo(urlString: urlString + "ts=1")
            }
            .map { item in
                guard let result = item.data.results, result.count > 0 else { return [] }
                let chareter = result[0] as DetailParentInfo.DataClass.DetailInfo
                output.descText.onNext(chareter.description ?? "")
                output.nameText.onNext(chareter.name ?? "")
                if let thumbnail = chareter.thumbnail {
                    output.thumbnailUrl.onNext(thumbnail.path + "." + thumbnail.thumbnailExtension)
                }

                var items: [CellModel] = []
                if let urls = chareter.urls {
                    items.append(TitleTableViewCellModel.init("Url", urls.count))
                    for item in urls {
                        items.append(UrlTableViewCellModel.init(item))
                    }
                }
                if let comics = chareter.comics?.items {
                    items.append(TitleTableViewCellModel.init("Comics", comics.count))
                    for item in comics {
                        items.append(DetailTableViewCellModel.init(item))
                    }
                }
                if let series = chareter.series?.items {
                    items.append(TitleTableViewCellModel.init("Series", series.count))
                    for item in series {
                        items.append(DetailTableViewCellModel.init(item))
                    }
                }
                if let events = chareter.events?.items {
                    items.append(TitleTableViewCellModel.init("Events", events.count))
                    for item in events {
                        items.append(DetailTableViewCellModel.init(item))
                    }
                }
                if let stories = chareter.stories?.items {
                    items.append(TitleTableViewCellModel.init("Stories", stories.count))
                    for item in stories {
                        items.append(DetailTableViewCellModel.init(item))
                    }
                }
                return items

            }
            .bind(to: output.subCell)
            .disposed(by: disposeBag)

        refreshData.onNext(())

        return output
    }

    func fetchDetailInfo(urlString: String) -> Observable<DetailParentInfo> {
        return MarvelAPIClient.request(urlString, method: .get)
            .expectType(DetailParentInfo.self)
            .catchAndReturn(.init(data: .init(total: 0, count: 0, results: [])))
    }
}
