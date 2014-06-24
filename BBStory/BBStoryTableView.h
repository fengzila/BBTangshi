//
//  BBDietView.h
//  BB
//
//  Created by FengZi on 14-1-14.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBStoryTableViewDelegate <NSObject>

- (void)pushInfoVCWithData:(NSArray*)data index:(int)index;
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end

@interface BBStoryTableView : UIView<UITableViewDelegate, UITableViewDataSource>
{
@private
    UITableView         *_tableView;
}

@property (nonatomic) NSArray* data;
@property (nonatomic) id <BBStoryTableViewDelegate> delegate;


- (id)initWithFrame:(CGRect)frame Data:(NSArray*)data;
- (void)reloadData:(NSArray*)data;
- (void)scrollToRowAtIndexPath:(int)row;

@end
