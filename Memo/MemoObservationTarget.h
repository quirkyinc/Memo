//
//  MemoObservationTarget.h
//  Memo
//
//  Created by Jeremy Tregunna on 12/23/2013.
//  Copyright (c) 2013 Nudge Apps. All rights reserved.
//

#import "Memo.h"

@interface MemoObservationTarget : NSObject <MemoDependent>

+ (instancetype)targetWithObject:(id)object selector:(SEL)selector;
+ (instancetype)targetWithObject:(id)object keyPath:(NSString*)keyPath;

@end
