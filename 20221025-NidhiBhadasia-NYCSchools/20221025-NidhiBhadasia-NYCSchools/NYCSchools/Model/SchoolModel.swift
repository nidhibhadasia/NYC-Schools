//
//  SchoolModel.swift
//  20221025-NidhiBhadasia-NYCSchools
//
//  Created by Guest1 on 10/25/22.
//

import Foundation

struct SchoolModel: Codable {
    let dbn: String
    let schoolName: String
    let address: String
    let detail: String
    let city: String
    let state: String
    let zip: String
    let website: String
    let email: String?
    let phoneNumber: String
    
    enum CodingKeys: String, CodingKey {
        case dbn
        case schoolName = "school_name"
        case address = "primary_address_line_1"
        case detail = "overview_paragraph"
        case city
        case state = "state_code"
        case zip
        case website
        case email = "school_email"
        case phoneNumber = "phone_number"
    }
    
    var fullAddress: String {
       return "\(self.address), \(self.city), \(self.state) \(self.zip)"
    }
}

extension SchoolModel {
    static var mocked: SchoolModel {
        return SchoolModel(
            dbn: "02M260",
            schoolName: "Epic High School",
            address: "400 Irving Ave",
            detail: "Epic High School detail",
            city: "Brooklyn",
            state: "NY",
            zip: "11133",
            website: "www.epic.com",
            email: "info@epic.com",
            phoneNumber: "123-222-3334"
        )
    }
}
