//
//  MockParser.swift
//  SampleProject
//
//  Created by rayeon lee on 2024/01/10.
//

import Foundation

final class BoardsManager {
    // service code
    static let shared = BoardsManager()
    private init() {}
}

extension BoardsManager {
    func getBoardsMock() -> PostsResponseDTO {
        return MockParser.load(PostsResponseDTO.self, from: "Boards")!
    }
    
    func searchBoardsMock() -> PostsResponseDTO {
        return MockParser.load(PostsResponseDTO.self, from: "Search")!
    }
}

final class MockParser {
    static func load<D: Codable>(_ type: D.Type, from resourceName: String) -> D? {
        // type : 디코딩 할 때 사용되는 모델의 타입
        // resourceName : json 파일의 이름
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "json") else {
            return nil
        }
        // 확장자가 json인 파일의 경로를 가져오는 부분
        guard let jsonString = try? String(contentsOfFile: path) else {
            return nil
        }
        // 파일 안에 있는 데이터(json)을 String 형태로 가져온다
        print(jsonString)
        
        let decoder = JSONDecoder()
        let data = jsonString.data(using: .utf8)
        // string 형태로 가져온 json을 data형으로 변환
        print(data)
        
        guard let data = data else { return nil }
        return try? decoder.decode(type, from: data)
        // data를 swift 형태로 사용하기 위해 decoding하는 과정
    }
}
