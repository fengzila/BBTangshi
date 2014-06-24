//
//  BBMainViewController.h
//  BBStory
//
//  Created by FengZi on 14-3-11.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBStoryTableView.h"

@interface BBMainViewController : UIViewController<BBStoryTableViewDelegate, UINavigationControllerDelegate, UISearchBarDelegate, UITableViewDataSource,UITableViewDelegate>
{
@private
    BBStoryTableView          *_allView;
    BBStoryTableView          *_loveView;
    
    UISearchBar               *mySearchBar;
    UISearchDisplayController *searchDisplayController;
    
    NSInteger                 _lastPosition;
    BOOL                      _tabbarIsHidden;
    
    NSArray                   *_segTitleArr;
    NSMutableArray            *searchResults;
    NSArray                   *_allData;
    NSMutableArray            *_loveData;
    
    int                       _loveDicCount;
}

@end
