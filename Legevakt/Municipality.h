//
//  Municipality.h
//  Legevakt
//
//  Created by Tom Erik Støwer on 4/7/13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class Municipality;

@protocol MunicipalityDelegate

- (void)foundMunicipality:(Municipality *)municipality;
- (void)foundMunicipalities:(NSArray *)municipalities;

@end

@interface Municipality : PFObject <PFSubclassing>

@property (nonatomic,retain) NSString *municipalityName;

#pragma mark Class Methods
+ (NSString *)parseClassName;
+ (void)findMunicipalityWithCode:(NSString *)code withDelegate:(id<MunicipalityDelegate>)delegate;
+ (void)findMunicipalitiesWithCodes:(NSArray *)code withDelegate:(id<MunicipalityDelegate>)delegate;
+ (NSString *)formattedMunicipalities:(NSArray *)municipalities;

@end
