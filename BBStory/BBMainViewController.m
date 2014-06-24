//
//  BBMainViewController.m
//  BBStory
//
//  Created by FengZi on 14-3-11.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import "BBSegmentedControl.h"
#import "BBStoryInfoViewController.h"
#import "BBMainViewController.h"
#import "BBNetworkService.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "BBCycleViewController.h"

@interface BBMainViewController ()

@end

@implementation BBMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = view;
    view.backgroundColor = kGray;
    
    int height = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        height = 20;
    }
    self.navigationController.delegate = self;
    [self.navigationController setNavigationBarHidden:YES animated:false];
    
    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0 + height, kDeviceWidth, 40)];
    mySearchBar.delegate = self;
    [mySearchBar setPlaceholder:@"搜索"];
    [self.view addSubview:mySearchBar];
    
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:mySearchBar contentsController:self];
    searchDisplayController.active = NO;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    
    _segTitleArr = @[@"全部", @"收藏"];
    BBSegmentedControl *segControl = [[BBSegmentedControl alloc] initWithSectionTitles:_segTitleArr];
    [segControl setFrame:CGRectMake(0, 40 + height, kDeviceWidth, 35)];
    segControl.backgroundColor = kGray;
    [segControl addTarget:self action:@selector(segContrllChange:) forControlEvents:UIControlEventValueChanged];
//    [segControl setTag:1];
    [self.view addSubview:segControl];
    
    _allData = [BBNetworkService storyList:@"list"];
//    _loveData = [BBNetworkService storyList:@"storyList"];
    
    
    [self initLoveListData];

    
    _allView = [[BBStoryTableView alloc] initWithFrame:CGRectMake(0, 75 + height, kDeviceWidth, kDeviceHeight - 35) Data:_allData];
    _allView.delegate = self;
    [self.view addSubview:_allView];
    
    _loveView = [[BBStoryTableView alloc] initWithFrame:CGRectMake(0, 75 + height, kDeviceWidth, kDeviceHeight - 35) Data:_loveData];
    _loveView.delegate = self;
    [self.view addSubview:_loveView];
    [_loveView setHidden:YES];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    int lastReadPage = (int)[ud integerForKey:@"lastReadPage"];
    [_allView scrollToRowAtIndexPath:lastReadPage];
}

- (void) initLoveListData
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *loveDic = [ud objectForKey:@"loveDic"];
    _loveData = [[NSMutableArray alloc] init];
    
    NSArray *keys = [loveDic allKeys];
    int i;
    id key;

    _loveDicCount = [keys count];

    for (i = 0; i < _loveDicCount; i++)
    {
        key = [keys objectAtIndex: i];
        [_loveData addObject:[_allData objectAtIndex:[key intValue]]];
        NSLog (@"Key: %@", key);
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self)
    {
//        // 只有主场景不显示导航条
//        [navigationController setNavigationBarHidden:YES animated:animated];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSDictionary *loveDic = [ud objectForKey:@"loveDic"];
        
        int count = [[loveDic allKeys] count];
        
        if (count != _loveDicCount) {
            [self initLoveListData];
            [_loveView reloadData:_loveData];
        }
        
        int lastReadPage = (int)[ud integerForKey:@"lastReadPage"];
        [_allView scrollToRowAtIndexPath:lastReadPage];
    }
    else if ([navigationController isNavigationBarHidden])
    {
//        [navigationController setNavigationBarHidden:NO animated:animated];
    }
}

- (void)segContrllChange:(BBSegmentedControl*)seg
{
    NSLog(@"Selected index %i (via UIControlEventValueChanged)", seg.selectedIndex);
    switch (seg.selectedIndex)
    {
        case 0:
            [_allView setHidden:NO];
            [_loveView setHidden:YES];
            self.navigationItem.backBarButtonItem.title = [_segTitleArr objectAtIndex:0];
            break;
            
        case 1:
            [_allView setHidden:YES];
            [_loveView setHidden:NO];
            self.navigationItem.backBarButtonItem.title = [_segTitleArr objectAtIndex:1];
            break;
            
        default:
            break;
    }
}

- (void)pushInfoVCWithData:(NSArray*)data index:(int)index
{
//    BBStoryInfoViewController *infoVC = [[BBStoryInfoViewController alloc] initWithData:data];
    
    BBCycleViewController *infoVC = [[BBCycleViewController alloc] initWithData:data index:index];
    
    [self.navigationController pushViewController:infoVC animated:YES];
}

#pragma UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    int index = [[searchResults objectAtIndex:indexPath.row] intValue];
    cell.textLabel.text = [[_allData objectAtIndex:index] objectForKey:@"title"];
    cell.detailTextLabel.text = [[_allData objectAtIndex:index] objectForKey:@"autor"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSUInteger index = indexPath.row;
    
    [self pushInfoVCWithData:_allData index:[[searchResults objectAtIndex:index] intValue]];
}

- (NSArray*)getDataArr:(NSArray*)data{
    NSMutableArray *retData = [[NSMutableArray alloc] init];
    for (int i = 0; i < data.count; i++) {
        NSDictionary *v = [data objectAtIndex:i];
        [retData addObject:[v objectForKey:@"title"]];
    }
    return retData;
}

#pragma UISearchDisplayDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    NSArray *data = _allData;
    
    searchResults = [[NSMutableArray alloc]init];
    if (mySearchBar.text.length>0 && ![ChineseInclude isIncludeChineseInString:mySearchBar.text]) {
        for (int i=0; i < data.count; i++) {
            NSString *title = [[data objectAtIndex:i] objectForKey:@"title"];
            if ([ChineseInclude isIncludeChineseInString:title]) {
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:title];
                NSRange titleResult=[tempPinYinStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:[[data objectAtIndex:i] objectForKey:@"id"]];
                    continue;
                }
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:title];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length>0) {
                    [searchResults addObject:[[data objectAtIndex:i] objectForKey:@"id"]];
                }
            }
            else {
                NSRange titleResult=[title rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:[[data objectAtIndex:i] objectForKey:@"id"]];
                }
            }
            
            NSString *author = [[data objectAtIndex:i] objectForKey:@"autor"];
            if ([ChineseInclude isIncludeChineseInString:author]) {
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:author];
                NSRange authorResult=[tempPinYinStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (authorResult.length>0) {
                    [searchResults addObject:[[data objectAtIndex:i] objectForKey:@"id"]];
                    continue;
                }
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:author];
                NSRange authorHeadResult=[tempPinYinHeadStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (authorHeadResult.length>0) {
                    [searchResults addObject:[[data objectAtIndex:i] objectForKey:@"id"]];
                }
            }
            else {
                NSRange authorResult=[title rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (authorResult.length>0) {
                    [searchResults addObject:[[data objectAtIndex:i] objectForKey:@"id"]];
                }
            }
        }
    } else if (mySearchBar.text.length>0&&[ChineseInclude isIncludeChineseInString:mySearchBar.text]) {
        for (int i=0; i < data.count; i++) {
            NSString *title = [[data objectAtIndex:i] objectForKey:@"title"];
            NSRange titleResult=[title rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
            if (titleResult.length>0) {
                [searchResults addObject:[[data objectAtIndex:i] objectForKey:@"id"]];
                continue;
            }
            
            NSString *author = [[data objectAtIndex:i] objectForKey:@"autor"];
            NSRange authorResult=[author rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
            if (authorResult.length>0) {
                [searchResults addObject:[[data objectAtIndex:i] objectForKey:@"id"]];
                continue;
            }
        }
    }
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    for(id cc in [searchBar subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
