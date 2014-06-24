//
//  BBCycleViewController.m
//  BBStory
//
//  Created by FengZi on 14-3-13.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import "BBCycleViewController.h"
#import "MobClick.h"

@interface BBCycleViewController ()

@end

@implementation BBCycleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithData:(NSArray*)data index:(int)index
{
    self = [super init];
    if (self) {
        _data = data;
        _index = index;
        _tabbarIsHidden = NO;
    }
    return self;
}

- (void)loadView
{
    _statusHeight = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        _statusHeight = 20;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = view;
    view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    _listView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    _listView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:_listView];
    
    _tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, kDeviceHeight - 70, kDeviceWidth, 70)];
    _tabbarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tabbarView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(20, 10, 25, 25)];
    [backBtn addTarget:self action:@selector(backBtnTouch) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"main_menu_icon_back"] forState:UIControlStateNormal];
    [_tabbarView addSubview:backBtn];
    
    _loveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loveBtn setFrame:CGRectMake(kDeviceWidth - 20 - 25, 10, 25, 25)];
    [_loveBtn addTarget:self action:@selector(loveTouch) forControlEvents:UIControlEventTouchUpInside];
    [_tabbarView addSubview:_loveBtn];
    
    _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, kDeviceWidth, 40)];
    _pageLabel.font = [UIFont boldSystemFontOfSize:16];
    _pageLabel.backgroundColor = [UIColor clearColor];
    _pageLabel.textAlignment = NSTextAlignmentCenter;
    [_tabbarView addSubview:_pageLabel];
    
    _csView = [[BBCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    _csView.delegate = self;
    _csView.datasource = self;
    [_csView setCurPage:_index];
    [_csView loadData];
//    [_csView roll];
    [_listView addSubview:_csView];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self loadAdBanner];

}

- (void)backBtnTouch
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)loveTouch
{
    @try{
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSInteger hasEvaluated = [ud integerForKey:@"hasEvaluated"];
        if (!hasEvaluated)
        {
            int rate = [[MobClick getConfigParams:@"evaluateAlertRate"] intValue];
            int value = (arc4random() % 100) + 0;
            if (value <= rate)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"极爱简洁，我去好评！" delegate:self cancelButtonTitle:[MobClick getConfigParams:@"evaluateAlertCancelTitle"] otherButtonTitles:[MobClick getConfigParams:@"evaluateAlertConfirmTitle"], nil];
                [alert show];
            }
        }
        
        NSDictionary *curData = [_data objectAtIndex:_csView.curPage];
        
        NSMutableDictionary *dynamicLoveDic = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *loveDic = [ud objectForKey:@"loveDic"];
        if (loveDic != Nil) {
            NSArray *keys;
            int i;
            id key;
            keys = [loveDic allKeys];
            
            int count = [keys count];
            
            for (i = 0; i < count; i++)
            {
                key = [keys objectAtIndex: i];
                [dynamicLoveDic setObject:[loveDic objectForKey:key] forKey:key];
            }
        }
        
        NSString *k = [NSString stringWithFormat:@"%@", [curData objectForKey:@"id"]];
        
        if ([dynamicLoveDic objectForKey:k] == nil) {
            // 要被收藏的
            [_loveBtn setBackgroundImage:[UIImage imageNamed:@"main_menu_ico_love_light"] forState:UIControlStateNormal];
            [dynamicLoveDic setValue:@1 forKey:k];
        } else {
            [_loveBtn setBackgroundImage:[UIImage imageNamed:@"main_menu_ico_love"] forState:UIControlStateNormal];
            [dynamicLoveDic removeObjectForKey:k];
        }
        
        [ud setValue:dynamicLoveDic forKey:@"loveDic"];
        [ud synchronize];
    }
    @catch(NSException *exception) {
        NSLog(@"exception:%@", exception);
    }
    @finally {
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"hasEvaluated"];
        
        [BBFunction goToAppStoreEvaluate];
    }
}

- (void)changePage
{
    NSDictionary *curData = [_data objectAtIndex:_csView.curPage];
    NSString *key = [NSString stringWithFormat:@"%@", [curData objectForKey:@"id"]];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *loveDic = [ud objectForKey:@"loveDic"];
    if (loveDic == Nil) {
        loveDic = [[NSMutableDictionary alloc] init];
    }
    
    if ([loveDic objectForKey:key] == nil) {
        // 没有被收藏的
        [_loveBtn setBackgroundImage:[UIImage imageNamed:@"main_menu_ico_love"] forState:UIControlStateNormal];
    } else {
        [_loveBtn setBackgroundImage:[UIImage imageNamed:@"main_menu_ico_love_light"] forState:UIControlStateNormal];
    }

    _pageLabel.text = [NSString stringWithFormat:@"%d/%d", _csView.curPage+1, [_data count]];
    
    [ud setInteger:_csView.curPage forKey:@"lastReadPage"];
}

- (void)loadAdBanner
{
    int rand = (arc4random() % 100) + 0;
    NSLog(@"rand = %d", rand);
    if (rand > [[MobClick getConfigParams:@"openIADRate"] intValue]) {
        return;
    }
    
    if (kDeviceWidth > 640) {
        _adBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeLeaderboard];
    } else {
        _adBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    }
    CGRect frame = _adBannerView.frame;
    _adBannerView.frame = CGRectMake(kDeviceWidth/2 - frame.size.width/2, 0 + _statusHeight, frame.size.width, frame.size.height);
    
    // Specify the ad unit ID.
    _adBannerView.adUnitID = MY_BANNER_UNIT_ID;
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    _adBannerView.rootViewController = self;
    [self.view addSubview:_adBannerView];
    
    // Initiate a generic request to load it with an ad.
    [_adBannerView loadRequest:[GADRequest request]];
}

- (NSInteger)numberOfPages
{
    return [_data count];
}

- (UIView *)pageAtIndex:(NSInteger)index
{
    BBCycleScrollCell *cell = [[BBCycleScrollCell alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    NSDictionary *data = [_data objectAtIndex:index];
    [data setValue:[NSString stringWithFormat:@"%d/%d", index+1, [_data count]] forKey:@"pageIndex"];
    [cell loadData:data];
    cell.delegate = self;
    return cell;
}

- (void)didClickPage:(BBCycleScrollView *)csView atIndex:(NSInteger)index
{
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentPostion = scrollView.contentOffset.y;
    if (currentPostion - _lastPosition > 25) {
        _lastPosition = currentPostion;
        //        NSLog(@"ScrollUp now");
        if (currentPostion > 0 && !_tabbarIsHidden)
        {
            [self hideTabBarWithAnimationDuration:0.6];
            _tabbarIsHidden = YES;
        }
    }
    else if (_lastPosition - currentPostion > 25)
    {
        _lastPosition = currentPostion;
        //        NSLog(@"ScrollDown now");
        if (_tabbarIsHidden)
        {
            [self showTabBarWithAnimationDuration:0.4];
            _tabbarIsHidden = NO;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}


- (void)showTabBarWithAnimationDuration:(CGFloat)durationTime
{
    [UIView animateWithDuration:durationTime
                     animations:^{
                         _tabbarView.frame = CGRectMake(0, kDeviceHeight - 70, kDeviceWidth, 70);
                     }];
    CGRect frame = _adBannerView.frame;
    [UIView animateWithDuration:durationTime
                     animations:^{
                         _adBannerView.frame = CGRectMake(kDeviceWidth/2 - frame.size.width/2, 0 + _statusHeight, frame.size.width, frame.size.height);
                     }];
}

//隐藏TabBar通用方法
- (void)hideTabBarWithAnimationDuration:(CGFloat)durationTime
{
    [UIView animateWithDuration:durationTime
                     animations:^{
                         _tabbarView.frame = CGRectMake(0, kDeviceHeight, kDeviceWidth, 70);
                     }];
    CGRect frame = _adBannerView.frame;
    [UIView animateWithDuration:durationTime
                     animations:^{
                         _adBannerView.frame = CGRectMake(kDeviceWidth/2 - frame.size.width/2, -frame.size.height - _statusHeight, frame.size.width, frame.size.height);
                     }];
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
