//
//  ViewModelProtocol.swift
//  MarvelKIS
//
//  Created by Jeeeun Lim on 2022/04/09.
//

import Foundation
import RxSwift

protocol ViewModelProtocol {
    associatedtype Input
    associatedtype Output

    var input: Input { get }

    func transform() -> Output
}

class ViewModel: NSObject {
    var disposeBag: DisposeBag = .init()

    deinit {
        print("\(type(of: self))")
    }
}

class CellModel: NSObject {
    let cellID: String
    var row: Int?

    init(cellID: String) {
        self.cellID = cellID
    }
}
