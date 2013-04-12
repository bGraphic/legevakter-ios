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

@class Parse;

@protocol HealthServiceManagerDelegate

@optional
- (void)manager:(id)manager foundHealthServicesNearby:(NSArray *)healthServices;
- (void)manager:(id)manager foundHealthServicesFromSearch:(NSArray *)healthServices;

@end

@interface HealthServiceManager : NSObject <MunicipalityDelegate, HealthServiceManagerDelegate>

- (void)searchWithString:(NSString *)searchString delegate:(id)delegate;
+ (void)findHealthServicesNearLocation:(CLLocation *)location withDelegate:(id)delegate;

+ (void) findAllHealthServicesNearLocation:(CLLocation *)location withBlock:(void (^)(NSArray *healthServices))completionBlock;

+ (void)findHealthServicesNearLocation:(CLLocation *)location withLimit:(int) limit andBlock:(void (^)(NSArray *healthServices))completionBlock;



@end
