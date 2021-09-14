//
//  MemoListViewController.swift
//  RxMemo
//
//  Created by DoHyeong on 2021/09/10.
//

import UIKit
import NSObject_Rx
import RxCocoa
import RxSwift
import SnapKit

class MemoListViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: MemoListViewModel!
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        configureUI()
    }
    
    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        viewModel.memoList
            .bind(to: tableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: rx.disposeBag)
        addButton.rx.action = viewModel.makeCreateAction()
        
        Observable.zip(tableView.rx.modelSelected(Memo.self),
                       tableView.rx.itemSelected)
            .do(onNext: { [unowned self] (_, indexPath) in
                    self.tableView.deselectRow(at: indexPath, animated: true)
            })
            .map { $0.0 }
            .bind(to: viewModel.detailAction.inputs)
            .disposed(by: rx.disposeBag)
        
        tableView.rx.modelDeleted(Memo.self)
            .bind(to: viewModel.deleteAction.inputs)
            .disposed(by: rx.disposeBag)

    }
    
    private func configureUI() {
        self.navigationItem.rightBarButtonItem = addButton
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
