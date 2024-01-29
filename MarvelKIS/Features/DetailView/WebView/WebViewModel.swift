//
//  WebViewModel.swift
//  MarvelKIS
//
//  Created by Jeeeun Lim on 2022/04/09.
//

import RxSwift
import RxCocoa
import UIKit

final class WebViewModel: ViewModel, ViewModelProtocol {

    struct Input {

    }

    struct Output {
    }

    let input: Input = .init()
    let urlString: String

    init(_ urlString: String) {
        self.urlString = urlString
    }

    func transform() -> Output {
        let output: Output = .init()

        return output
    }

}
