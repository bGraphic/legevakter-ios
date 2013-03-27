//
//  OpeningHours.m
//  Legevakt
//
//  Created by Tom Erik Støwer on 3/27/13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "OpeningHours.h"
#import "OpeningInterval.h"

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
    NSMutableArray *intervals;
    
//    [components enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        OpeningInterval *interval = [[OpeningInterval alloc] initWithInterval:(NSString *)obj];
//        [intervals addObject:interval];
//    }];
    
    for (id component in components) {
        OpeningInterval *interval = [[OpeningInterval alloc] initWithInterval:component];
        if (!intervals)
            intervals = [NSMutableArray arrayWithObject:interval];
        else
            [intervals addObject:interval];
    }
    
    NSLog(@"Åpningstider: %@",[OpeningInterval timeStringMergedIntervalFromIntervals:intervals]);

}


@end
