//
//  MIXCoreHelperTests.m
//  mixtour
//
//  Created by Carsten Wenderdel on 2013-06-20.
//  Copyright (c) 2013 Carsten Wenderdel. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MIXCoreHelper.h"

@interface MIXCoreHelperTests : XCTestCase

@end

@implementation MIXCoreHelperTests


- (void)testSignum
{
    XCTAssertEquals(signum(-3), -1, @"");
    XCTAssertEquals(signum(-1), -1, @"");
    XCTAssertEquals(signum(0), 0, @"");
    XCTAssertEquals(signum(1), 1, @"");
    XCTAssertEquals(signum(3), 1, @"");
}

@end
