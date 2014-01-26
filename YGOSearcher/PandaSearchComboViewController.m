//
//  PandaSearchComboViewController.m
//  YGOSearcher
//
//  Created by Xin Peter on 14-1-22.
//  Copyright (c) 2014年 IamI. All rights reserved.
//

#import "PandaSearchComboViewController.h"
#import <sqlite3.h>
#import "PandaTranslator.h"
#import "PandaDetailsViewController.h"
#import "PandaSearchCondition.h"
#import "PandaAdvancedSearchViewController.h"

@interface PandaSearchComboViewController ()
{
    bool isSearching;
    sqlite3 *sql;
    sqlite3_stmt *getName, *getParameter, *query;
}
@property (strong, nonatomic) IBOutlet UISearchBar *search;
@property (strong, nonatomic) IBOutlet UIView *targetContainer;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSMutableArray *searchResults;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonType;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonDetail;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonValue;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonEffect;
@property (weak, nonatomic) PandaSearchCondition *condition;

@end

@implementation PandaSearchComboViewController

@synthesize search;
@synthesize targetContainer;
@synthesize table;
@synthesize searchResults;
@synthesize buttonValue;
@synthesize buttonType;
@synthesize buttonEffect;
@synthesize buttonDetail;
@synthesize condition;

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
    
    isSearching = NO;
    self.search.delegate = self;
    self.table.delegate = self;
    self.table.dataSource = self;
    self.navigationController.toolbarHidden = NO;
    self.targetContainer.hidden = YES;
    
    searchResults = [NSMutableArray arrayWithObjects: nil];
    
    NSString *file = [[NSBundle bundleForClass:[self class]] pathForResource: @"cards" ofType: @"cdb"];
    if(sqlite3_open([file UTF8String], &sql) != SQLITE_OK)
        NSLog(@"数据库初始化失败");
    char* charForName = "select name from texts where id = ?";
    char* charForParamter = "select * from datas where id = ?";
    char* charForResearch = "select id from texts where name like ? or id like ? or `DESC` like ?";
    sqlite3_prepare_v2(sql, charForName, -1, &getName, NULL);
    sqlite3_prepare_v2(sql, charForParamter, -1, &getParameter, NULL);
    sqlite3_prepare_v2(sql, charForResearch, -1, &query, NULL);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int length = self.searchResults == NULL ? 0 : [self.searchResults count];
    return isSearching ? (length == 0 ? 1 : length) : 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
// 现场搜索
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
    sqlite3_stmt *statement = query;
    NSString *target = @"%";
    target = [target stringByAppendingString: searchText];
    target = [target stringByAppendingString: @"%"];
    sqlite3_reset(statement);
    sqlite3_bind_text(statement, 1, [target UTF8String], -1, NULL);
    sqlite3_bind_text(statement, 2, [target UTF8String], -1, NULL);
    sqlite3_bind_text(statement, 3, [target UTF8String], -1, NULL);
    
    if (sqlite3_step(statement) !=  SQLITE_DONE)
        NSLog(@"搜索过程中似乎出现了问题");
    [searchResults removeAllObjects];
    
    while (sqlite3_step(statement) == SQLITE_ROW)
        [searchResults addObject: [NSNumber numberWithInt: sqlite3_column_int(statement, 0)]];
    
    [table reloadData];
}

// 载入
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

- (IBAction)typeClicked:(id)sender {
    NSArray* children = self.childViewControllers;
    PandaAdvancedSearchViewController* target =(PandaAdvancedSearchViewController *) children[0];
    targetContainer.hidden = !targetContainer.hidden;
    [target setType:1];
    
}
- (IBAction)detailClicked:(id)sender {
    NSArray* children = self.childViewControllers;
    PandaAdvancedSearchViewController* target =(PandaAdvancedSearchViewController *) children[0];
    targetContainer.hidden = !targetContainer.hidden;
    [target setType:2];
}
- (IBAction)valueClicked:(id)sender {
    NSArray* children = self.childViewControllers;
    PandaAdvancedSearchViewController* target =(PandaAdvancedSearchViewController *) children[0];
    targetContainer.hidden = !targetContainer.hidden;
    [target setType:3];
}
- (IBAction)effectClicked:(id)sender {
    NSArray* children = self.childViewControllers;
    PandaAdvancedSearchViewController* target =(PandaAdvancedSearchViewController *) children[0];
    targetContainer.hidden = !targetContainer.hidden;
    [target setType:4];
}

@end
