//
//  HealthServiceManager.h
//  Legevakt
//
//  Created by Tom Erik Støwer on 3/27/13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HealthServiceManagerDelegate

- (void)manager:(id)manager foundHealthServicesNearby:(NSArray *)healthServices;

@end

@interface HealthServiceManager : NSObject

+ (void)findHealthServicesNearLocation:(CLLocation *)location withDelegate:(id)delegate;

@end
