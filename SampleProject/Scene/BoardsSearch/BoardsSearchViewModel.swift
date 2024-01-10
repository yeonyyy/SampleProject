//
//  BoardsSearchViewModel.swift
//  SampleProject
//
//  Created by rayeon lee on 2023/12/23.
//

import Foundation
import RxCocoa
import RxSwift

protocol BoardsSearchViewModelInputs {
    var fetchRecentHistory : PublishSubject<Void> { get }
    var update : PublishSubject<String> { get }
    var select : PublishSubject<BoardsSearchCellModel> { get }
    var delete : PublishSubject<(Int, BoardsSearchCellModel)> { get }
}

protocol BoardsSearchViewModelOutput {
    var items: Driver<[BoardsSearchCellModel]> { get }
    var selected : Signal<BoardsSearchCellModel> { get }
    var hasPosts : BehaviorRelay<Bool> { get }
}

protocol BoardsSearchViewModelProtocol {
    var inputs: BoardsSearchViewModelInputs { get }
    var outputs: BoardsSearchViewModelOutput { get }
}

final class BoardsSearchViewModel : BoardsSearchViewModelProtocol, BoardsSearchViewModelInputs, BoardsSearchViewModelOutput {
    var inputs: BoardsSearchViewModelInputs  { return self }
    var outputs: BoardsSearchViewModelOutput  { return self }
    
    // Mark: - Inputs
    var fetchRecentHistory = PublishSubject<Void>()
    var update = PublishSubject<String>()
    var select = PublishSubject<BoardsSearchCellModel>()
    var delete = PublishSubject<(Int, BoardsSearchCellModel)>()
    
    // Mark: - Outputs
    var items = BehaviorRelay<[BoardsSearchCellModel]>(value: []).asDriver()
    var selected = PublishRelay<BoardsSearchCellModel>().asSignal()
    var hasPosts = BehaviorRelay<Bool>(value: false)
    
    private let networkService : NetworkService
    private let localService : LocalService?
    private let disposeBag = DisposeBag()
    init(_ networkService : NetworkService = NetworkService.shared, _ localService : LocalService? = LocalService.shared) {
        self.networkService = networkService
        self.localService = localService
        
        let historyDatas = BehaviorRelay<[History]>(value: [])
        let keyword =  BehaviorRelay<String>(value: "")
        let items = BehaviorRelay<[BoardsSearchCellModel]>(value: [])
        self.items = items.asDriver()
        let selected = PublishRelay<BoardsSearchCellModel>()
        self.selected = selected.asSignal()
        let hasPosts = BehaviorRelay<Bool>(value: false)
        self.hasPosts = hasPosts
        
        inputs.fetchRecentHistory
            .flatMapLatest({ [weak self] _ -> Observable<[History]> in
                if let result = self?.localService?.readData() {
                    return Observable.just(result)
                }
                return Observable.empty()
            })
            .subscribe(onNext: {
                historyDatas.accept($0)
            }).disposed(by: disposeBag)
        
        inputs.update
            .bind(to: keyword)
            .disposed(by: disposeBag)
        
        inputs.select
            .subscribe(onNext: { [weak self] cellmodel in
                let date = Date().yyyMMddHHmmss()
                self?.localService?.insert(category: cellmodel.category, keyword: cellmodel.keyword, date: date)
                selected.accept(cellmodel)
            })
            .disposed(by: disposeBag)
        
        inputs.delete
            .subscribe(onNext: { [weak self] (index, cellmodel) in
                self?.localService?.deleteData(id: cellmodel.history!.id)
                var items = historyDatas.value
                items.remove(at: index)
                historyDatas.accept(items)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(historyDatas, keyword,
                                 resultSelector: { [weak self] historyDatas, keyword -> [BoardsSearchCellModel] in
            guard let self = self else { return [] }
            if keyword != "" {
                let keywordModel = self.makeKeywordModel(keyword: keyword)
                return keywordModel
            }
            return historyDatas.map { BoardsSearchCellModel(history: $0) }
        })
        .subscribe(onNext: { cellitems in
            items.accept(cellitems)
            hasPosts.accept(!cellitems.isEmpty)
        })
        .disposed(by: disposeBag)
        
    }
    
    func makeKeywordModel(keyword: String) -> [BoardsSearchCellModel]{
        return [
            BoardsSearchCellModel(category: "전체", keyword: keyword),
            BoardsSearchCellModel(category: "제목", keyword: keyword),
            BoardsSearchCellModel(category: "내용", keyword: keyword),
            BoardsSearchCellModel(category: "작성자", keyword: keyword)
        ]
    }
    
}

