//
//  BBTabooInfoViewController.h
//  BB
//
//  Created by FengZi on 14-1-16.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBStoryInfoViewController : UIViewController<UIScrollViewDelegate>
{
@private
    NSDictionary*           _data;
}
- (id)initWithData:(NSDictionary*)data;
@end
