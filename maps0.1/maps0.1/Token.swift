//
//  Token.swift
//  maps0.1
//
//  Created by Matthew Gabrin on 2/24/20.
//  Copyright © 2020 Prateek Bhatt. All rights reserved.
//

//
//  Token.swift
//  gateguard
//
//  Created by Sławek Peszke on 05/12/2017.
//  Copyright © 2017 inFullMobile. All rights reserved.
//

import Foundation

struct Token: Decodable {
    let id: Int
    let uuid: UUID
}

// MARK: Extensions

extension Token {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case uuid = "token"
    }
}
