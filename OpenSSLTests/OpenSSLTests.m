//
//  OpenSSLTests.m
//  OpenSSLTests
//
//  Created by Piet Brauer on 05/07/15.
//  Copyright (c) 2015 nerdish by nature. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OpenSSL/OpenSSL.h>
#import "NSString+OpenSSL.h"

@interface OpenSSLTests : XCTestCase

@end

@implementation OpenSSLTests

- (void)testMD5 {
    XCTAssertEqualObjects([@"test string" md5], @"6f8db599de986fab7a21625b7916589c");
}

- (void)testSHA256 {
    XCTAssertEqualObjects([@"test string" sha256], @"d5579c46dfcc7f18207013e65b44e4cb4e2c2298f4ac457ba8f82743f31e930b");
}

- (void)testBase64 {
    XCTAssertEqualObjects([@"test string" base64EncodeWithNewlines:NO], @"dGVzdCBzdHJpbmc=");
}

- (void)testBase64WithNewLines {
    XCTAssertEqualObjects([@"test string" base64EncodeWithNewlines:YES], @"dGVzdCBzdHJpbmc=\n");
}

@end
