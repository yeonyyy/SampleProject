//
//  NetworkService.swift
//  SampleProject
//
//  Created by rayeon lee on 2023/12/22.
//

import Alamofire
import RxSwift
import RxCocoa

final class NetworkService {
    static let shared = NetworkService()
    private init() {}

    func request<T:Decodable>(_ router: URLRequestConvertible, responseType: T.Type)
    -> Observable<T> {
        return Observable<T>.create { emitter in
            let request = AF.request(router)
                .responseDecodable(of: T.self, completionHandler: { dataResponse in
                    switch dataResponse.result {
                    case .success(let value):
                        print("API Success")
                        emitter.onNext(value)
                    case .failure(let err):
                        print("API Failure \(err)")
                        emitter.onError(err)
                    }
                    emitter.onCompleted()
                })
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
