//
//  BoardsSearchViewController.swift
//  SampleProject
//
//  Created by rayeon lee on 2023/12/20.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class BoardsSearchViewController: UIViewController, UIGestureRecognizerDelegate {
    private let searchBar = UISearchBar()
    
    private lazy var emptyView : EmptyView = {
        let emptyView = EmptyView()
        emptyView.imageView.image = UIImage(systemName: "magnifyingglass")
        emptyView.descriptionLabel.text = "게시글의 제목, 내용 또는 작성자에 포함된 단어 또는 문장을 검색해주세요."
        return emptyView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemGray6
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = 75
        tableView.register(BoardsSearchTableViewCell.self, forCellReuseIdentifier: BoardsSearchTableViewCell.identifier)
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    private let boardsSearchViewMdoel : BoardsSearchViewModelProtocol!
    private let disposedBag = DisposeBag()
    
    init(_ viewModel:BoardsSearchViewModelProtocol){
        boardsSearchViewMdoel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemGray6
        searchBar.delegate = self
        searchBar.placeholder = "검색"
        searchBar.backgroundColor = .white
        searchBar.searchTextField.delegate = self
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray], for: .normal)
        self.navigationItem.titleView = searchBar
        self.navigationItem.backBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true
        
        
        self.view.addSubview(tableView)
        self.view.addSubview(emptyView)
        
        setupContraints()
        setupBinds()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            self.searchBar.becomeFirstResponder()
        }
        
    }
    
}

extension BoardsSearchViewController {
    
    private func setupBinds() {
        //Inputs
        
        rx.viewWillAppear
            .bind(to: boardsSearchViewMdoel.inputs.fetchRecentHistory)
            .disposed(by: disposedBag)
        
        searchBar.rx.text
            .orEmpty
            .skip(1)
            .bind(to: boardsSearchViewMdoel.inputs.update)
            .disposed(by: disposedBag)
        
        tableView.rx.modelSelected(BoardsSearchCellModel.self)
            .bind(to: boardsSearchViewMdoel.inputs.select)
            .disposed(by: disposedBag)
        
        //Outputs
        boardsSearchViewMdoel.outputs.items
            .drive(tableView.rx.items(cellIdentifier: BoardsSearchTableViewCell.identifier, cellType: BoardsSearchTableViewCell.self)) {
                [weak self] index, item, cell in
                guard let self = self else { return }
                cell.fill(item, idx: index, leftButtonTap: self.boardsSearchViewMdoel.inputs.delete)
            }
            .disposed(by: disposedBag)
        
        boardsSearchViewMdoel.outputs.selected
            .emit(onNext: { cellmodel in
                let vm = ResultViewModel(with: cellmodel)
                let vc = ResultViewController(vm)
                self.navigationController?.pushViewController(vc, animated: false)
            })
            .disposed(by: disposedBag)
        
        boardsSearchViewMdoel.outputs.hasPosts
            .asDriver()
            .drive(emptyView.rx.isHidden)
            .disposed(by: disposedBag)
        
        
    }
    
    private func setupContraints() {
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(0)
        }
        
        self.emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(0)
        }
    }
}


extension BoardsSearchViewController : UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text?.lowercased() else { return }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        navigationController?.popViewController(animated: false)
    }
    
}

extension BoardsSearchViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchBar.resignFirstResponder()
        return true
    }
}
