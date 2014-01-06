//
//  Memo.h
//  Memo
//
//  Created by Jeremy Tregunna on 12/23/2013.
//  Copyright (c) 2013 Nudge Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MemoDependent <NSObject>
- (void)addObserver:(id)observer context:(void*)context;
- (void)removeObserver:(id)observer context:(void*)context;
@end

@interface Memo : NSObject <MemoDependent>
@property (nonatomic, readonly, strong) id       value;
@property (nonatomic, readonly, weak)   id       target;
@property (nonatomic, getter = isLazy)  BOOL     lazy;
@property (nonatomic, copy)             NSArray* dependencies;

+ (instancetype)memoWithTarget:(id)target block:(id (^)(id target, NSString*))block;

//- (id)init MemoDesignatedInitializer(initWithTarget:block:);
- (instancetype)initWithTarget:(id)target block:(id (^)(id target, NSString*))block;

- (void)invalidateWithKeyPath:(NSString*)keyPath;
- (void)evaluateWithKeyPath:(NSString*)keyPath;

@end
