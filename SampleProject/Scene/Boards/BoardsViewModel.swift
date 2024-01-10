//
//  BoardsViewModel.swift
//  SampleProject
//
//  Created by rayeon lee on 2023/12/19.
//

import Foundation
import RxCocoa
import RxSwift

protocol BoardsViewModelInputs {
    var refresh : PublishSubject<Void> { get }
    var loadmore : PublishSubject<Void> { get }
}

protocol BoardsViewModelOutputs {
    var posts : Driver<[PostDTO]> { get }
    var hasPosts : BehaviorRelay<Bool> { get }
}

protocol BoardsViewModelProtocol {
    var inputs: BoardsViewModelInputs { get }
    var outputs: BoardsViewModelOutputs { get }
}

final class BoardsViewModel : BoardsViewModelProtocol, BoardsViewModelInputs, BoardsViewModelOutputs {
    var inputs: BoardsViewModelInputs  { return self }
    var outputs: BoardsViewModelOutputs  { return self }
    
    // Mark: - Inputs
    var refresh = PublishSubject<Void>()
    var loadmore = PublishSubject<Void>()
    private var page = 0
    
    // Mark: - Outputs
    var posts = BehaviorRelay<[PostDTO]>(value: []).asDriver()
    var hasPosts = BehaviorRelay<Bool>(value: false)
    
    private var networkService : NetworkService
    private let disposeBag = DisposeBag()
    init(_ networkService: NetworkService = NetworkService.shared) {
        self.networkService = networkService
        
        let posts = BehaviorRelay<[PostDTO]>(value: [])
        self.posts = posts.asDriver()
        
        let hasPosts = BehaviorRelay<Bool>(value: false)
        self.hasPosts = hasPosts
        
        inputs.refresh
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .flatMapLatest({ _ -> Observable<PostsResponseDTO> in
                //                let router = PostHttpRouter.posts(id: 28478, offset: 0)
                //                return networkService.request(router, responseType: PostsResponseDTO.self)
                
                let sample = BoardsManager.shared.getBoardsMock()
                return Observable.just(sample)
                
            })
            .subscribe(onNext: { [weak self] (result) in
                guard let self = self else { return }
                posts.accept(result.value)
                self.page = 1
                hasPosts.accept(!result.value.isEmpty)
            }).disposed(by: disposeBag)
        
        inputs.loadmore
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .flatMapLatest({ [weak self] _ -> Observable<PostsResponseDTO> in
//                guard let self = self else { return Observable.empty() }
//                let router = PostHttpRouter.posts(id: 28478, offset: self.page)
//                return networkService.request(router, responseType: PostsResponseDTO.self)
                
                let sample = BoardsManager.shared.getBoardsMock()
                return Observable.just(sample)
                
            })
            .subscribe(onNext: { [weak self] (result) in
                guard let self = self else { return }
                posts.accept(posts.value + result.value)
                self.page = self.page + 1
                
            }).disposed(by: disposeBag)
        
        
    }
    
    
}
