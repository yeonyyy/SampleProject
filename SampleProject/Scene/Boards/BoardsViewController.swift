//
//  ViewController.swift
//  SampleProject
//
//  Created by rayeon lee on 2023/12/19.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class BoardsViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemGray6
        tableView.separatorStyle = .singleLine
        tableView.estimatedRowHeight = BoardsTableViewCell.estimatedCellHeight
        tableView.register(BoardsTableViewCell.self, forCellReuseIdentifier: BoardsTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var emptyView : EmptyView = {
        let emptyView = EmptyView()
        emptyView.imageView.image = UIImage(systemName: "magnifyingglass")
        emptyView.descriptionLabel.text = "등록된 게시글이 없습니다."
        return emptyView
    }()
    
    private let boardsViewMdoel : BoardsViewModelProtocol!
    private let disposedBag : DisposeBag = DisposeBag()
    
    init(_ viewModel:BoardsViewModelProtocol){
        boardsViewMdoel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)

        let docsDir = dirPaths[0]

        print(docsDir)
        
        setupViews()
        setupContraints()
        setupBinds()
        
    }
    
    @objc func sidemenu() {
    
    }
    
    @objc func search() {
        let vm = BoardsSearchViewModel()
        let vc = BoardsSearchViewController(vm)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}

// Mark : - Private method

extension BoardsViewController {
    private func setupBinds() {
    
        boardsViewMdoel.inputs.refresh.onNext(())

        tableView.rx.reachedBottom.asObservable()
            .bind(to: boardsViewMdoel.inputs.loadmore)
            .disposed(by: disposedBag)
        
        boardsViewMdoel.outputs.posts
            .drive(tableView.rx.items(cellIdentifier: BoardsTableViewCell.identifier, cellType: BoardsTableViewCell.self)) {
                index, post, cell in
                cell.fill(with: post)
            }
            .disposed(by: disposedBag)
        
        boardsViewMdoel.outputs.hasPosts
            .asDriver()
            .drive(emptyView.rx.isHidden)
            .disposed(by: disposedBag)


    }
    
    private func setupViews() {
        self.view.backgroundColor = .systemGray6
        self.title = "일반 게시판"
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(sidemenu))
        self.navigationItem.leftBarButtonItem?.tintColor = .darkGray
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(search))
        self.navigationItem.rightBarButtonItem?.tintColor = .darkGray

        self.view.addSubview(tableView)
        self.view.addSubview(emptyView)

    }
    
    private func setupContraints() {
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().offset(0)
        }
        
        self.emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview().offset(0)
        }
    }
    
}
