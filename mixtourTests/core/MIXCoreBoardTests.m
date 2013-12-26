//
//  MIXCoreBoardTest.m
//  mixtour
//
//  Created by Carsten Wenderdel on 2013-06-17.
//  Copyright (c) 2013 Carsten Wenderdel. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MIXCoreBoard.h"

@interface MIXCoreBoardTest : XCTestCase

@end

@implementation MIXCoreBoardTest


- (void)testSize {
    struct MIXCoreBoard testStruct;
    XCTAssertEqual((size_t)60, sizeof(testStruct), @"core board has not proper size");
}


@end
