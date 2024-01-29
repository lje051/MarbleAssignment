//
//  Rx+UITableView.swift
//  MarvelKIS
//
//  Created by Jeeeun Lim on 2022/04/10.
//
import RxCocoa
import RxSwift
import UIKit
import Foundation

extension Reactive where Base: UITableView {

    public var scrollToRow: Binder<IndexPath> {
        return Binder(self.base) { base, index in
            base.scrollToRow(at: index, at: .top, animated: true)
        }
    }
    /// Cell.Type과 cellIdentifier가 동일해야 합니다.
    public func items<Sequence: Swift.Sequence, Cell: UITableViewCell, Source: ObservableType>
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
        return items(source)({ tv, row, element -> UITableViewCell in
            guard let model: CellModel = element as? CellModel,
                  let cell: UITableViewCell = tv.dequeue(identifier: model.cellID) else {
                return .init()
            }
            model.row = row
            if let cell = cell as? RxTableViewCell {
                cell.bind(to: model)
            }

            return cell
        })
    }
}
