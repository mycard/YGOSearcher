//
//  PandaAdvanceTypeViewController.h
//  YGOSearcher
//
//  Created by Xin Peter on 14-1-23.
//  Copyright (c) 2014年 IamI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PandaSearchCondition.h"

@interface PandaAdvanceTypeViewController : UIViewController
@property (weak, nonatomic) PandaSearchCondition *condition;
@property (weak, nonatomic) NSDictionary *setting;
@end
