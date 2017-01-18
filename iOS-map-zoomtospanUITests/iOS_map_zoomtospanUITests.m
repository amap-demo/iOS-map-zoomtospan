//
//  iOS_map_zoomtospanUITests.m
//  iOS-map-zoomtospanUITests
//
//  Created by 翁乐 on 18/01/2017.
//  Copyright © 2017 Amap. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface iOS_map_zoomtospanUITests : XCTestCase

@end

@implementation iOS_map_zoomtospanUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    XCUIElement *element = [[[[[[XCUIApplication alloc] init].otherElements containingType:XCUIElementTypeButton identifier:@"\u7f29\u653e\u5730\u56fe\uff08\u4e2d\u5fc3\u70b9\uff09"] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1];
    
    [element swipeUp];
    [element swipeUp];
    

    [app.buttons[@"\u7f29\u653e\u5730\u56fe\uff08\u4e2d\u5fc3\u70b9\uff09"] tap];
    [element swipeDown];
    [element swipeDown];
    [app.buttons[@"\u7f29\u653e\u5730\u56fe"] tap];
    
    sleep(2);
    
}

@end
