//
//  OpeningHours.m
//  Legevakt
//
//  Created by Tom Erik Støwer on 3/27/13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "OpeningHours.h"
#import "OpeningInterval.h"

@interface OpeningHours() {
    NSMutableArray *intervals;
}
@end

@implementation OpeningHours

- (id)initWithOpeningHoursString:(NSString *)openingHoursString
{
    self = [super init];
    [self parseOpeningHoursFromString:openingHoursString];
    return self;
}

- (void)parseOpeningHoursFromString:(NSString *)string
{
    NSArray *components = [string componentsSeparatedByString:@","];
    
    for (id component in components) {
        OpeningInterval *interval = [[OpeningInterval alloc] initWithInterval:component];
        if (!intervals)
            intervals = [NSMutableArray arrayWithObject:interval];
        else
            [intervals addObject:interval];
    }
}

- (NSString *)openingHoursAsString
{
    return [OpeningInterval timeStringCombinedFromIntervals:intervals];
}

- (BOOL)isOpenWithDate:(NSDate *)date
{
    BOOL open = NO;
    
    for (id obj in intervals) {
        OpeningInterval *interval = (OpeningInterval *)obj;
        
        if ([interval dateIsInInterval:date])
            open = YES;
    }

    return open;
}

@end
