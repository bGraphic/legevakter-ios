//
//  TESNorwegianPhoneNumberFormatter.h
//  Legevakt
//
//  Created by Tom Erik Støwer on 4/10/13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TESNorwegianPhoneNumberFormatter : NSFormatter

@property (nonatomic) BOOL useNationalPrefix;

- (NSString *)stringForObjectValue:(NSString *)unformattedPhoneNumber;
- (BOOL)getObjectValue:(out __autoreleasing id *)obj forString:(NSString *)string errorDescription:(out NSString *__autoreleasing *)error;

@end
