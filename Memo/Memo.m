//
//  Memo.m
//  Memo
//
//  Created by Jeremy Tregunna on 12/23/2013.
//  Copyright (c) 2013 Nudge Apps. All rights reserved.
//

#import "Memo.h"

@interface Memo ()
@property (nonatomic) BOOL needsEvaluation;
@property (nonatomic, getter = isEvaluating) BOOL evaluating;
@property (nonatomic, readonly) id(^block)(id target, NSString* keyPath);
@end

@implementation Memo

+ (instancetype)memoWithTarget:(id)target block:(id (^)(id, NSString*))block
{
    return [[self alloc] initWithTarget:target block:block];
}

- (instancetype)initWithTarget:(id)target block:(id (^)(id, NSString*))block
{
    if((self = [super init]))
    {
        _target          = target;
        _block           = [block copy];
        _needsEvaluation = YES;
    }
    return self;
}

- (void)dealloc
{
    self.dependencies = nil;
}

#pragma mark - Dependencies

static void* MemoObservationContext = &MemoObservationContext;

- (void)setDependencies:(NSArray*)dependencies
{
    if(![_dependencies isEqual:dependencies])
    {
        [_dependencies enumerateObjectsUsingBlock:^(id<MemoDependent> obj, NSUInteger idx, BOOL* stop) {
            [obj removeObserver:self context:MemoObservationContext];
        }];

        [self willChangeValueForKey:@"dependencies"];
        _dependencies = [dependencies copy];
        [self didChangeValueForKey:@"dependencies"];

        [_dependencies enumerateObjectsUsingBlock:^(id<MemoDependent> obj, NSUInteger idx, BOOL* stop) {
            [obj addObserver:self context:MemoObservationContext];
        }];
    }
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    if(context == MemoObservationContext)
        [self invalidateWithKeyPath:keyPath];
    else
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark - Invalidation

- (void)invalidateWithKeyPath:(NSString*)keyPath
{
    self.needsEvaluation = YES;
    if(!_lazy)
        [self evaluateWithKeyPath:keyPath];
}

#pragma mark - Evaluation

@synthesize value = _value;

- (void)evaluateWithKeyPath:(NSString*)keyPath
{
    if(!self.evaluating && self.needsEvaluation)
    {
        self.evaluating      = YES;
        [self willChangeValueForKey:@"value"];
        _value               = self.block(self.target, keyPath);
        [self didChangeValueForKey:@"value"];

        self.needsEvaluation = (_value == nil);
        self.evaluating      = NO;
    }
}

- (id)value
{
    [self evaluateWithKeyPath:@"value"];
    return _value;
}

#pragma mark - NudgeMemoDependent

- (void)addObserver:(id)observer context:(void*)context
{
    [self addObserver:observer forKeyPath:@"value" options:0 context:context];
}

- (void)removeObserver:(id)observer context:(void*)context
{
    [self removeObserver:observer forKeyPath:@"value" context:context];
}

@end
