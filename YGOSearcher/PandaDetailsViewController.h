//
//  PandaDetailsViewController.h
//  YGOSearcher
//
//  Created by Xin Peter on 14-1-7.
//  Copyright (c) 2014年 IamI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface PandaDetailsViewController : UITabBarController
@property (nonatomic, readwrite) int targetId;
@property (nonatomic, readwrite) sqlite3 *sql;
@end
