//
//  CommentModel.swift
//  MKT-App
//
//  Created by Phincon on 25/12/21.
//

import Foundation

struct CommentModel : Decodable {
    var postId : Int
    var id : Int
    var name : String
    var email : String
    var body : String
}
