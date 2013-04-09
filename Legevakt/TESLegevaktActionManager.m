//
//  TESLegevaktActionManager.m
//  Legevakt
//
//  Created by Benedicte Raae on 09.04.13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "TESLegevaktActionManager.h"

@implementation TESLegevaktActionManager

+ (BOOL) placeCallTo:(NSString *)number
{
#if DEBUG
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ringer" message:number delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
    
    return YES;
#endif
    
    NSString *urlString = [[NSString alloc] initWithFormat:@"tel:%@", number];
    
    if([self openURL:urlString])
    {
        NSLog(@"Called number: %@", number);
        return YES;
    }
    else
    {
        NSLog(@"Could not call number: %@", number);
        return NO;
    }
}

+ (BOOL) openWebPage:(NSString *) webPageStringUrl
{
    if([self openURL:webPageStringUrl])
    {
        NSLog(@"Opened webpage: %@", webPageStringUrl);
        return YES;
    }
    else
    {
        NSLog(@"Could not open webpage: %@", webPageStringUrl);
        return NO;
    }
}

+ (BOOL) openURL:(NSString *) urlString
{
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    if([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
        
        return YES;
    }
    else
    {
        return NO;
    }
}


@end
