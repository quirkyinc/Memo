//
//  MemoObservationTargetTests.m
//  Memo
//
//  Created by Jeremy Tregunna on 12/23/2013.
//  Copyright (c) 2013 Nudge Apps. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MemoObservationTarget.h"

static void* MemoObservationTargetTestsContext = &MemoObservationTargetTestsContext;

@interface MemoObservationTargetTests : XCTestCase
@property (nonatomic) BOOL trying;
@property (nonatomic) BOOL tested;
@end

@implementation MemoObservationTargetTests

- (void)setUp
{
    [super setUp];

    _trying = NO;
    _tested = NO;
}

- (void)testFiringObserver
{
    MemoObservationTarget* t = [MemoObservationTarget targetWithObject:self keyPath:@"trying"];
    [t addObserver:self context:MemoObservationTargetTestsContext];
    self.trying = YES;
    XCTAssertTrue(self.tested, @"Must have been set");
    [t removeObserver:self context:MemoObservationTargetTestsContext];
}

#pragma mark - Private utility methods

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    if(context == MemoObservationTargetTestsContext)
        _tested = YES;
    else
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

@end
