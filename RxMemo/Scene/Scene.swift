//
//  Scene.swift
//  RxMemo
//
//  Created by DoHyeong on 2021/09/10.
//

import UIKit

enum Scene {
    case list(MemoListViewModel)
    case detail(MemoDetailViewModel)
    case compose(MemoComposeViewModel)
}

extension Scene {
    func instantiate() -> UIViewController {
        switch self {
        case .list(let viewModel):
            let nav = UINavigationController(rootViewController: MemoListViewController())
            
            guard var listVC = nav.viewControllers.first as? MemoListViewController else {
                fatalError()
            }
            
            listVC.bind(viewModel: viewModel)
            
            return nav
        case .detail(let viewModel):
            var detailVC = MemoDetailViewController()
            
            detailVC.bind(viewModel: viewModel)
            
            return detailVC
        case .compose(let viewModel):
            let nav = UINavigationController(rootViewController: MemoComposeViewController())
            
            guard var composeVC = nav.viewControllers.first as? MemoComposeViewController else {
                fatalError()
            }
            
            composeVC.bind(viewModel: viewModel)
            
            return nav
        }
    }
}
