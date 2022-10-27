//
//  NetworkManager.swift
//  20221025-NidhiBhadasia-NYCSchools
//
//  Created by Guest1 on 10/25/22.
//

import Foundation

class NetworkManager: NSObject {
    static let shared = NetworkManager()
    
    // MARK: - Initialization
    private override init() {
        // Created sigleton object
        // Private Initialization
    }
    
    // MARK: - API functions
    func fetchNYCSchoolList(
        offset: Int,
        completion: @escaping ([SchoolModel]?, String?) -> Void
    ){
        // Get API URL
        guard let url = URL(string: Constant.API.schoolListURL + String(offset)) else {
            completion(nil, Constant.AlertMessage.urlNotFound)
            return
        }
        // Fetch Data
        URLSession.shared.dataTask(with:url, completionHandler: {(data, response, error) -> Void in
            guard let dataResponse = data, error == nil else {
                completion(nil, error?.localizedDescription ?? "Response Error")
                return
            }
            do {
                //dataResponse received from a network request
                let decoder = JSONDecoder()
                //Decode JSON Response Data
                let arSchoolModel = try decoder.decode([SchoolModel].self, from: dataResponse)
                if arSchoolModel.count > 0 {
                    completion(arSchoolModel, nil)
                }else {
                    completion(nil, Constant.AlertMessage.loaded)
                }
            } catch let error {
                print(error)
            }
        }).resume()
    }
    
    func fetchSATDataForSelectedSchool(
        dbn: String,
        completion: @escaping (SchoolDetailModel?, String?) -> Void
    ){
        // Get API URL
        guard let url = URL(string: Constant.API.schoolSATDataURL+dbn) else {
            completion(nil, Constant.AlertMessage.urlNotFound)
            return
        }
        // Fetch Data
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data, error == nil else {
                completion(nil, error?.localizedDescription ?? "Response Error")
                return
            }
            do {
                //dataResponse received from a network request
                let decoder = JSONDecoder()
                //Decode JSON Response Data
                let schoolDetailModel = try decoder.decode([SchoolDetailModel].self, from: dataResponse)
                completion(schoolDetailModel.first, nil)
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
}



