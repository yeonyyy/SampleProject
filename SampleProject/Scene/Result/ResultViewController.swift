//
//  ResultViewController.swift
//  SampleProject
//
//  Created by rayeon lee on 2023/12/20.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class ResultViewController: UIViewController {
    
    private let searchBar = UISearchBar()
   
    private lazy var emptyView : EmptyView = {
        let emptyView = EmptyView()
        emptyView.imageView.image = UIImage(systemName: "magnifyingglass")
        emptyView.descriptionLabel.text = "검색 결과가 없습니다.\n 다른 검색어를 입력해 보세요."
        return emptyView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemGray6
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = 75
        tableView.register(BoardsTableViewCell.self, forCellReuseIdentifier: BoardsTableViewCell.identifier)
        return tableView
    }()

    private let resultViewMdoel : ResultViewModelProtocol!
    private let disposedBag : DisposeBag = DisposeBag()
    
    init(_ viewModel:ResultViewModelProtocol){
        resultViewMdoel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemGray6
        searchBar.backgroundColor = .white
        searchBar.delegate = self
        searchBar.searchTextField.text = ""
        searchBar.searchTextField.isUserInteractionEnabled = false
        searchBar.searchTextField.clearButtonMode = .never
        searchBar.showsCancelButton = true
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = true
        }
        self.navigationItem.titleView = searchBar
        self.navigationItem.backBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true
        
        view.addSubview(tableView)
        view.addSubview(emptyView)
        
        setupContraints()
        setupBind()
        
    }
    
    private func setupContraints() {
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().offset(0)
        }
        
        self.emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview().offset(0)
        }
    }
    
    private func setupBind() {
        searchBar.searchTextField.text = resultViewMdoel.outputs.searchString
        
        rx.viewWillAppear
            .bind(to: resultViewMdoel.inputs.fetchQuery)
            .disposed(by: disposedBag)
        
        resultViewMdoel.outputs.posts
            .drive(tableView.rx.items(cellIdentifier: BoardsTableViewCell.identifier, cellType: BoardsTableViewCell.self)) {
                index, post, cell in
                cell.fill(with: post)
            }
            .disposed(by: disposedBag)
    
        resultViewMdoel.outputs.hasPosts
            .asDriver()
            .drive(emptyView.rx.isHidden)
            .disposed(by: disposedBag)
        
        
    }
    
    
}

extension ResultViewController : UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        navigationController?.popViewController(animated: false)
    }
}

