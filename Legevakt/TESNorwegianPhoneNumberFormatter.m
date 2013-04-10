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
    unformattedPhoneNumber = [unformattedPhoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];

    // default format
    NSString *originalFormat = @"(\\d{2})(\\d{2})(\\d{2})(\\d{2})";
    NSString *newFormat = @"$1 $2 $3 $4";
    
    // is cell phone number
    if ([unformattedPhoneNumber hasPrefix:@"9"]) {
        originalFormat = @"(\\d{3})(\\d{2})(\\d{3})";
        newFormat = @"$1 $2 $3";
    }

    NSString *formattedPhoneNumber = [self replace:unformattedPhoneNumber usingOriginalFormat:originalFormat andNewFormat:newFormat];
    
    return formattedPhoneNumber;
}

- (NSString *)replace:(NSString *)string usingOriginalFormat:(NSString *)originalFormat andNewFormat:(NSString *)newFormat
{
    return [string stringByReplacingOccurrencesOfString:originalFormat
                                             withString:newFormat
                                                options:NSRegularExpressionSearch
                                                  range:NSMakeRange(0, [string length])];
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
