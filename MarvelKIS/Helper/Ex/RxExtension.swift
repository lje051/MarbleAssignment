//
//  RxExtension.swift
//  MarvelKIS
//
//  Created by Jeeeun Lim on 2022/04/09.
//

import UIKit
import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base: UIButton {
    var throttleTap: Observable<ControlEvent<Void>.Element> {
        return controlEvent(.touchUpInside).throttle(.seconds(1), scheduler: MainScheduler.instance)
    }
}

public extension RxSwift.Reactive where Base: UIViewController {
    var viewWillAppear: Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewWillAppear))
            .map { $0.first as? Bool ?? false }
    }

    var viewDidAppear: Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewDidAppear(_:)))
            .map { $0.first as? Bool ?? false }
    }

    var viewWillDisappear: Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewWillDisappear(_:)))
            .map { $0.first as? Bool ?? false }
    }
}

extension ObservableType {
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            assertionFailure("Error \(error)")
            return Driver.empty()
        }
    }

}
