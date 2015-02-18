//
//  AuthenticationTests.swift
//  StudentProjectInfotelTests
//
//  Created by Rebouh Aymen on 17/01/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

import UIKit
import XCTest
import StudentProjectInfotel

class AuthenticationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAuthenticationWithEmailSuccess() {
        
        let expectation = self.expectationWithDescription("Except authentication success")
        
        var email = "test@gmail.com"
        let password = "test"
                
        BeaconFacade.sharedInstance.authenticateUserWithEmail(email.encodeBase64(), password: password.md5()) { (jsonResponse, error) -> Void in
            
            // fulfill the exceptation
            expectation.fulfill()
        
            XCTAssertNil(error, "error should be nil but equal to \(error)")
            XCTAssertNotNil(jsonResponse?.dictionaryObject, "jsonResponse should not be nil")
            XCTAssertTrue(jsonResponse!.isOk(), "jsonResponse.isOk should return true")
            XCTAssertTrue(jsonResponse!.userExist(), "userExist should be true \(jsonResponse!)")
        }
            
        self.waitForExpectationsWithTimeout(30) { error in
            XCTAssertNil(error, "Timed out error \(error)")
        }
    }
    
    func testAuthenticationUserNotRegistred() {
        
        let expectation = self.expectationWithDescription("Except authentication user not registred")
        
        var email = "aymenmse@gmail.com"
        let password = "wrongPassword".md5()
        
        email = (email as NSString).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!.base64EncodedStringWithOptions(nil)
        
        BeaconFacade.sharedInstance.authenticateUserWithEmail(email, password: password) { (jsonResponse, error) -> Void in
            
            // fulfill the exceptation
            expectation.fulfill()
            
            XCTAssertNil(error, "error should be nil")
            XCTAssertNotNil(jsonResponse?.dictionaryObject, "jsonResponse should not be nil")
            XCTAssertTrue(jsonResponse!.isOk(), "jsonResponse.isOk should return true")
            XCTAssertFalse(jsonResponse!.userExist(), "userExist should not exist")
        }
        
        self.waitForExpectationsWithTimeout(30) { error in
            XCTAssertNil(error, "Timed out error \(error)")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
