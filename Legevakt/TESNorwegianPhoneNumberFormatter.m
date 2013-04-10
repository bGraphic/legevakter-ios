//
//  TESNorwegianPhoneNumberFormatter.m
//  Legevakt
//
//  Created by Tom Erik Støwer on 4/10/13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "TESNorwegianPhoneNumberFormatter.h"

#define NATIONAL_PREFIX @"+47"

@implementation TESNorwegianPhoneNumberFormatter

@synthesize useNationalPrefix = _useNationalPrefix;

- (BOOL)useNationalPrefix
{
    if (!_useNationalPrefix)
        _useNationalPrefix = NO;
    
    return _useNationalPrefix;
}

- (NSString *)stringForObjectValue:(NSString *)unformattedPhoneNumber
{
    unformattedPhoneNumber = [unformattedPhoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];

    // default format
    NSString *originalFormat = @"(\\d{2})(\\d{2})(\\d{2})(\\d{2})";
    NSString *newFormat = @"$1 $2 $3 $4";
    
    if ([self hasNationalPrefix:unformattedPhoneNumber]) {
        unformattedPhoneNumber = [unformattedPhoneNumber stringByReplacingOccurrencesOfString:@"+47" withString:@""];
    }
    
    if ([self isSpecialFiveDigitNumber:unformattedPhoneNumber]) {
        originalFormat = @"(\\d{5})";
        newFormat = @"$1";
    }
    else if ([self isSpecialEECHarmonizedNumber:unformattedPhoneNumber]) {
        originalFormat = @"(\\d{3})(\\d{3})";
        newFormat = @"$1 $2";
    }
    else if ([self isCellPhoneNumber:unformattedPhoneNumber]
        || [self isSpecialTollNumber:unformattedPhoneNumber]) {
        originalFormat = @"(\\d{3})(\\d{2})(\\d{3})";
        newFormat = @"$1 $2 $3";
    }

    NSString *formattedPhoneNumber = [self replace:unformattedPhoneNumber usingOriginalFormat:originalFormat andNewFormat:newFormat];
    
    if (self.useNationalPrefix)
        formattedPhoneNumber = [NSString stringWithFormat:@"%@ %@", NATIONAL_PREFIX, formattedPhoneNumber];
    
    return formattedPhoneNumber;
}

- (BOOL)hasNationalPrefix:(NSString *)phoneNumber
{
    BOOL hasNationalPrefix = NO;
    
    if ([phoneNumber hasPrefix:@"+47"])
        hasNationalPrefix = YES;
    
    return hasNationalPrefix;
}

- (BOOL)isSpecialFiveDigitNumber:(NSString *)phoneNumber
{
    BOOL isSpecialFiveDigitNumber = NO;
    
    if ([phoneNumber length] == 5
        && [phoneNumber hasPrefix:@"0"])
        isSpecialFiveDigitNumber = YES;
    
    return isSpecialFiveDigitNumber;
}

- (BOOL)isSpecialEECHarmonizedNumber:(NSString *)phoneNumber
{
    BOOL isSpecialEEC = NO;
    
    if ([phoneNumber length] == 6
        && [phoneNumber hasPrefix:@"116"])
        isSpecialEEC = YES;
    
    return isSpecialEEC;
}

- (BOOL)isCellPhoneNumber:(NSString *)phoneNumber
{
    BOOL isCellPhoneNumber = NO;

    if ([phoneNumber length] == 8
        && ([phoneNumber hasPrefix:@"4"] || [phoneNumber hasPrefix:@"9"]))
        isCellPhoneNumber = YES;
         
    return isCellPhoneNumber;
}

- (BOOL)isSpecialTollNumber:(NSString *)phoneNumber
{
    BOOL isSpecialTollNumber = NO;
    
    if ([phoneNumber length] == 8
        && [phoneNumber hasPrefix:@"8"])
        isSpecialTollNumber = YES;
    
    return isSpecialTollNumber;
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
