//
//  ListModel.swift
//  MKT-App
//
//  Created by Phincon on 25/12/21.
//

import Foundation

struct ListModel : Decodable {
    var userId : Int
    var id : Int
    var title : String
    var body : String
}
