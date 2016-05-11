//
//  Conference_AppTests.swift
//  Conference AppTests
//
//  Created by B4TH Administrator on 4/1/16.
//  Copyright © 2016 Chrystech Systems. All rights reserved.
//

import XCTest
@testable import Conference_App

class Conference_AppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testSaveNotification(){
        
        let notificationController = NotificationController()
        // let data = NSDictionary()
        //let date = NSDate()
        print("Test")
        // Creates a notification
        var notification = Notification(message: "This is a notification")
        notificationController.addNotification(notification)
        
        notification = Notification(message: "This is another notification")
        notificationController.addNotification(notification)
        
        let notifications = notificationController.getAllNotifications()
        
        XCTAssert(false, "Notifications are equal!")
        XCTFail()
        XCTAssertTrue(false)
    }
}
