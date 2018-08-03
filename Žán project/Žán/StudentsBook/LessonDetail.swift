//
//  LessonDetail.swift
//  Žán
//
//  Created by Zdeněk Pazdera on 13.06.18.
//  Copyright © 2018 Zdeněk Pazdera. All rights reserved.
//

import Foundation

internal struct LessonDetailDecoder: Decodable {
    var lesson: LessonDetail
    
    enum CodingKeys: String, CodingKey {
        case lesson = "lesson"
    }
}

internal struct LessonDetail: Decodable {
    let subject: String
    let teachers: [String]
}
