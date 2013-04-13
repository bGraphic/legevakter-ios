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
    [HealthServiceManager universalSearchWithString:searchString andBlock:^(NSArray *searchStringInNameHealthServices, NSDictionary *searchStringInLocationNameHealthServices) {
        completionBlock(searchStringInNameHealthServices);
    }];
}

+ (void)universalSearchWithString:(NSString *)searchString andBlock:(void (^)(NSArray *searchStringInNameHealthServices,
                                                                        NSDictionary *searchStringInLocationNameHealthServices))completionBlock
{
    [PFCloud callFunctionInBackground:@"universalSearchForHealthServices"
                       withParameters:@{@"searchString": searchString}
                                block:^(NSDictionary *result, NSError *error) {
                                    if (!error) {
                                        NSArray *searchStringInNameHealthServices = [self makeHealthServicesCompliant:[result objectForKey:@"searchStringInNameHealthServices"]];
                                        NSDictionary *searchStringInLocationNameHealthServices = [self makeHealthServicesDictionaryCompliant:[result objectForKey:@"searchStringInLocationNameHealthServices"]];
                                        completionBlock(searchStringInNameHealthServices, searchStringInLocationNameHealthServices);
                                    } else {
                                        NSLog(@"error: %@", error);
                                    }
                                }];
}

+ (NSDictionary *)makeHealthServicesDictionaryCompliant:(NSDictionary *)healthServicesDict
{
    NSMutableDictionary *compliantHealthServicesDict = [[NSMutableDictionary alloc] init];
    
    [healthServicesDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSArray *healthServices = (NSArray *)obj;
        NSArray *compliantHealthServices = [self makeHealthServicesCompliant:healthServices];
        [compliantHealthServicesDict setObject:compliantHealthServices forKey:key];
    }];
    
    return compliantHealthServicesDict;
}

+ (NSArray *)makeHealthServicesCompliant:(NSArray *)healthServices
{
    NSMutableArray *compliantHealthServices = [[NSMutableArray alloc] init];
    
    [healthServices enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        HealthService *healthService = (HealthService *)[HealthService objectWithClassName:[HealthService parseClassName] dictionary:(NSDictionary *)obj];
        [compliantHealthServices addObject:healthService];
    }];
    
    return compliantHealthServices;
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
