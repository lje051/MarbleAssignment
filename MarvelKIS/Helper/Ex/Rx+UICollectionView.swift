//
//  Rx+UICollectionView.swift
//  MarvelKIS
//
//  Created by Jeeeun Lim on 2022/04/09.
//
import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UICollectionView {
    /// Cell.Type과 cellIdentifier가 동일해야 합니다.
    public func items<Sequence: Swift.Sequence, Cell: UICollectionViewCell, Source: ObservableType>
        (cellType: Cell.Type = Cell.self)
        -> (_ source: Source)
        -> (_ configureCell: @escaping (Int, Sequence.Element, Cell) -> Void)
        -> Disposable
        where Source.Element == Sequence {
        return self.items(cellIdentifier: String(describing: Cell.self), cellType: Cell.self)
    }

    /**
    CellModel과 바인딩 합니다. RxTableViewCell인 경우 bind(to:CellModel)을 호출합니다.

    - parameter source: Observable sequence of items.
    - returns: Disposable object that can be used to unbind.

     Example:

         let items: [CellModel] = []
         items.bind(to: tableView.rx.cells).disposed(by: disposeBag)

    */
    func cells<Sequence: Swift.Sequence, Source: ObservableType>
        (_ source: Source)
        -> Disposable
        where Source.Element == Sequence {
        return items(source)({ cv, row, element -> UICollectionViewCell in
            guard let model: CellModel = element as? CellModel else {
                return .init()
            }

            let cell: UICollectionViewCell = cv.dequeueReusableCell(withReuseIdentifier: model.cellID, for: .init(row: row, section: 0))
            if let cell = cell as? RxCollectionViewCell {
                cell.bind(to: model)
            }

            return cell
        })
    }

    public func prefetchRows(pageSize: Int) -> ControlEvent<Int> {
        let events = prefetchItems.map { $0.map { $0.row + 1 } }
            .compactMap { rows -> Int? in
                let total: Int = base.numberOfItems(inSection: 0)
                guard rows.contains(total) else {
                    return nil
                }

                if total < pageSize {
                    return nil
                }

                return (total / pageSize) + 1
            }

        return ControlEvent(events: events)
    }


    public var selectItem: Binder<IndexPath> {
        return Binder(self.base) { base, index in
            base.selectItem(at: index, animated: true, scrollPosition: .left)
        }
    }
}
