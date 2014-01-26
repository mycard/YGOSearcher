//
//  PandaDetailsViewController.m
//  YGOSearcher
//
//  Created by Xin Peter on 14-1-7.
//  Copyright (c) 2014年 IamI. All rights reserved.
//

#import "PandaDetailsViewController.h"
#import "PandaSummaryViewController.h"
#import "PandaImageViewController.h"
#import "PandaTranslator.h"
#import "sqlite3.h"

@interface PandaDetailsViewController ()
{
    sqlite3_stmt *getDesc;
    sqlite3_stmt *getParameter;
}
@end

@implementation PandaDetailsViewController
@synthesize targetId;
@synthesize sql;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self updateTexts];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateTexts
{
    PandaSummaryViewController *summaryView = (PandaSummaryViewController *) [self viewControllers][0];
    PandaImageViewController *imageView = (PandaImageViewController *)[self viewControllers][1];
    //UIView *faqView = (UIView *)[self viewControllers][2];
    
    if (getDesc == NULL) sqlite3_prepare_v2(sql, "select * from texts where id = ?", -1, &getDesc, nil);
    if (getParameter == NULL) sqlite3_prepare_v2(sql, "select * from datas where id = ?", -1, &getParameter, nil);
    sqlite3_reset(getDesc);
    sqlite3_reset(getParameter);
    sqlite3_bind_int(getDesc, 1, targetId);
    sqlite3_bind_int(getParameter, 1, targetId);
    sqlite3_step(getDesc);
    sqlite3_step(getParameter);
    const char* desc = (const char *)sqlite3_column_text(getDesc, 2);
    const char* name = (const char *)sqlite3_column_text(getDesc, 1);
    NSString *desc_str = [NSString stringWithUTF8String:desc];
    NSString *name_str = [NSString stringWithUTF8String:name];
    int type = sqlite3_column_int(getParameter, 4);
    int atk = sqlite3_column_int(getParameter, 5);
    int def = sqlite3_column_int(getParameter, 6);
    int level = sqlite3_column_int(getParameter, 7);
    int race = sqlite3_column_int(getParameter, 8);
    int attribute = sqlite3_column_int(getParameter, 9);
    NSMutableString *target = [NSMutableString stringWithString:@"卡片名称："];
    [target appendString: name_str];
    [target appendString: @"\n卡片种类："];
    [target appendString: [PandaTranslator getDescription:type]];
    [target appendString: @"\n八位密码："];
    [target appendString: [NSString stringWithFormat: @"%d", targetId]];
    if (type % 8 == 1)
    {
        [target appendString: @"\n等级："];
        [target appendString: [PandaTranslator getLevel:level type:type]];
        [target appendString: @"\n种族："];
        [target appendString: [PandaTranslator getRace: race]];
        [target appendString: @"\n属性："];
        [target appendString: [PandaTranslator getAttribute: attribute]];
        NSString *extra = [PandaTranslator getParameter: type];
        if ([extra length] != 0)
        {
            [target appendString: @"\n额外种类："];
            [target appendString: extra];
        }
        [target appendString: @"\n攻击力："];
        [target appendString: [PandaTranslator getNumber:atk]];
        [target appendString: @"\n防御力："];
        [target appendString: [PandaTranslator getNumber:def]];
        
    }
    [target appendString: @"\n叙述："];
    [target appendString: desc_str];
    summaryView.targetText = target;
    [summaryView updateText];
    
    imageView.targetId = targetId;
}
@end
