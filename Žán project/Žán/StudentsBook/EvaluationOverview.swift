//
//  EvaluationOverview.swift
//  Žán
//
//  Created by Zdeněk Pazdera on 03.08.18.
//  Copyright © 2018 Zdeněk Pazdera. All rights reserved.
//

import Foundation

internal struct EvaluationOverviewDecoder: Decodable {
    let evaluation: [EvaluationOverview]
    
    enum CodingKeys: String, CodingKey {
        case evaluation = "evaluation"
    }
}

internal struct EvaluationOverview: Decodable {
    let mark: String
    let subject: String
    let description: String
    let inserted: String
}
