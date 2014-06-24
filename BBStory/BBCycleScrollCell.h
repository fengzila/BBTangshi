//
//  BBCycleScrollCell.h
//  BB
//
//  Created by FengZi on 14-1-18.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBMaterialView;
@class BBStepView;

@protocol BBCycleScrollCellDelegate <NSObject>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end
@interface BBCycleScrollCell : UIView<UIScrollViewDelegate>
{
@private
    UIScrollView            *_baseView;
    UIView                  *_bgView;
    UIImageView             *_imageView;
    UILabel                 *_pageIndexLabel;
    UILabel                 *_titleLabel;
    UILabel                 *_contentLabel;
    UILabel                 *_materialTitleLabel;
    BBMaterialView          *_materialView;
    UILabel                 *_stepTitleLabel;
    BBStepView              *_stepView;
    
    NSArray                 *_colorTheme;
    int                     _tapNum;
}

@property (nonatomic) id <BBCycleScrollCellDelegate> delegate;
- (void)loadData:(NSDictionary*)data;
- (void)goTop;
@end
