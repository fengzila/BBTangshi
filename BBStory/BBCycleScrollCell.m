//
//  BBCycleScrollCell.m
//  BB
//
//  Created by FengZi on 14-1-18.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import "BBCycleScrollCell.h"

@implementation BBCycleScrollCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 页签
//        UIImageView *pageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-5, 20, 40, 40)];
//        pageImageView.image = [UIImage imageNamed:@"direction_index"];
//        [_imageView addSubview:pageImageView];
        
//        _pageIndexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//        _pageIndexLabel.textColor = kPink;
//        _pageIndexLabel.font = [UIFont boldSystemFontOfSize:16];
//        _pageIndexLabel.backgroundColor = [UIColor clearColor];
//        _pageIndexLabel.textAlignment = NSTextAlignmentCenter;
//        [pageImageView addSubview:_pageIndexLabel];
        
        _baseView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:_baseView];
        _baseView.delegate = self;
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, self.width - 5*2, self.height)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.masksToBounds = YES;
        [_baseView addSubview:_bgView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DoubleTap)];
        tap.numberOfTapsRequired = 2; // 双击
        [_bgView addGestureRecognizer:tap];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:25];
        [_bgView addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:18];
        _contentLabel.adjustsFontSizeToFitWidth = YES;
        [_bgView addSubview:_contentLabel];
        
        _tapNum = 0;
        _colorTheme = [[NSArray alloc] initWithObjects:
                       [[NSDictionary alloc] initWithObjectsAndKeys:[UIColor whiteColor], @"bgColor", [UIColor blackColor], @"fontColor", [UIColor whiteColor], @"containerColor", nil],
                       [[NSDictionary alloc] initWithObjectsAndKeys:[UIColor blackColor], @"bgColor", [UIColor grayColor], @"fontColor", [UIColor blackColor], @"containerColor", nil],
                       nil];
        
        [self setColorTheme];
    }
    return self;
}

- (UILabel*)titleLabelWithStr:(NSString*)str
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = str;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    
    return titleLabel;
}

- (void)loadData:(NSDictionary*)data
{
    NSString *titleStr = [data objectForKey:@"title"];
    NSString *author = [data objectForKey:@"autor"];
    NSString *yunyi = [data objectForKey:@"yunyi"];
    NSString *zhujie = [data objectForKey:@"zhujie"];
    NSString *pingxi = [data objectForKey:@"pingxi"];
    NSString *contentStr = [data objectForKey:@"content"];
    
//    _pageIndexLabel.text = [data objectForKey:@"pageIndex"];
    
    NSInteger height = 90;
    if (kDeviceWidth > 640)
    {
        height = 150;
    }
    
    _titleLabel.text = titleStr;
    _titleLabel.frame = CGRectMake(0, height, self.width, 25);
    
    height += _titleLabel.height + 10;
    
    UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, height, self.width - 15 * 2, 30)];
    authorLabel.backgroundColor = [UIColor clearColor];
    authorLabel.textAlignment = NSTextAlignmentCenter;
    authorLabel.textColor = [UIColor blackColor];
    authorLabel.font = [UIFont systemFontOfSize:18];
    authorLabel.text = author;
    [_bgView addSubview:authorLabel];
    
    height += authorLabel.height + 10;
    
    //设置一个行高上限
    CGSize size = CGSizeMake(_bgView.width, 3000);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelSize = [contentStr sizeWithFont:[UIFont systemFontOfSize:19] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    _contentLabel.text = contentStr;
    [_contentLabel setFrame:CGRectMake(0, height, self.width, labelSize.height)];
    
    height += _contentLabel.height + 30;
    
    UILabel *zhujieTitleLabel = [self createSingleLineLabel:@"注解：" Height:height];
    
    height += zhujieTitleLabel.height + 5;
    
    UILabel *zhujieLabel = [self createMultiLinesLabel:zhujie Height:height];
    
    height += zhujieLabel.height + 20;
    
    UILabel *yunyiTitleLabel = [self createSingleLineLabel:@"韵译：" Height:height];
    
    height += yunyiTitleLabel.height + 5;
    
    UILabel *yunyiLabel = [self createMultiLinesLabel:yunyi Height:height];
    
    height += yunyiLabel.height + 20;
    
    UILabel *pingxiTitleLabel = [self createSingleLineLabel:@"评析：" Height:height];
    
    height += pingxiTitleLabel.height + 5;
    
    UILabel *pingxiLabel = [self createMultiLinesLabel:pingxi Height:height];
    
    height += pingxiLabel.height;
    
    height += 100;
    
    if (height < kDeviceHeight) {
        height = kDeviceHeight + 10;
    }
    
    _baseView.contentSize = CGSizeMake(self.bounds.size.width, height);
    _bgView.frame = CGRectMake(5, 0, self.width - 5*2, height);
}

- (UILabel*)createSingleLineLabel:(NSString*)str Height:(int)height
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, height, self.width - 15 * 2, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.text = str;
    [_bgView addSubview:label];
    
    return label;
}

- (UILabel*)createMultiLinesLabel:(NSString*)str Height:(int)height
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:18];
    label.adjustsFontSizeToFitWidth = YES;
    
    //设置一个行高上限
    CGSize size = CGSizeMake(_bgView.width, 3000);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelSize = [str sizeWithFont:[UIFont systemFontOfSize:19] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    label.text = str;
    [label setFrame:CGRectMake(15, height, self.width - 15 * 2, labelSize.height)];
    [_bgView addSubview:label];
    
    return label;
}

- (void)setColorTheme
{
    _baseView.backgroundColor = [[_colorTheme objectAtIndex:_tapNum] objectForKey:@"containerColor"];
    _bgView.backgroundColor = [[_colorTheme objectAtIndex:_tapNum] objectForKey:@"bgColor"];
    
    for (id label in _bgView.subviews){
        if ([label isKindOfClass:[UILabel class]]){
            UILabel *lb = (UILabel*)label;
            lb.textColor = [[_colorTheme objectAtIndex:_tapNum] objectForKey:@"fontColor"];
        }
    }

}

- (void)DoubleTap
{
    _tapNum++;
    if (_tapNum > [_colorTheme count]-1) {
        _tapNum = 0;
    }
    [self setColorTheme];
}

- (void)goTop
{
    [_baseView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset = _baseView.contentOffset.y;
    
    CGFloat ImageWidth  = self.width - 20;
    CGFloat ImageHeight  = (self.width - 20)*3/5 - 3;
    if (yOffset < 0)
    {
        CGFloat factor = ((ABS(yOffset)+ImageHeight)*ImageWidth)/ImageHeight;
        CGRect f = CGRectMake(-(factor-ImageWidth)/2 + 10, 10, factor, ImageHeight+ABS(yOffset));
        _imageView.frame = f;
    }
    else
    {
        CGRect f = _imageView.frame;
        f.origin.y = -yOffset + 10;
        _imageView.frame = f;
    }
    
    [self.delegate scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView 
{
    [self.delegate scrollViewDidEndDecelerating:scrollView];
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
