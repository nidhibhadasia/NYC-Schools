//
//  SchoolDetailSwiftUIView.swift
//  20221025-NidhiBhadasia-NYCSchools
//
//  Created by Guest1 on 10/25/22.
//

import SwiftUI

struct SchoolDetailSwiftUIView: View {
    @Environment(\.openURL) var openURL
    
    let schoolModel: SchoolModel
    @State private var schoolDetailModel: SchoolDetailModel?
    @State private var showError = false
    @State private var isLoading = true
    
    private var appleMapURL: URL? {
        guard let urlAddress = schoolModel.fullAddress.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let mapURL = URL(string: String(format: Constant.API.appleMapURL, urlAddress)) else { return nil }
        return mapURL
    }
    
    private var phoneLink: URL? {
        URL(string: "tel:\(schoolModel.phoneNumber)")
    }
    
    private var emailLink: URL? {
        guard let email = schoolModel.email, let mailLink = URL(string: "mailto:\(email)") else { return nil }
        return mailLink
    }
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                schoolDetailView
                Spacer()
            }
        }
        .padding()
        .navigationBarTitle(Text("School Information"), displayMode: .inline)
        .onAppear{
            callAPISATDataForSelectedSchool(dbn: schoolModel.dbn)
        }
    }
    
    // MARK: - View Design
    private var schoolDetailView: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Load School Info View
            schoolInfoView
            if showError {
                Text(Constant.AlertMessage.noSATDataFound)
                    .foregroundColor(.red)
            } else {
                // Load SAT Score View
                scoreView
            }
        }
    }
    
    private var schoolInfoView: some View {
        Group {
            if let website = URL(string: "https://\(schoolModel.website)") {
                Link(destination: website) {
                    Text(schoolModel.schoolName)
                        .font(.title2)
                        .multilineTextAlignment(.leading)
                }
            } else {
                Text(schoolModel.schoolName)
                    .font(.title2)
                    .multilineTextAlignment(.leading)
            }
            if let mapURL = appleMapURL {
                Button {
                    openURL(mapURL)
                } label: {
                    Label(schoolModel.fullAddress, systemImage: "map")
                }
            }
            if let email = schoolModel.email, let mailLink = emailLink {
                Link(destination: mailLink) {
                    Label(email, systemImage: "mail")
                }
            }
            if let phoneLink = phoneLink {
                Link(destination: phoneLink) {
                    Label(schoolModel.phoneNumber, systemImage: "phone")
                }
            }
            Divider()
            Text(schoolModel.detail)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
        }
        .foregroundColor(.primary)
    }
    
    private var scoreView: some View {
        Group {
            if let testTakerNumber = schoolDetailModel?.testTakerNumber {
                Group {
                    Divider()
                    HStack {
                        Text("Avg Test Takers: \(testTakerNumber)")
                        Spacer()
                    }
                }
            }
            
            Divider()
            HStack(alignment: .top) {
                if let readingScore = schoolDetailModel?.readingScore {
                    Text("Reading\n\(readingScore)")
                        .frame(maxWidth: .infinity)
                }
                Divider()
                if let mathScore = schoolDetailModel?.mathScore {
                    Text("Math\n\(mathScore)")
                        .frame(maxWidth: .infinity)
                }
                Divider()
                if let writtenScore = schoolDetailModel?.writtenScore {
                    Text("Written\n\(writtenScore)")
                        .frame(maxWidth: .infinity)
                }
            }
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, maxHeight: 50)
            Divider()
        }
    }
    
    // MARK: - API call
    func callAPISATDataForSelectedSchool(dbn: String) {
        // call API to fetch school data
        NetworkManager.shared.fetchSATDataForSelectedSchool(dbn: dbn) {(schoolDetailModel, error) in
            self.isLoading = false;
            guard let schoolDetailModel = schoolDetailModel else {
                self.showError = true;
                return
            }
            self.schoolDetailModel = schoolDetailModel
        }
    }
}

struct SchoolDetailSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SchoolDetailSwiftUIView(schoolModel: .mocked)
    }
}
