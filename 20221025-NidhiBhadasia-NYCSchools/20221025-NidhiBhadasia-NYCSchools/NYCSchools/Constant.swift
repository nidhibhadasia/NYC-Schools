//
//  Constant.swift
//  20221025-NidhiBhadasia-NYCSchools
//
//  Created by Guest1 on 10/25/22.
//

import Foundation

struct Constant {
    
    static let AppName = "NYC Schools"
    
    static let AppToken = "eK5WPih49i9cLRdgMULCDYGmI"
    
    struct API {
        static let pagingLimit = 25
        static let schoolListURL =
        "https://data.cityofnewyork.us/resource/s3k6-pzi2.json?$select=dbn,school_name,overview_paragraph,website,school_email,primary_address_line_1,city,state_code,zip,phone_number&$order=school_name&$$app_token=\(AppToken)&$limit=\(pagingLimit)&$offset="
        static let schoolSATDataURL = "https://data.cityofnewyork.us/resource/f9bf-2cp4.json?&$$app_token=\(AppToken)&dbn="
        static var appleMapURL = "http://maps.apple.com/?address=%@"
    }
   
    struct AlertMessage {
        static let noSATDataFound = "* The SAT results are not available."
        static let loaded = "All NYC Schools are loaded."
        static let urlNotFound = "The requested URL cannot be found."
    }
}
