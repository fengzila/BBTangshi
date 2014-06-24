//
//  BBCycleScrollView.m
//  BB
//
//  Created by FengZi on 13-12-25.
//  Copyright (c) 2013年 FengZi. All rights reserved.
//

#import "BBCycleScrollView.h"
#import "BBCycleScrollCell.h"

@implementation BBCycleScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        [self addSubview:_scrollView];
        
        CGRect rect = self.bounds;
        rect.origin.y = rect.size.height - 30;
        rect.size.height = 30;
        _pageControl = [[UIPageControl alloc] initWithFrame:rect];
        _pageControl.userInteractionEnabled = NO;
        
//        [self addSubview:_pageControl];
        
//        _curPage = [self validPageValue:-1];
    }
    return self;
}

- (void)setDatasource:(id<BBCycleScrollViewDatasource>)datasource
{
    _datasource = datasource;
    [self reloadDataWithoutAnimation];
}

- (void)reloadData
{
    _totalPages = [_datasource numberOfPages];
    _curPage = _totalPages - 1;
    if (_totalPages == 0)
    {
        return;
    }
    _pageControl.numberOfPages = _totalPages;
    [self loadData];
    
    [self roll];
}

- (void)reloadDataWithoutAnimation
{
    _totalPages = [_datasource numberOfPages];
    _curPage = 0;
    if (_totalPages == 0)
    {
        return;
    }
    _pageControl.numberOfPages = _totalPages;
    [self loadData];
}

- (void)loadData
{
    _pageControl.currentPage = _curPage;
    
    //从scrollView上移除所有的subview
    NSArray *subViews = [_scrollView subviews];
    if([subViews count] != 0)
    {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:_curPage];
    
    for (int i = 0; i < 3; i++)
    {
        UIView *v = [_curViews objectAtIndex:i];
        v.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTap:)];
        [v addGestureRecognizer:singleTap];
        v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
        [_scrollView addSubview:v];
    }
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
    
    [self.delegate changePage];
}

- (void)getDisplayImagesWithCurpage:(int)page
{
    
    int pre = [self validPageValue:_curPage-1];
    int last = [self validPageValue:_curPage+1];
    
    if (!_curViews)
    {
        _curViews = [[NSMutableArray alloc] init];
    }
    
    [_curViews removeAllObjects];
    
    [_curViews addObject:[_datasource pageAtIndex:pre]];
    [_curViews addObject:[_datasource pageAtIndex:page]];
    [_curViews addObject:[_datasource pageAtIndex:last]];
}

- (int)validPageValue:(NSInteger)value
{
    
    if(value == -1) value = _totalPages - 1;
    if(value == _totalPages) value = 0;
    
    return value;
    
}

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    
    if ([_delegate respondsToSelector:@selector(didClickPage:atIndex:)])
    {
        [_delegate didClickPage:self atIndex:_curPage];
    }
    
}

- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index
{
    if (index == _curPage)
    {
        [_curViews replaceObjectAtIndex:1 withObject:view];
        for (int i = 0; i < 3; i++)
        {
            UIView *v = [_curViews objectAtIndex:i];
            v.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleTap:)];
            [v addGestureRecognizer:singleTap];
            v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
            [_scrollView addSubview:v];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    int x = aScrollView.contentOffset.x;
    
    //往下翻一张
    if(x >= (2*self.frame.size.width))
    {
        _curPage = [self validPageValue:_curPage + 1];
        [self loadData];
    }
    
    //往上翻
    if(x <= 0)
    {
        _curPage = [self validPageValue:_curPage - 1];
        [self loadData];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
    
}

- (void)scrollTimer
{
    
    //    [UIView beginAnimations:nil context:nil];
    //    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    //    [UIView setAnimationDuration:0.5];
    //    [self setFrame:CGRectMake(self.frame.origin.x * 2, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
    //    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
    //    [UIView commitAnimations];
    
    [_scrollView setContentOffset:CGPointMake(self.frame.size.width + self.frame.size.width * 1, 0) animated:YES];
}

- (void)roll
{
    //    _scrollTimer = [NSTimer scheduledTimerWithTimeInterval:0.335 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
    
    //    CABasicAnimation *translation = [CABasicAnimation animationWithKeyPath:@"transform"];
    //    translation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //    translation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-M_PI_4, 0, 0, 100)];
    //
    //    translation.duration = 0.2;
    //    translation.repeatCount = 2;
    //    translation.autoreverses = YES;
    //
    //    [_scrollView.layer addAnimation:translation forKey:@"translation"];
    
//    [CATransaction begin];
//    
//    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    [CATransaction setDisableActions:YES];
//    
//    static NSString * const keyPath = @"position.y";
//    int i = 1;
//    NSUInteger howManyUnit = (i + 3) * 5 + 1 - 1;
//    CGFloat slideY = howManyUnit * (self.frame.size.height / 3);
//    CABasicAnimation *slideAnimation = [CABasicAnimation animationWithKeyPath:keyPath];
//    slideAnimation.fillMode = kCAFillModeForwards;
//    slideAnimation.duration = howManyUnit * 1;
//    slideAnimation.toValue = [NSNumber numberWithFloat:_scrollView.origin.y + slideY];
//    slideAnimation.removedOnCompletion = NO;
//    
//    [_scrollView.layer addAnimation:slideAnimation forKey:@"slideAnimation"];
//    
//    [CATransaction commit];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(scrollTimer) userInfo:nil repeats:NO];
    
    
//    _scrollView.bouncesZoom = NO;
}

- (void)goTop
{
    BBCycleScrollCell *cell = [_curViews objectAtIndex:1];
    [cell goTop];
}

- (void)stopRoll
{
    [_scrollTimer invalidate];
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
