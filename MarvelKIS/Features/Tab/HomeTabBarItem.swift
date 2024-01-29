//
//  HomeTabBarItem.swift
//  MarvelKIS
//
//  Created by Jeeeun Lim on 2022/04/09.
//

import UIKit

enum HomeTabBarItem: Int, CaseIterable {
    case character
    case favorite
    case diary

    var title: String {
        switch self {
        case .character: return "홈"
        case .favorite: return "즐겨찾기"
        case .diary: return "다이어리"
        }
    }
    var storyboard: String { return "Main" }
    var controller: UIViewController {
        switch self {
        case .character:
            let viewModel: CharacterViewModel = .init()
            return CharacterViewController.make(storyboard, viewModel: viewModel)
        case .favorite:
            let viewModel: FavoriteViewModel = .init()
            return FavoriteViewController.make(storyboard, viewModel: viewModel)
        case .diary:
            let viewModel: DiaryViewModel = .init()
            return DiaryViewController.make(storyboard, viewModel: viewModel)
        }
    }
}
