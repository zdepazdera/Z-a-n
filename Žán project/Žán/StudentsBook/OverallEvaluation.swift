//
//  OverallEvaluation.swift
//  Žán
//
//  Created by Zdeněk Pazdera on 15.07.18.
//  Copyright © 2018 Zdeněk Pazdera. All rights reserved.
//

import Foundation

internal struct OverallEvaluationDecoder: Decodable {
    let evaluation: [OverallEvaluation]
    
    enum CodingKeys: String, CodingKey {
        case evaluation = "evaluation"
    }
}

internal struct OverallEvaluation: Decodable {
    let id_subject: String
    let subject: String
    let teacher: String
    let quarter_mark: String
    let semester_mark: String
}
