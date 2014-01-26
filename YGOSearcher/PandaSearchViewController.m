//
//  PandaSearchViewController.m
//  YGOSearcher
//
//  Created by Xin Peter on 13-12-31.
//  Copyright (c) 2013年 IamI. All rights reserved.
//

#import "PandaSearchViewController.h"
#import <sqlite3.h>
#import "PandaTranslator.h"
#import "PandaDetailsViewController.h"
#import "PandaHighSearchViewController.h"


@interface PandaSearchViewController ()
{
    bool isSearching;
    sqlite3 *sql;
    sqlite3_stmt *getName, *getParameter, *query;
}
@property (strong, nonatomic) IBOutlet UISearchBar *search;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSMutableArray *searchResults;
@end

@implementation PandaSearchViewController

@synthesize search;
@synthesize table;
@synthesize searchResults;

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
    
    isSearching = NO;
    self.search.delegate = self;
    self.table.delegate = self;
    self.table.dataSource = self;
    
    searchResults = [NSMutableArray arrayWithObjects: nil];
    
    [self checkUpdate];
    
    self.clearsSelectionOnViewWillAppear = NO;
    NSString *file = [[NSBundle bundleForClass:[self class]] pathForResource: @"cards" ofType: @"cdb"];
    if(sqlite3_open([file UTF8String], &sql) != SQLITE_OK)
        NSLog(@"Dkc you !");
    char* charForName = "select name from texts where id = ?";
    char* charForParamter = "select * from datas where id = ?";
    char* charForResearch = "select id from texts where name like ? or id like ? or `DESC` like ?";
    sqlite3_prepare_v2(sql, charForName, -1, &getName, NULL);
    sqlite3_prepare_v2(sql, charForParamter, -1, &getParameter, NULL);
    sqlite3_prepare_v2(sql, charForResearch, -1, &query, NULL);
    
}

- (void)viewDidUnload
{
    sqlite3_close(sql);
    [super viewDidUnload];
}

- (void) checkUpdate
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *path = (NSString *)[paths objectAtIndex:0];
    NSString *file = [path stringByAppendingPathComponent:@"cards.cdb"];
    NSString *now = [[NSBundle mainBundle] pathForResource: @"cards" ofType: @"cdb"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:file]) return;
    NSDate* newTime = [self getModificationTime: file];
    NSDate* oldTime = [self getModificationTime: now];
    if (oldTime >= newTime) return;
    UIAlertView *window = [[UIAlertView alloc] initWithTitle:@"更新提示" message:@"您的卡片数据库似乎更新了。要更新到本软件中么？" delegate:nil cancelButtonTitle:@"否" otherButtonTitles: nil];
    [window show];
}

- (NSDate *) getModificationTime: (NSString *)file
{
    NSDictionary *fileAttribute = [[NSFileManager defaultManager] attributesOfItemAtPath:file error:nil];
    NSDate *origin = fileAttribute[@"NSFileModificationDate"];
    return origin;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0)
    {
        isSearching = NO;
        if ([searchResults count] > 0)
        {
            [searchResults removeAllObjects];
            [table reloadData];
        }
        return;
    }
    isSearching = YES;
    char *sql_text = "select id from texts where name like ? or id like ? or `DESC` like ?";
    sqlite3_stmt *statement;
    NSString *target = @"%";
    target = [target stringByAppendingString: searchText];
    target = [target stringByAppendingString: @"%"];
    if (sqlite3_prepare_v2(sql, sql_text, -1, &statement, nil) == SQLITE_OK)
    {
        sqlite3_bind_text(statement, 1, [target UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 2, [target UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 3, [target UTF8String], -1, NULL);
    }
    [searchResults removeAllObjects];
    
    while (sqlite3_step(statement) == SQLITE_ROW)
        [searchResults addObject: [NSNumber numberWithInt: sqlite3_column_int(statement, 0)]];
        
    sqlite3_finalize(statement);
    [table reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    isSearching = NO;
    [searchBar resignFirstResponder];
    [searchResults removeAllObjects];
    [table reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int length = self.searchResults == NULL ? 0 : [self.searchResults count];
    return isSearching ? (length == 0 ? 1 : length) : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"normal";
    UITableViewCell *cell;
    if (isSearching)
    {
        if ([self.searchResults count] == 0)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            [cell textLabel].text = @"没有找到搜索结果....";
            [cell detailTextLabel].text = @"";
        }
        else
        {
            NSNumber *target = (NSNumber *)searchResults[[indexPath row]];
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
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [cell textLabel].text = @"进行搜索...";
        [cell detailTextLabel].text = @"";
    }
    return cell;
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
    if ([[segue destinationViewController] isKindOfClass:[PandaHighSearchViewController class]])
    {
        PandaHighSearchViewController* target = (PandaHighSearchViewController *)[segue destinationViewController];
        target.sql = sql;
        target.condition = [[PandaSearchCondition alloc] init];
        target.condition.key = search.text;
        return;
    }
    int targetIndex = [[table indexPathForSelectedRow] row];
    int targetId = [((NSNumber*)searchResults[targetIndex]) integerValue];
    target.targetId = targetId;
    target.sql = sql;
}


@end
