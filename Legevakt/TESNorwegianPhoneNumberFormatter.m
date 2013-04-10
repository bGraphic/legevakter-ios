//
//  TESNorwegianPhoneNumberFormatter.m
//  Legevakt
//
//  Created by Tom Erik Støwer on 4/10/13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "TESNorwegianPhoneNumberFormatter.h"

@implementation TESNorwegianPhoneNumberFormatter

- (NSString *)stringForObjectValue:(NSString *)unformattedPhoneNumber
{
    NSString *formattedPhoneNumber = unformattedPhoneNumber;
    
    if ([unformattedPhoneNumber length] == 8) {

        formattedPhoneNumber = [unformattedPhoneNumber stringByReplacingOccurrencesOfString:@"(\\d{2})(\\d{2})(\\d{2})(\\d{2})"
                                                                                       withString:@"$1 $2 $3 $4"
                                                                                          options:NSRegularExpressionSearch
                                                                                            range:NSMakeRange(0, [unformattedPhoneNumber length])];
    }
    
    return formattedPhoneNumber;
}

- (BOOL)getObjectValue:(out __autoreleasing id *)obj forString:(NSString *)string errorDescription:(out NSString *__autoreleasing *)error
{
    BOOL returnValue = NO;
    
    if (obj) {
        *obj = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        returnValue = YES;
    }

    return returnValue;
}

@end
