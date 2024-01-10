//
//  HttpRouter.swift
//  SampleProject
//
//  Created by rayeon lee on 2023/12/22.
//

import Foundation
import Alamofire

protocol HttpRouter: URLRequestConvertible {
    var baseURL: String { get }
    var path: String { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    var method: HTTPMethod { get }
}

extension HttpRouter {
    var baseURL: String {
        return "https://test.com"
        
    }
    var method: HTTPMethod { return .get }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    func asURLRequest() throws -> URLRequest {
        var url = try baseURL.asURL()
        url.appendPathComponent(path)
        
        var request = try URLRequest(url: url, method: method, headers: headers)
        request = try URLEncoding.default.encode(request, with: parameters)
        return request
    }

}
