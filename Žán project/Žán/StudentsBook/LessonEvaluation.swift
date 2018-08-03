//
//  LessonEvaluation.swift
//  Žán
//
//  Created by Zdeněk Pazdera on 13.06.18.
//  Copyright © 2018 Zdeněk Pazdera. All rights reserved.
//

import Foundation

internal struct LessonEvaluationDecoder: Decodable {
    let evaluation: [Evaluation]
    
    enum CodingKeys: String, CodingKey {
        case evaluation = "evaluation"
    }
}

internal struct Evaluation: Decodable {
    let mark: String
    let subject: String
    let id_subject: String
    let description: String
    let inserted: String
}
