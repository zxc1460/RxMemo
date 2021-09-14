//
//  MemoDetailViewController.swift
//  RxMemo
//
//  Created by DoHyeong on 2021/09/10.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class MemoDetailViewController: UIViewController, ViewModelBindableType {

    var viewModel: MemoDetailViewModel!
    
    lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        return toolBar
    }()
    
    lazy var deleteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(systemItem: .trash)
        button.tintColor = .systemRed
        return button
    }()
    
    lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(systemItem: .compose)
        return button
    }()
    
    lazy var shareButton: UIBarButtonItem = {
        let button = UIBarButtonItem(systemItem: .action)
        return button
    }()
    
    lazy var listTableView: UITableView = {
       let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "contentCell") // lines 0, lineBreak WordWrap
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "dateCell")    // textColor ligthGray, alignment center
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        return tableView
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
        
        viewModel.contents
            .bind(to: listTableView.rx.items) { tableView, row, value in
                switch row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell")!
                    cell.textLabel?.text = value
                    cell.textLabel?.lineBreakMode = .byWordWrapping
                    cell.textLabel?.numberOfLines = 0
                    
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell")!
                    cell.textLabel?.text = value
                    cell.textLabel?.textColor = .lightGray
                    cell.textLabel?.textAlignment = .center
                    
                    return cell
                default:
                    fatalError()
                }
            }
            .disposed(by: rx.disposeBag)
        
        editButton.rx.action = viewModel.makeEditAction()
        deleteButton.rx.action = viewModel.makeDeleteAction()
        
        shareButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let memo = self?.viewModel.memo.content else { return }
                
                let vc = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
                self?.present(vc, animated: true, completion: nil)
            })
            .disposed(by: rx.disposeBag)
    }
    
    private func configureUI() {
        view.addSubview(toolBar)
        
        toolBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.items = [deleteButton, spacer, editButton, spacer, shareButton]
        
        view.addSubview(listTableView)
        
        listTableView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(toolBar.snp.top)
        }
    }

}
