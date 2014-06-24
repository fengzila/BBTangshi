//
//  BBDietView.m
//  BB
//
//  Created by FengZi on 14-1-14.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import "BBStoryTableView.h"
#import "BBStoryInfoViewController.h"

@implementation BBStoryTableView

- (id)initWithFrame:(CGRect)frame Data:(NSArray*)data
{
    self = [super initWithFrame:frame];
    if (self) {
        self.data = data;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 60) style:UITableViewStylePlain];
//        _tableView.backgroundColor = kGray;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
//    {
//        return 2;
//    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section != 0)
    {
        return 0;
    }
    NSLog(@"count is %d", [self.data count]);
    return [self.data count];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 55;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section != 0)
//    {
//        return 55;
//    }
//    return 0;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    static NSString *CellWithIdentifier = @"localCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *data = [self.data objectAtIndex:row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"No.%d  %@", row+1, [data objectForKey:@"title"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [data objectForKey:@"autor"]];
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = (int)[indexPath row];
    [self.delegate pushInfoVCWithData:_data index:row];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [self.delegate scrollViewDidScroll:scrollView];
}

- (void)reloadData:(NSArray*)data
{
    _data = data;
    [_tableView reloadData];
}

- (void)scrollToRowAtIndexPath:(int)row
{
//    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]
//                         atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    NSIndexPath *firstPath = [NSIndexPath indexPathForRow:row inSection:0];
    [_tableView selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
