//
//  NASADailyPicTests.swift
//  NASADailyPicTests
//
//  Created by Raphael Araújo on 2018-04-12.
//  Copyright © 2018 Raphael Araújo. All rights reserved.
//

import XCTest
@testable import NASADailyPic

class NASADailyPicTests: XCTestCase {
    var dailyPictureViewModel: DailyPictureViewModel!
    override func setUp() {
        super.setUp()
        
        dailyPictureViewModel = DailyPictureViewModel()
    }
    
    override func tearDown() {
        dailyPictureViewModel = nil
        super.tearDown()
    }
    
    func testAPIClientIsNotNil() {
        XCTAssertNotNil(dailyPictureViewModel.apiClient, "APIClient wasn't properly initialized")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // Asynchronous test: success fast, failure slow
    func testPictureFetched() {
        let promise = expectation(description: "A valid image")
        
        dailyPictureViewModel.fetchPicture()

        dailyPictureViewModel.updatePicture = { () in
            if self.dailyPictureViewModel.pictureViewModel?.url == nil {
                XCTFail("The picture of the day couldn't be fetched")
            } else {
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
