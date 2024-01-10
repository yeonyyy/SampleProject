//
//  PostsResponseDTO.swift
//  SampleProject
//
//  Created by rayeon lee on 2023/12/19.
//

import Foundation

struct PostsResponseDTO:Codable {
    let value: [PostDTO]
    let count: Int
    let offset: Int
    let limit: Int
    let total: Int
}

struct PostDTO:Codable {
    var postId : Int
    var title : String
    var boardId : Int
    var boardDisplayName : String
    var writer : WriterDTO
    var contents: String
    var createdDateTime: String
    var viewCount : Int
    var postType : String
    var isNewPost : Bool
    var hasInlineImage : Bool
    var commentsCount : Int
    var attachmentsCount : Int
    var isAnonymous : Bool
    var isOwner : Bool
    var hasReply : Bool

}

struct WriterDTO:Codable{
    var displayName : String
    var emailAddress : String
}
