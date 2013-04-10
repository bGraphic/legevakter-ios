//
//  Municipality.m
//  Legevakt
//
//  Created by Tom Erik Støwer on 4/7/13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "Municipality.h"

@implementation Municipality

@synthesize municipalityName = _municipalityName;


- (NSString *)municipalityName
{
    if (!_municipalityName)
        _municipalityName = [self objectForKey:@"Norsk"];
    return _municipalityName;
}

+ (NSString *)parseClassName
{
    return @"Municipality";
}

+ (void)findMunicipalityWithCode:(NSString *)code withDelegate:(id<MunicipalityDelegate>)delegate
{
    PFQuery *query = [[PFQuery alloc] initWithClassName:@"Municipality"];
    [query whereKey:@"Kommunenummer" equalTo:[self compliantCodeFromCode:code]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && [objects count] > 0) {
            Municipality *municipality = (Municipality *)objects[0];
            [delegate foundMunicipality:municipality];
        }
        else
            NSLog(@"Unable to find municipality in findMunicipalityWithCode: %@", error);
    }];
}

+ (void)findMunicipalitiesWithCodes:(NSArray *)codes withDelegate:(id<MunicipalityDelegate>)delegate
{
    PFQuery *query = [[PFQuery alloc] initWithClassName:@"Municipality"];
    [query whereKey:@"Kommunenummer" containedIn:[self compliantCodesFromCodes:codes]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && [objects count] > 0) {
            [delegate foundMunicipalities:objects];
        }
        else
            NSLog(@"Unable to find municipalities in findMunicipalitiesWithCodes:%@", error);
    }];
}

+ (NSString *)compliantCodeFromCode:(NSString *)code
{
    return [NSString stringWithFormat:@"%d", [code intValue]];
}

+ (NSArray *)compliantCodesFromCodes:(NSArray *)codes
{
    NSMutableArray *compliantCodes = [[NSMutableArray alloc] init];
    
    for (id obj in codes) {
        [compliantCodes addObject:[self compliantCodeFromCode:(NSString *)obj]];
    }
    
    return compliantCodes;
}

+ (void)findMunicipalitiesWithSearchString:(NSString *)searchString delegate:(id<MunicipalityDelegate>)delegate
{
    PFQuery *query = [[PFQuery alloc] initWithClassName:@"Municipality"];
    [query whereKey:@"Norsk" containsString:searchString];
    [query setLimit:5];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [delegate foundMunicipalities:objects];
        }
    }];
}

+ (NSString *)formattedMunicipalities:(NSArray *)municipalities
{
    NSMutableString *formattedString = [[NSMutableString alloc] initWithString:@"Kommuner: "];
    
    for (id obj in municipalities) {
        Municipality *municipality = (Municipality *)obj;
        [formattedString appendString:[municipality municipalityName]];
     
        if (municipalities.count > 1
            && [municipalities indexOfObject:obj] == municipalities.count - 2)
            [formattedString appendString:@" og "];
        
        else if ([municipalities indexOfObject:obj] < municipalities.count - 1)
            [formattedString appendString:@", "];
    }
    
    return formattedString;
    
    
}

@end
