//
//  Ex+UIViewController.swift
//  MarvelKIS
//
//  Created by Jeeeun Lim on 2022/04/09.
//
import RxSwift
import UIKit

extension UIViewController {

    static func make(_ storyboardName: String, viewModel: ViewModel? = nil) -> Self {
        let className = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: className) as? Self else {
            fatalError("Class Name와 Storyboard identifier를 확인해주세요.")
        }
        if let viewController = viewController as? ViewController {
            viewController.viewModel = viewModel
        }

        return viewController
    }
}


class ViewController: UIViewController {

    public var viewModel: ViewModel?
    public var disposeBag: DisposeBag = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    open func bindViewModel() {


    }

}
