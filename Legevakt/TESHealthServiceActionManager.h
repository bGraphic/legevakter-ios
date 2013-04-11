//
//  TESLegevaktActionManager.h
//  Legevakt
//
//  Created by Benedicte Raae on 09.04.13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TESHealthServiceActionManager : NSObject

+ (BOOL) placeCallTo:(NSString *)number;
+ (BOOL) openWebPage:(NSString *) webPageStringUrl;

@end
