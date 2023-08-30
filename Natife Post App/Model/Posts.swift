//
//  Posts.swift
//  Natife Post App
//
//  Created by Ivan Behichev on 30.08.2023.
//

import Foundation

struct Post: Codable {
    let postId: Int
    let timeshamp: Int
    let title: String
    let previewText: String
    let likesCount: Int
}

struct Posts: Codable {
    let posts: [Post]
}
