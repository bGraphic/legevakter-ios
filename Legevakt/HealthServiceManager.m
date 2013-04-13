//
//  HealthServiceManager.m
//  Legevakt
//
//  Created by Tom Erik Støwer on 3/27/13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "HealthServiceManager.h"
#import "HealthService.h"

@implementation HealthServiceManager

+ (void)searchWithString:(NSString *)searchString andBlock:(void (^)(NSArray *healthServices))completionBlock
{

    [PFCloud callFunctionInBackground:@"searchForHealthServices"
                       withParameters:@{@"searchString": searchString}
                                block:^(NSArray *healthServices, NSError *error) {
                                    if (!error) {
                                        NSArray *unifiedResults = [HealthServiceManager unifiedSearchResultFromSearchResults:healthServices];
                                        completionBlock(unifiedResults);
                                    } else {
                                        NSLog(@"error: %@", error);
                                    }
                                }];
}

+ (NSArray *)unifiedSearchResultFromSearchResults:(NSArray *)searchResults
{
    NSMutableArray *unifiedResults = [[NSMutableArray alloc] init];
    for (HealthService *healthService in searchResults) {
        if (![HealthServiceManager healthService:healthService isContainedInArray:unifiedResults]) {
            [unifiedResults addObject:healthService];
        }
    }
    return unifiedResults;
}

+ (BOOL)healthService:(HealthService *)myHealthService isContainedInArray:(NSArray *)array
{
    BOOL answer = NO;
    
    for (HealthService *healthService in array) {
        if ([healthService.displayName isEqualToString:myHealthService.displayName]) {
            answer = YES;
            break;
        }
    
    }
    
    return answer;
}

+ (void) findAllHealthServicesNearLocation:(CLLocation *)location withBlock:(void (^)(NSArray *healthServices))completionBlock
{
    [self findHealthServicesNearLocation:location withLimit:-1 andBlock:^(NSArray *healthServices) {

        PFQuery *query = [HealthService query];
        
        [query whereKey:@"geoPoint" equalTo:[NSNull null]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                NSLog(@"Found %d health locations with no geopoint", objects.count);
                completionBlock([healthServices arrayByAddingObjectsFromArray:objects]);
            }
            else
            {
                NSLog(@"Unable to find health loactions with no geopoint because: %@", error);
                completionBlock(healthServices);
            }
        }];
    }];
}

+ (void) findHealthServicesNearLocation:(CLLocation *)location withLimit:(int) limit andBlock:(void (^)(NSArray *healthServices))completionBlock;

{
    PFQuery *query = [HealthService query];
    
    if(limit > 0)
        query.limit = limit;
    else
        query.limit = 1000;
    
    [query whereKey:@"geoPoint" nearGeoPoint:[PFGeoPoint geoPointWithLocation:location]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Found %d health locations near location", objects.count);
            completionBlock(objects);
        }
        else
        {
            NSLog(@"Unable to find health loactions near location because: %@", error);
            completionBlock(nil);
        }
    }];
}

@end
