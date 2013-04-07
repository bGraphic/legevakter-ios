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
    PFQuery *query = [Municipality query];
    
    NSLog(@"code: %@", code);
    
    // remove leading zero (if any)
    NSString *compliantCode = [NSString stringWithFormat:@"%d", [code intValue]];
    
    
    [query whereKey:@"Kommunenummer" equalTo:compliantCode];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && [objects count] > 0) {
            Municipality *municipality = (Municipality *)objects[0];
            [delegate foundMunicipality:municipality];
        }
        else
            NSLog(@"Unable to find municipality in findMunicipalityWithCode: %@", error);
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
