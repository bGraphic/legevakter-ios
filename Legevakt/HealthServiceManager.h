//
//  HealthServiceManager.h
//  Legevakt
//
//  Created by Tom Erik Støwer on 3/27/13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Municipality.h"

@interface HealthServiceManager : NSObject

+ (void)searchWithString:(NSString *)searchString andBlock:(void (^)(NSArray *searchStringInNameHealthServices,
                                                                              NSDictionary *searchStringInLocationNameHealthServices))completionBlock;
+ (void)findAllHealthServicesNearLocation:(CLLocation *)location withBlock:(void (^)(NSArray *healthServices))completionBlock;
+ (void)findHealthServicesNearLocation:(CLLocation *)location withLimit:(int) limit andBlock:(void (^)(NSArray *healthServices))completionBlock;



@end
