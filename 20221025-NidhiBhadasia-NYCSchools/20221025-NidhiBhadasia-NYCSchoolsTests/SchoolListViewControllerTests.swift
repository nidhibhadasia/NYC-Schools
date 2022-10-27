//
//  SchoolListViewControllerTests.swift
//  20221025-NidhiBhadasia-NYCSchoolsTests
//
//  Created by Guest1 on 10/26/22.
//

import XCTest
@testable import _0221025_NidhiBhadasia_NYCSchools

class SchoolListViewControllerTests: XCTestCase {
    var schoolListVC: SchoolListViewController!
    let indexPath = IndexPath(row: 0, section: 0)
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: SchoolListViewController = storyboard.instantiateViewController(withIdentifier: "SchoolListViewController") as! SchoolListViewController
        self.schoolListVC = viewController
        self.schoolListVC.loadView()
        self.schoolListVC.arSchool = [.mocked]
    }
    
    func testViewDidLoad() {
        self.schoolListVC.viewDidLoad()
    }
    
    func testViewWillAppear() {
        self.schoolListVC.viewWillAppear(true)
    }
    
    func testVCHasIBOutlets() {
        XCTAssertNotNil(self.schoolListVC.tableView)
        XCTAssertNotNil(self.schoolListVC.spinner)
        XCTAssertNotNil(self.schoolListVC.refreshCntl)
    }
    
    func testTableViewProtocols() {
        XCTAssertNotNil(self.schoolListVC.tableView.dataSource)
        XCTAssertNotNil(self.schoolListVC.tableView.delegate)
    }
    
    func testTableViewConformsToTableViewDataSourceProtocol() {
        XCTAssertTrue(self.schoolListVC.conforms(to: UITableViewDataSource.self))
        XCTAssertTrue(self.schoolListVC.responds(to: #selector(self.schoolListVC.numberOfSections(in:))))
        XCTAssertTrue(self.schoolListVC.responds(to: #selector(self.schoolListVC.tableView(_:numberOfRowsInSection:))))
        XCTAssertTrue(self.schoolListVC.responds(to: #selector(self.schoolListVC.tableView(_:cellForRowAt:))))
    }
    func testTableViewConformsToTableViewDelegatProtocol() {
        XCTAssertTrue(self.schoolListVC.conforms(to: UITableViewDelegate.self))
        XCTAssertTrue(self.schoolListVC.responds(to: #selector(self.schoolListVC.tableView(_:willDisplay:forRowAt:))))
    }
    
    func testTableViewCellHasReuseIdentifier() {
        let cell = self.schoolListVC.tableView.dequeueReusableCell(withIdentifier: "SchoolTableViewCell", for: indexPath)
        let actualReuseIdentifer = cell.reuseIdentifier
        let expectedReuseIdentifier = "SchoolTableViewCell"
        XCTAssertEqual(actualReuseIdentifer, expectedReuseIdentifier)
    }
    
    func testTableCellHasCorrectSchoolInfo() {
        //Test for cell 0
        let schoolModel = self.schoolListVC.arSchool[indexPath.row]
        let cell = self.schoolListVC.tableView(self.schoolListVC.tableView, cellForRowAt: indexPath)
        XCTAssertEqual(cell.textLabel?.text, schoolModel.schoolName)
        XCTAssertEqual(cell.detailTextLabel?.text, schoolModel.fullAddress)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.schoolListVC = nil
        super.tearDown()
    }
}
