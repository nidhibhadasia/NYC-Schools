//
//  SchoolDetailModel.swift
//  20221025-NidhiBhadasia-NYCSchools
//
//  Created by Guest1 on 10/25/22.
//

import Foundation

struct SchoolDetailModel: Codable {
    let dbn: String
    let schoolName: String
    let testTakerNumber: String
    let writtenScore: String
    let readingScore: String
    let mathScore: String
    
    enum CodingKeys: String, CodingKey {
        case dbn
        case schoolName = "school_name"
        case testTakerNumber = "num_of_sat_test_takers"
        case writtenScore = "sat_writing_avg_score"
        case readingScore = "sat_critical_reading_avg_score"
        case mathScore = "sat_math_avg_score"
    }
}

extension SchoolDetailModel {
    static var mocked: SchoolDetailModel {
        return SchoolDetailModel(
            dbn: "02M260",
            schoolName: "Epic High School",
            testTakerNumber: "400",
            writtenScore: "200",
            readingScore: "100",
            mathScore: "50"
        )
    }
}
