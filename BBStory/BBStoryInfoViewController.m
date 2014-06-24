//
//  BBTabooInfoViewController.m
//  BB
//
//  Created by FengZi on 14-1-16.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import "BBStoryInfoViewController.h"
#import "BBMainViewController.h"

@interface BBStoryInfoViewController ()

@end

@implementation BBStoryInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initWithData:(NSDictionary*)data
{
    self = [super init];
    if (self) {
        _data = data;
    }
    return self;
}

- (void)loadView
{
    UIScrollView *baseView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    baseView.delegate = self;
    baseView.backgroundColor = [UIColor whiteColor];
    self.view = baseView;
    
    NSInteger height = 0;
    
    NSString *str = [_data objectForKey:@"title"];
    CGSize size = CGSizeMake(kDeviceWidth, 2000);
    CGSize labelSize = [str sizeWithFont:[UIFont systemFontOfSize:19] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *titleLabel = [self titleLabelStr:str];
    titleLabel.frame = CGRectMake(kDeviceWidth/2 - labelSize.width/2, height + 10, labelSize.width, 30);
    [baseView addSubview:titleLabel];
    
    height += 10;
    
    UILabel *contentLabel = [self contentLabelStr:[_data objectForKey:@"content"] Height:height];
    [baseView addSubview:contentLabel];
    
    height += contentLabel.size.height;
    
    baseView.contentSize = CGSizeMake(kDeviceWidth, height);
}

- (UILabel*)titleLabelStr:(NSString*)str
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = str;
    titleLabel.font = [UIFont systemFontOfSize:18];
    return titleLabel;
}

- (UILabel*)contentLabelStr:(NSString*)str Height:(NSInteger)height
{
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.text = [NSString stringWithFormat:@"    %@", str];
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.adjustsFontSizeToFitWidth = YES;
    //设置一个行高上限
    CGSize size = CGSizeMake(kDeviceWidth, 2000);
    // 计算实际frame大小，并将label的frame变成实际大小
    CGSize labelSize = [str sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    [contentLabel setFrame:CGRectMake(20, height + 15, kDeviceWidth - 40, labelSize.height)];
    return contentLabel;
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
