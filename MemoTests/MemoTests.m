//
//  MemoTests.m
//  MemoTests
//
//  Created by Jeremy Tregunna on 12/23/2013.
//  Copyright (c) 2013 Nudge Apps. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Memo.h"
#import "MemoObservationTarget.h"

@interface MemoTestThing : NSObject
@property (nonatomic, copy) NSSet* changes;
@end
@implementation MemoTestThing
@end

@interface MemoTests : XCTestCase
@property (nonatomic, strong) Memo* m1;
@property (nonatomic, strong) Memo* m2;
@property (nonatomic, strong) MemoTestThing* testSet;
@end

@implementation MemoTests

- (void)setUp
{
    [super setUp];
    
    self.testSet = [[MemoTestThing alloc] init];
    self.testSet.changes = [NSSet set];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
    
    self.m1 = nil;
    self.m2 = nil;
    self.testSet = nil;
}

- (void)testTrigger
{
    __block BOOL returnEarly = NO;

    self.m1 = [Memo memoWithTarget:self block:^id (id target, NSString* keyPath) {
        return self.testSet;
    }];
    self.m1.lazy = YES;

    self.m2 = [Memo memoWithTarget:self block:^id (id target, NSString* keyPath) {
        NSSet* changes = self.collection.changes;
        if(changes && [changes count] > 0)
        {
            XCTAssertEqualObjects([changes anyObject], @1, @"Must carry the changes to the testSet");
        }
        else
            XCTFail(@"Must be more than 0 changes");
        XCTAssertEqualObjects(self, target, @"Target must be the same one passed in");

        returnEarly = YES;

        return changes;
    }];
    [self.m2 setDependencies:@[[MemoObservationTarget targetWithObject:self.m1 keyPath:@"value.changes"]]];

    self.testSet.changes = [NSSet setWithObjects:@1, nil];

    if(returnEarly)
        return;

    XCTFail(@"Must call m2's block.");
}

- (MemoTestThing*)collection
{
    return self.m1.value;
}

@end
