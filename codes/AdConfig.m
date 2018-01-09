//
//  AdConfig.m
//  GoldExcavator
//
//  Created by zhong qin on 2017/6/23.
//  Copyright © 2017年 zhong qin. All rights reserved.
//

#import "AdConfig.h"
#import <UMOnlineConfig/UMOnlineConfig.h>

@implementation AdConfig

static AdConfig *_adConfig_;

+ (AdConfig *)instance
{
    if (!_adConfig_) {
        _adConfig_ = [[AdConfig alloc] init];
    }
    
    return _adConfig_;
}

- (void)initConfig
{
    NSDictionary *_dict = @{@"unity":@"1462006",@"vungle":@"",@"chartboost_id":@"5952448904b0164f7671b710",@"chartboost_sign":@"ba1a6d8255aed5a7397fa871abc99b8e6c35fa19",@"gad_fullscreen":@"ca-app-pub-4094928262212484/8743317854",@"gad_rewardedVideo":@"ca-app-pub-4094928262212484/4173517451",@"gad_banner":@""};
    local_config = [[NSDictionary alloc] initWithDictionary:_dict];
    
    NSString *_config = [UMOnlineConfig stringParams:@"adconfig"];
    NSLog(@"ocp adconfig:%@", _config);
    if ([_config length] >= 2) {
        NSData *jsonData = [[NSString stringWithString:_config] dataUsingEncoding:NSUTF8StringEncoding];
        
        _dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        _ol_config_ = [[NSDictionary alloc] initWithDictionary:_dict];
        
        useOcp_ = YES;
    }
}

- (NSString *)getUnityID
{
    NSString *unityID = [_ol_config_ objectForKey:@"unity"];
    if (useOcp_) {
        NSLog(@"ocp unity:%@", unityID);
        return unityID ? unityID : @"";
    }
    else {
        unityID = [local_config objectForKey:@"unity"];
        
        NSLog(@"local unity:%@", unityID);
        
        return unityID ? unityID : @"";
    }
    
    return UNITYAD_ID;
}

- (NSString *)getVungleID
{
    NSString *vungleID = [_ol_config_ objectForKey:@"vungle"];
    if (useOcp_) {
        NSLog(@"ocp vungle:%@",vungleID);
        return vungleID ? vungleID : @"";
    }
    else {
        vungleID = [local_config objectForKey:@"vungle"];
        
        NSLog(@"local vungle:%@",vungleID);
        
        return vungleID ? vungleID : @"";
    }
    
    return VUNGLE_ID;
}

- (NSString *)getChartboostID
{
    NSString *chartboostID = [_ol_config_ objectForKey:@"chartboost_id"];
    if (useOcp_) {
        NSLog(@"ocp chartboost_id:%@",chartboostID);
        return chartboostID ? chartboostID : @"";
    }
    else {
        chartboostID = [local_config objectForKey:@"chartboost_id"];
        
        NSLog(@"local chartboost_id:%@",chartboostID);

        return chartboostID ? chartboostID : @"";
    }
    
    return CHARTBOOST_APP_ID;
}

- (NSString *)getChartboostSign
{
    NSString *chartboostSign = [_ol_config_ objectForKey:@"chartboost_sign"];
    if (useOcp_) {
        NSLog(@"ocp chartboost_sign:%@",chartboostSign);
        return chartboostSign ? chartboostSign : @"";
    }
    else {
        chartboostSign = [local_config objectForKey:@"chartboost_sign"];
        
        NSLog(@"local chartboost_sign:%@",chartboostSign);

        return chartboostSign ? chartboostSign : @"";
    }
    
    return CHARTBOOST_SIGNATURE;
}


- (NSString *)getGadInterstitialID
{
    NSString *gadInterstitial = [_ol_config_ objectForKey:@"gad_fullscreen"];
    if (useOcp_) {
        NSLog(@"ocp gadInterstitial:%@",gadInterstitial);
        return gadInterstitial ? gadInterstitial : @"";
    }
    else {
        gadInterstitial = [local_config objectForKey:@"gad_fullscreen"];
        
        NSLog(@"local gadInterstitial:%@", gadInterstitial);
        
        return gadInterstitial ? gadInterstitial : @"";
    }
    
    return GAD_VIDEO_UNIT_ID;
}

- (NSString *)getGadRewardedVideoID
{
    NSString *gadRewardedVideo = [_ol_config_ objectForKey:@"gad_rewardedVideo"];
    if (useOcp_) {
        NSLog(@"ocp gadRewardedVideo:%@", gadRewardedVideo);
        return gadRewardedVideo ? gadRewardedVideo : @"";
    }
    else {
        gadRewardedVideo = [local_config objectForKey:@"gad_rewardedVideo"];
        
        NSLog(@"local gadRewardedVideo:%@", gadRewardedVideo);
        
        return gadRewardedVideo ? gadRewardedVideo : @"";
    }
    
    return GAD_REWARDEDVIDEO_UNIT_ID;
}


- (NSString *)getGadBannerID
{
    NSString *gadBanner = [_ol_config_ objectForKey:@"gad_banner"];
    if (useOcp_) {
        NSLog(@"ocp gadBanner:%@", gadBanner);
        return gadBanner ? gadBanner : @"";
    }
    else {
        gadBanner = [local_config objectForKey:@"gad_banner"];
        
        NSLog(@"local gadBanner:%@", gadBanner);
        
        return gadBanner ? gadBanner : @"";
    }
    
    return GAD_BANNER_UNIT_ID;
}

@end
