//
//  MemoObservationTarget.m
//  Memo
//
//  Created by Jeremy Tregunna on 12/23/2013.
//  Copyright (c) 2013 Nudge Apps. All rights reserved.
//

#import "MemoObservationTarget.h"

@interface MemoObservationTarget ()
@property (nonatomic, strong) id        object;
@property (nonatomic, copy)   NSString* keyPath;
@end

@implementation MemoObservationTarget

+ (instancetype)targetWithObject:(id)object selector:(SEL)selector
{
    return [self targetWithObject:object keyPath:NSStringFromSelector(selector)];
}

+ (instancetype)targetWithObject:(id)object keyPath:(NSString*)keyPath
{
    MemoObservationTarget* target = [[self alloc] init];
    target.object  = object;
    target.keyPath = [keyPath copy];
    return target;
}

#pragma mark - MemoObservation

- (void)addObserver:(id)observer context:(void*)context
{
    [self.object addObserver:observer forKeyPath:self.keyPath options:0 context:context];
}

- (void)removeObserver:(id)observer context:(void*)context
{
    [self.object removeObserver:observer forKeyPath:self.keyPath context:context];
}

#pragma mark - NSObject

- (BOOL)isEqualToObservationTarget:(MemoObservationTarget*)other
{
    return [other isKindOfClass:[MemoObservationTarget class]] && (other.object == self.object) && [other.keyPath isEqualToString:self.keyPath];
}

- (BOOL)isEqual:(id)object
{
    return [self isEqualToObservationTarget:object];
}

- (NSUInteger)hash
{
    return [self.object hash] ^ [self.keyPath hash];
}

@end
