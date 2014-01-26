//
//  PandaHighAnswerViewController.m
//  YGOSearcher
//
//  Created by Xin Peter on 14-1-24.
//  Copyright (c) 2014年 IamI. All rights reserved.
//

#import "PandaHighAnswerViewController.h"
#import "PandaTranslator.h"
#import "PandaDetailsViewController.h"

@interface PandaHighAnswerViewController ()
{
    sqlite3_stmt *getName, *getParameter, *query;
    IBOutlet UITableView *table;
}
//@property (strong, nonatomic) IBOutlet UINavigationItem *title;
@end

@implementation PandaHighAnswerViewController
@synthesize searchResult;
@synthesize sql;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    char* charForName = "select name from texts where id = ?";
    char* charForParamter = "select * from datas where id = ?";
    char* charForResearch = "select id from texts where name like ? or id like ? or `DESC` like ?";
    sqlite3_prepare_v2(sql, charForName, -1, &getName, NULL);
    sqlite3_prepare_v2(sql, charForParamter, -1, &getParameter, NULL);
    sqlite3_prepare_v2(sql, charForResearch, -1, &query, NULL);
    self.clearsSelectionOnViewWillAppear = NO;
    if (searchResult != nil)
        self.title = [NSString stringWithFormat:@"%d 个结果",[searchResult count]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int length = self.searchResult == NULL ? 0 : [self.searchResult count];
    return length == 0 ? 1 : length;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"normal";
    UITableViewCell *cell;
    if ([self.searchResult count] == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [cell textLabel].text = @"没有找到搜索结果....";
        [cell detailTextLabel].text = @"";
    }
    else
    {
        NSNumber *target = (NSNumber *)searchResult[[indexPath row]];
        int targetId = [target integerValue];
        sqlite3_reset(getName);
        sqlite3_reset(getParameter);
        sqlite3_bind_int(getName, 1, targetId);
        sqlite3_bind_int(getParameter, 1, targetId);
        sqlite3_step(getName);
        sqlite3_step(getParameter);
        const char *text = (const char *)sqlite3_column_text(getName, 0);
        NSString *name = [NSString stringWithUTF8String: text];
        int type = sqlite3_column_int(getParameter, 4);
        int atk = sqlite3_column_int(getParameter, 5);
        int def = sqlite3_column_int(getParameter, 6);
        int level = sqlite3_column_int(getParameter, 7);
        int race = sqlite3_column_int(getParameter, 8);
        int attribute = sqlite3_column_int(getParameter, 9);
        int clear_type = type % 8;
        if (clear_type == 1)
        {
            CellIdentifier = @"monster";
            cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
            NSMutableString* subtitle = [PandaTranslator getADescription:type];
            [subtitle appendString:[PandaTranslator getRace:race]];
            [subtitle appendString: @"/"];
            [subtitle appendString: [PandaTranslator getAttribute: attribute]];
            [subtitle appendString: @"/"];
            [subtitle appendString: [PandaTranslator getLevel:level type:type]];
            [subtitle appendString: @"/"];
            [subtitle appendString: [PandaTranslator getNumber: atk]];
            [subtitle appendString: @"/"];
            [subtitle appendString: [PandaTranslator getNumber: def]];
            cell.detailTextLabel.text = subtitle;
        }
        else
        {
            CellIdentifier = @"standard";
            cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
            [cell detailTextLabel].text = [PandaTranslator getADescription:type];
        }
        [cell textLabel].text = name;
    }
    return cell;
}
- (IBAction)UserSwipeRight:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PandaDetailsViewController* target = (PandaDetailsViewController *)[segue destinationViewController];
    int targetIndex = [[table indexPathForSelectedRow] row];
    int targetId = [((NSNumber*)searchResult[targetIndex]) integerValue];
    target.targetId = targetId;
    target.sql = sql;
}

@end
