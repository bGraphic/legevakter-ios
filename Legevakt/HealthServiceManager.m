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

+ (void)searchWithString:(NSString *)searchString andBlock:(void (^)(NSArray *searchStringInNameHealthServices,
                                                                        NSArray *searchStringInLocationNameHealthServices))completionBlock
{
    NSLog(@"Search for: %@", searchString);
    
    [PFCloud callFunctionInBackground:@"searchForHealthServicesWithString"
                       withParameters:@{@"searchString": searchString}
                                block:^(NSDictionary *result, NSError *error) {
                                    if (!error)
                                    {    
                                        NSArray *searchStringInNameHealthServices = [result objectForKey:@"searchStringInNameHealthServices"];
                                        NSArray *searchStringInLocationNameHealthServices = [result objectForKey:@"searchStringInLocationNameHealthServices"];
                                        
                                        NSLog(@"Found %d health services that matched: %@", searchStringInNameHealthServices.count, searchString);
                                        NSLog(@"Found %d locations that matched: %@", searchStringInLocationNameHealthServices.count, searchString);
                                        
                                        completionBlock([self makeHealthServicesCompliant:searchStringInNameHealthServices], [self makeHealthServicesSectionsCompliant:searchStringInLocationNameHealthServices]);
                                    }
                                    else
                                    {
                                        NSLog(@"Found no health services with search string: %@ because: %@", searchString, error);
                                        completionBlock(nil, nil);
                                    }
                                }];
}

+ (NSArray *) makeHealthServicesSectionsCompliant:(NSArray *) healthServicesSections
{
    [healthServicesSections enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSArray *healthServices = [obj valueForKey:@"healthServices"];
        NSArray *compliantHealthServices = [self makeHealthServicesCompliant:healthServices];
        [obj setValue:compliantHealthServices forKey:@"healthServices"];
    }];
    
    return healthServicesSections;
}

+ (NSArray *)makeHealthServicesCompliant:(NSArray *) healthServices
{
    NSMutableArray *compliantHealthServices = [[NSMutableArray alloc] init];
    
    [healthServices enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        HealthService *healthService = (HealthService *)[HealthService objectWithClassName:[HealthService parseClassName] dictionary:(NSDictionary *)obj];
        [compliantHealthServices addObject:healthService];
    }];
    
    return compliantHealthServices;
}
//
//+ (BOOL)healthService:(HealthService *)myHealthService isContainedInArray:(NSArray *)array
//{
//    BOOL answer = NO;
//    
//    for (HealthService *healthService in array) {
//        if ([healthService.displayName isEqualToString:myHealthService.displayName]) {
//            answer = YES;
//            break;
//        }
//    
//    }
//    
//    return answer;
//}

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
            NSLog(@"Found %d health locations near current location", objects.count);
            completionBlock(objects);
        }
        else
        {
            NSLog(@"Unable to find health loactions near current location because: %@", error);
            completionBlock(nil);
        }
    }];
}

@end
