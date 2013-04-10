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
    
    NSString *originalFormat = @"(\\d{2})(\\d{2})(\\d{2})(\\d{2})";
    if ([formattedPhoneNumber length] == 9) {
        originalFormat = @"(\\d{2})(\\d{2}) (\\d{2})(\\d{2})";
    }
    
    formattedPhoneNumber = [self replace:formattedPhoneNumber usingOriginalFormat:originalFormat];
    
    return formattedPhoneNumber;
}

- (NSString *)replace:(NSString *)string usingOriginalFormat:(NSString *)originalFormat
{
    return [string stringByReplacingOccurrencesOfString:originalFormat
                                             withString:@"$1 $2 $3 $4"
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
