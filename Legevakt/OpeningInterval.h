//
//  OpeningInterval.h
//  Legevakt
//
//  Created by Tom Erik Støwer on 3/27/13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpeningInterval : NSObject

- (id)initWithInterval:(NSString *)interval;
- (NSString *)description;

+ (NSString *)timeStringMergedIntervalFromIntervals:(NSArray *)intervals;

@end
