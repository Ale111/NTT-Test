//
//  ntt_testTests.m
//  ntt-testTests
//
//  Created by Alessandro Grigiante on 18/01/2020.
//  Copyright © 2020 ArsETmedia. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GitService.h"
#import "Stargazer.h"
#import "KeyChainService.h"


@interface ntt_testTests : XCTestCase

@end

@implementation ntt_testTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testKeyChainService {
    
    // Given
    NSString *mockText = @"This is my very very secret test to hide!";
    
    // When
    KeyChainService *sut = [[KeyChainService alloc] init];
    [sut saveSafeJson:[mockText dataUsingEncoding:NSUTF8StringEncoding] forKey:kAppSecKey];
    
    // Then
    XCTAssertTrue([mockText isEqualToString:[[NSString alloc] initWithData:[sut loadSafeJson:kAppSecKey] encoding:NSUTF8StringEncoding]]);

}

- (void)testKeyChainServiceEmpty {
    
    // Given
    NSString *mockText = @"This is my very very secret test to hide!";
    
    // When
    KeyChainService *sut = [[KeyChainService alloc] init];
    [sut deleteSafeJson:kAppSecKey];
    
    // Then
    XCTAssertFalse([mockText isEqualToString:[[NSString alloc] initWithData:[sut loadSafeJson:kAppSecKey] encoding:NSUTF8StringEncoding]]);
    
}

- (void)testGitServiceWithGetRepoStargazers {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"git Service"];
    
    // Given
    NSString *mockQuery = @"Alamofire/Alamofire";
    NSString *mockLogin = @"mattt";
    NSString *mockHtml = @"https://github.com/mattt";
    
    // When
    GitService *sut = [[GitService alloc] init];
    
    [sut getRepoStargazers:mockQuery completionBlock:^(BOOL isCompletion) {
        if (isCompletion) {
            
            Stargazer *sg = (Stargazer *) sut.usersArray[0];
    // Then
            XCTAssertEqual([sut.usersArray count], 30);
            XCTAssertTrue([sg.login isEqualToString:mockLogin]);
            XCTAssertTrue([sg.html_url isEqualToString:mockHtml]);
            
            [expectation fulfill];
        } else {
            XCTFail("Error occurred.");
        }
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        
    }];
    
}

@end
