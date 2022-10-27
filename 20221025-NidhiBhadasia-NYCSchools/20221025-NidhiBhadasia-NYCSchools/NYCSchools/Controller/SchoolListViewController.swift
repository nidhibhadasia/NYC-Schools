//
//  SchoolListViewController.swift
//  20221025-NidhiBhadasia-NYCSchools
//
//  Created by Guest1 on 10/25/22.
//

import UIKit
import SwiftUI

class SchoolListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let refreshCntl = UIRefreshControl()
    // lastElementIndex Flag to maintain API call by page
    var lastElementIndex = 0
    // TableView Datasource array
    var arSchool = [SchoolModel]() {
        didSet{
            DispatchQueue.main.async {
                // Reload table when array is set
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup view
        self.setupView()
        self.callNYCSchoolList()
        self.addRefreshControl()
    }
    
    // MARK: - Custom functions
    func setupView() {
        self.title = Constant.AppName
        // Set table view estimated row height for dynamic size
        self.tableView.estimatedRowHeight = 120;
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    func addRefreshControl() {
        // Add Refresh Control to Table view
        self.tableView.refreshControl = refreshCntl
        self.refreshCntl.addTarget(self, action: #selector(refreshSchoolData(_:)), for: .valueChanged)
    }
    
    func showSpinner() {
        // Show spinner
        self.spinner.isHidden = false
        self.spinner.startAnimating()
    }
    
    func hideSpinner() {
        DispatchQueue.main.async {
            // Hide spinner
            self.spinner.isHidden = true
            self.spinner.stopAnimating()
            self.refreshCntl.endRefreshing()
        }
    }
    
    func showAlertWithMessage(alertMessage:String)  {
        //Handling error scanario by showing alert message
        let alert = UIAlertController(title: Constant.AppName, message: alertMessage, preferredStyle:.alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func refreshSchoolData(_ sender: Any) {
        //Get fresh data from API
        self.arSchool.removeAll()
        self.callNYCSchoolList()
    }
    
    @IBSegueAction func showSwiftUIView(_ coder: NSCoder) -> UIViewController? {
        //Load SwiftUI View
        guard let row = tableView.indexPathForSelectedRow?.row else { return nil }
        let rootView = SchoolDetailSwiftUIView(schoolModel: arSchool[row])
        return UIHostingController(coder: coder, rootView: rootView)
    }
    
    // MARK: - API call
    func callNYCSchoolList() {
        // call API to fetch school data
        self.showSpinner()
        NetworkManager.shared.fetchNYCSchoolList(offset: self.arSchool.count) { [weak self] (arSchoolList, error) in
            guard let self = self else { return }
            self.hideSpinner()
            if let arSchoolList = arSchoolList {
                self.arSchool = self.arSchool + arSchoolList
                self.lastElementIndex = self.arSchool.count - 1;
            } else {
                DispatchQueue.main.async {
                    self.showAlertWithMessage(alertMessage: error ?? "Something went wrong. Plese try again")
                }
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arSchool.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SchoolTableViewCell", for: indexPath)
        // Configure the cell...
        let model = arSchool[indexPath.row]
        cell.textLabel?.text = model.schoolName
        cell.detailTextLabel?.text = model.fullAddress
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == lastElementIndex {
            callNYCSchoolList()
        }
    }
}
