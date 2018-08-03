//
//  Subject.swift
//  Žán
//
//  Created by Zdeněk Pazdera on 09.06.18.
//  Copyright © 2018 Zdeněk Pazdera. All rights reserved.
//

import Foundation

internal struct ListOfSubjectsDecoder: Decodable {
    let subjects: [Subject]
    
    enum CodingKeys: String, CodingKey {
        case subjects = "subjects"
    }
}

internal struct Subject: Decodable {
    let subject: String
    let id_subject: String
}

