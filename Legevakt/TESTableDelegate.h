//
//  TESHealthServicesTableDelegate.h
//  Legevakt
//
//  Created by Benedicte Raae on 11.04.13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TESTableDelegate : NSObject <UITableViewDelegate>

@property (strong, nonatomic) UINavigationController *navigationController;

- (id) initWithNavigationController:(UINavigationController *) viewController;

@end
