//
//  PandaHighSearchViewController.h
//  YGOSearcher
//
//  Created by Xin Peter on 14-1-23.
//  Copyright (c) 2014年 IamI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "PandaSearchCondition.h"

@interface PandaHighSearchViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic) sqlite3 *sql;
@property (strong, nonatomic) PandaSearchCondition *condition;
@end
