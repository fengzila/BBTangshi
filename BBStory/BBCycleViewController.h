//
//  BBCycleViewController.h
//  BBStory
//
//  Created by FengZi on 14-3-13.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBCycleScrollView.h"
#import "BBCycleScrollCell.h"
#import "GADBannerView.h"

@interface BBCycleViewController : UIViewController<BBCycleScrollViewDatasource, BBCycleScrollViewDelegate, BBCycleScrollCellDelegate>
{
@private
    NSArray*            _data;
    int                 _lastPosition;
    BOOL                _tabbarIsHidden;
    int                 _index;
    int                 _statusHeight;
    
    UIView              *_listView;
    BBCycleScrollView   *_csView;
    UIButton            *_loveBtn;
    UILabel             *_pageLabel;
    
    UIView              *_tabbarView;
    GADBannerView       *_adBannerView;
}
- (id)initWithData:(NSArray*)data index:(int)index;
@end
