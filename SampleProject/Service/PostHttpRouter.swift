//
//  PostRouter.swift
//  SampleProject
//
//  Created by rayeon lee on 2023/12/22.
//

import Foundation
import Alamofire

enum PostHttpRouter: HttpRouter {
    case posts(id:Int, offset:Int)
    case search(id:Int, offset:Int, search:String, searchTarget:String)
    
    var path: String {
        switch self {
        case .posts(let id, _):
            return "/\(id)/posts"
        case .search(let id, _, _, _):
            return "/\(id)/posts"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .posts(_, let offset):
            return nil
        case .search(_, let offset, let search, let searchTarget):
            return nil
        }
    }
}
