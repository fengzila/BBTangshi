//
//  BBCycleScrollView.h
//  BB
//
//  Created by FengZi on 13-12-25.
//  Copyright (c) 2013年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBCycleScrollView;
@protocol BBCycleScrollViewDelegate <NSObject>

@optional
- (void)didClickPage:(BBCycleScrollView *)csView atIndex:(NSInteger)index;
- (void)changePage;
@end

@protocol BBCycleScrollViewDatasource <NSObject>

@required
- (NSInteger)numberOfPages;
- (UIView *)pageAtIndex:(NSInteger)index;

@end

@interface BBCycleScrollView : UIView<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    
    id<BBCycleScrollViewDelegate> _delegate;
    id<BBCycleScrollViewDatasource> _datasource;
    
    NSInteger _totalPages;
    
    NSMutableArray *_curViews;
    NSTimer *_scrollTimer;
    
    int timerCount;
}

@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, readonly) UIPageControl *pageControl;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, setter = setDatasource:) id<BBCycleScrollViewDatasource> datasource;
@property (nonatomic, setter = setDelegate:) id<BBCycleScrollViewDelegate> delegate;

- (void)loadData;
- (void)reloadData;
- (void)reloadDataWithoutAnimation;
- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index;
- (void)roll;
- (void)stopRoll;
- (void)goTop;

@end

