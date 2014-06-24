//
//  BBFunction.m
//  BBClock
//
//  Created by FengZi on 14-1-15.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import "BBFunction.h"

@implementation BBFunction

+ (void)goToAppStoreEvaluate
{
    NSURL *url;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        url = [NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=870092312"];
    }
    else
    {
        url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id870092312?at=10l6dK"];
    }
    [[UIApplication sharedApplication] openURL:url];
}
@end
