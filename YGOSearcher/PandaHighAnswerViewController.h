//
//  PandaHighAnswerViewController.h
//  YGOSearcher
//
//  Created by Xin Peter on 14-1-24.
//  Copyright (c) 2014年 IamI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface PandaHighAnswerViewController : UITableViewController
@property (strong, nonatomic) NSArray *searchResult;
@property (nonatomic) sqlite3 *sql;
@end
