//
//  ResultViewModel.swift
//  SampleProject
//
//  Created by rayeon lee on 2023/12/23.
//

import Foundation
import RxSwift
import RxCocoa

protocol ResultViewModelInputs {
    var fetchQuery : PublishSubject<Void> { get }
}

protocol ResultViewModelOutputs {
    var posts : Driver<[PostDTO]> { get }
    var hasPosts : BehaviorRelay<Bool> { get }
    var searchString: String { get }
}

protocol ResultViewModelProtocol {
    var inputs: ResultViewModelInputs { get }
    var outputs: ResultViewModelOutputs { get }
}

final class ResultViewModel : ResultViewModelProtocol, ResultViewModelInputs, ResultViewModelOutputs {
    var inputs: ResultViewModelInputs  { return self }
    var outputs: ResultViewModelOutputs  { return self }
    
    var fetchQuery = PublishSubject<Void>()
    var posts = BehaviorRelay<[PostDTO]>(value: []).asDriver()
    var hasPosts = BehaviorRelay<Bool>(value: false)
    var searchString: String
    
    private var networkService : NetworkService
    private let disposeBag = DisposeBag()
    private let model: BoardsSearchCellModel
    init(with cellModel: BoardsSearchCellModel, _ networkService: NetworkService = NetworkService.shared) {
        self.networkService = networkService
        self.model = cellModel
        
        let posts = BehaviorRelay<[PostDTO]>(value: [])
        self.posts = posts.asDriver()
        let hasPosts = BehaviorRelay<Bool>(value: false)
        self.hasPosts = hasPosts
        self.searchString = "\(cellModel.category): \(cellModel.keyword)"
        
        inputs.fetchQuery
            .flatMapLatest({ () -> Observable<PostsResponseDTO> in
//                let router = PostHttpRouter.search(id: 28478, offset: 0, search: history.keyword, searchTarget: history.category)
//                return networkService.request(router, responseType: PostsResponseDTO.self)
//
                let sample = BoardsManager.shared.searchBoardsMock()
                return Observable.just(sample)
            })
            .subscribe(onNext: { (result) in
                posts.accept(result.value)
                hasPosts.accept(!result.value.isEmpty)
            })
            .disposed(by: disposeBag)
        
    }
    
}

