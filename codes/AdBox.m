#import "AdBox.h"
#import "AdController.h"
#import <UMMobClick/MobClick.h>
#import <UMOnlineConfig/UMOnlineConfig.h>
#import <StoreKit/SKStoreProductViewController.h>


@implementation AdBox

@synthesize initialized;
@synthesize useAdmob;
@synthesize useUnity;
@synthesize useVungle;
@synthesize useChartboost;

static AdBox *_adBox_;

+ (AdBox *)instance
{
    if (!_adBox_) {
        _adBox_ = [[AdBox alloc] init];
    }
    
    return _adBox_;
}

- (void)initVarious
{
    NSLog(@"AdBox initVarious");
    initialized = NO;
    
    [[AdConfig instance] initConfig];
    
    UMConfigInstance.appKey = UMENG_KEY;
    UMConfigInstance.channelId = @"App Store";
    UMConfigInstance.eSType = E_UM_NORMAL;
    [MobClick startWithConfigure:UMConfigInstance];
    
    NSString *gadInterstitialID = [[AdConfig instance] getGadInterstitialID];
    NSLog(@"gadInterstitialID: %@", gadInterstitialID);
    if (gadInterstitialID && [gadInterstitialID length] > 5) {
        [[AdController shared] gadInterstitialInit];
        [[AdController shared] gadRewardedVideoInit];
//    [[AdController shared] gadBannerInit:@"bottom"];
        
        useAdmob = YES;
    }
    
    NSString *unityID = [[AdConfig instance] getUnityID];
    if (unityID && [unityID length] > 5) {
        [[AdController shared] unityAdInit];
        
        useUnity = YES;
    }
    
    VungleSDK* sdk = [VungleSDK sharedSDK];
    NSString *vungleID = [[AdConfig instance] getVungleID];
    if (vungleID && [vungleID length] > 5) {
        [sdk startWithAppId:vungleID];
        [sdk setDelegate:self];
        
        useVungle = YES;
    }
    
    NSString *chartboostID = [[AdConfig instance] getChartboostID];
    NSString *chartboostSign = [[AdConfig instance] getChartboostSign];
    if (chartboostID && chartboostSign) {
        [Chartboost startWithAppId:chartboostID
                      appSignature:chartboostSign
                          delegate:self];
        [Chartboost setAutoCacheAds:YES];
        
        useChartboost = YES;
    }
    
    _adBox_ = self;
    
    intervalAdSecs = INTERVAL_AD_SECS;
    
    initialized = YES;
}

- (bool)isIgnoreAD
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"ignoreAD"];
}


- (bool)isShowAD
{
    return [[UMOnlineConfig boolParams:@"showAd"] boolValue];
}

- (void)showStartAd
{
    NSLog(@"try showStartAd");
    [self performSelector:@selector(_showStartAd) withObject:nil afterDelay:8];
}

- (void)_showStartAd
{
    BOOL startAd= [[UMOnlineConfig boolParams:@"startAd"] boolValue];
    NSLog(@"is startAd: %d", startAd);
    
    if (!initialized || !startAd) {
        return;
    }
    
    int startAdType = [[UMOnlineConfig numberParams:@"startAdType"] intValue];
    NSLog(@"startAdType:%d", startAdType);
    if (startAdType > 0) {
        [self specialAllAd:startAdType];
    }
    else {
        [self anyAD];
    }
}


- (void)intervalShowAd
{
    BOOL notIntervalAd =  [[UMOnlineConfig boolParams:@"notIntervalAd"] boolValue];
    if (notIntervalAd) {
        return;
    }
    
    NSInteger interval = [[UMOnlineConfig numberParams:@"intervalSecs"] intValue];
    if (interval > 0) {
        intervalAdSecs = interval;
    }
    
    [self performSelector:@selector(_intervalShowAd) withObject:nil afterDelay:intervalAdSecs];
}

- (void)_intervalShowAd
{
    NSLog(@"intervalShowAd: %ld", intervalAdSecs);
    
    int intervalType = [[UMOnlineConfig numberParams:@"intervalType"] intValue];
    if (intervalType > 0) {
        [self specialAllAd:intervalType];
    }
    else {
        //[self randAnyAd];
        [self anyAD];
    }
    
    [self intervalShowAd];
}

- (void)anyAD
{
    int forceAdType = [[UMOnlineConfig numberParams:@"forceAd"] intValue];
    if (forceAdType > 0) {
        NSLog(@"anyAD forceAdType: %d", forceAdType);
        [self specialAllAd:forceAdType];
    }
    else {
        //[self randAnyAd];
        int r = arc4random() % 2 + 1;
        
        if (r == 1) {
            NSLog(@"anyAD fullscreen");
            [self fullscreen];
        }
        else if (r == 2) {
            NSLog(@"anyAD video");
            [self video];
        }
    }
}

#pragma mark  ------------  random not reward AD -----------
- (void)randAnyAd
{
    int r = arc4random() % 5 + 1;
    
    switch (r) {
        case 1:
        [[AdController shared] gadInterstitialRequest];
        break;
        
        case 2:
        [[AdController shared] chartboostInterstitial];
        break;
        
        case 3:
        [[AdController shared] unityAdShow];
        break;
        
        case 4:
        [[AdController shared] vungleVideo];
        break;
    }
}

- (void)banner
{
    if ([self isIgnoreAD]) return;
    
    //NSLog(@"AdBox Plugin banner");
    
    [[AdController shared] gadBannerInit:@"bottom"];
}

- (void)bannerClose
{
    //NSLog(@"AdBox Plugin banner");
    [[AdController shared] gadBannerClose];
}

- (void)fullscreen
{
    if ([self isIgnoreAD]) return;
    
    NSLog(@"AdBox Plugin fullscreen");
    
    int fullscreenType = [[UMOnlineConfig numberParams:@"fullscreenType"] intValue];
    
    if (fullscreenType > 0)
    {
        [self specialFullscreenAd:fullscreenType];
    }
    else {
        int r = arc4random() % 2 + 1;
        if (r == 1) {
            [[AdController shared] gadInterstitialRequest];
        }
        else {
            [[AdController shared] chartboostInterstitial];
        }
    }
}

- (void)video
{
    if ([self isIgnoreAD]) return;
    
    NSLog(@"AdBox Plugin video");
    
    int videoType = [[UMOnlineConfig numberParams:@"videoType"] intValue];
    
    if (videoType > 0) {
        [self specialVideoAd:videoType];
    }
    else {
        //[[AdController shared] gadVideoRequest];
        
        int r1 = arc4random() % 2 + 1;
        if (r1 == 1) {
            NSLog(@"anyAD unity");
            [[AdController shared] unityAdShow];
        }
        else if (r1 == 2) {
            NSLog(@"anyAD vungle");
            [[AdController shared] vungleVideo];
        }
    }
}

- (void)rewardedVideo
{
    if ([self isIgnoreAD]) return;
    
    [[AdController shared] unityRewardedVideo];
}

- (void)vungleVideo
{
    if ([self isIgnoreAD]) return;
    
    NSLog(@"AdBox Plugin vungleVideo");
    
    [[AdController shared] vungleVideo];
}

- (void)rewardReview
{
    if ([self isIgnoreAD]) return;
    if (![[UMOnlineConfig boolParams:@"rewardReview"] boolValue]) {
        NSLog(@"rewardReview closed");
        return;
    }
    
    if ([AdBox isCNLang]) {
        NSString *title = @"";//@"玩的爽吗，去打分吧！";
        [[[UIAlertView alloc] initWithTitle:title message:@"5星好评，立即去除烦人的广告哦！" delegate:self cancelButtonTitle:@"残忍拒绝" otherButtonTitles:@"欣然前往", nil] show];
    }
    else {
        NSString *title = @"";//@"Play cool?";
        [[[UIAlertView alloc] initWithTitle:title message:@"5 star well review, immediately remove the annoying ads!" delegate:self cancelButtonTitle:@"Refuse" otherButtonTitles:@"Yes Go", nil] show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        _rewardReviewStart = [[NSDate date] timeIntervalSince1970];
        NSLog(@"_rewardReviewStart: %f", _rewardReviewStart);
        NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",
                         IOS_APP_ID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

- (void)moreGames
{
    NSString *appId = PUSH_APP_ID;
    NSString *remoteAppId = [UMOnlineConfig stringParams:@"push_app_id"];
    if ([remoteAppId length] > 5) {
        appId = remoteAppId;
    }
    
    if (!appId) return;
    
    NSString  *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&id=%@",appId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    return;
    
    
    UIViewController *_controller = [[AdController shared] rootViewController];
    SKStoreProductViewController *vc = [[SKStoreProductViewController alloc] init];
    [vc setDelegate:_controller];
    [vc loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:appId} completionBlock:^(BOOL result, NSError *error) {
        if (error) {
            NSLog(@"Error %@ with User Info %@.", error, [error userInfo]);
        } else {
            NSLog(@"presentViewController");
            // Present Store Product View Controller
            [_controller presentViewController:vc animated:YES completion:nil];
        }
    }];
}

//获取当前的时间
+(NSTimeInterval)getCurrentTimes{
    return [[NSDate date] timeIntervalSince1970];
}

+(NSString*)currentLanguage
{
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSArray *languages = [defaults arrayForKey:@"AppleLanguages"];
    //    NSString *currentLang = [languages objectAtIndex:0];
    //    return currentLang;
    return [[NSLocale currentLocale] localeIdentifier];
}

+(BOOL)isCNLang
{
    if([[AdBox currentLanguage] isEqualToString:@"zh_CN"])
    {
        return true;
    }
    
    return false;
}

+(BOOL)chooseOne
{
//    UInt64 sec = [[NSDate date] timeIntervalSince1970];
//    
//    return (sec % 2) == 0;
     int r = arc4random() % 2 + 1;
    return r == 1;
}





#pragma mark  ------------  chartboost delegate -----------
- (void)didInitialize:(BOOL)status
{
    NSLog(@"chartboost didInitialize:%d", status);
}

- (void)didCacheInterstitial:(CBLocation)location
{
    NSLog(@"chartboost didCacheInterstitial:%@",location);
}

- (void)didFailToLoadInterstitial:(CBLocation)location withError:(CBLoadError)error
{
    NSLog(@"chartboost didFailToLoadInterstitial:%@ error:%lu", location, (unsigned long)error);
}

- (void)didCacheRewardedVideo:(CBLocation)location
{
    NSLog(@"chartboost didCacheRewardedVideo:%@",location);
}

- (void)didFailToLoadRewardedVideo:(CBLocation)location withError:(CBLoadError)error
{
    NSLog(@"chartboost didFailToLoadRewardedVideo:%@ error:%lu",location, (unsigned long)error);
}

- (void)didDismissInterstitial:(CBLocation)location
{
    [[AdController shared] gadInterstitialInit];
}

- (void)didDismissRewardedVideo:(CBLocation)location
{
    [[AdController shared] gadInterstitialInit];
    [[AdController shared] gadRewardedVideoInit];
}
#pragma mark  ------------  chartboost delegate end -----------





#pragma mark  ------------  Vungle delegate start -----------
- (void)vungleSDKwillShowAd
{
    NSLog(@"vungleSDKwillShowAd");
}

- (void)vungleSDKWillCloseAdWithViewInfo:(NSDictionary *)viewInfo
{
    [[AdController shared] gadInterstitialInit];
    [[AdController shared] gadRewardedVideoInit];
}
#pragma mark  ------------  Vungle delegate end --------



- (void)chartboostInterstitial
{
    [[AdController shared] chartboostInterstitial];
}

- (void)chartboostRewardedVideo
{
    [[AdController shared] chartboostRewardedVideo];
}





#pragma mark  ------------  UMOnlineConfig Server Special AD Type -----------
//1.Admob插屏 2.Admob激励视频 3.unity 4.unity rewarded 5.vungleVideo 6.chartboost 7 chartboost reward
- (void)specialAllAd:(int)type
{
    NSLog(@"specialAllAd:%d", type);
    switch (type) {
        case 1:
        [[AdController shared] gadInterstitialRequest];
        break;
        case 2:
        [[AdController shared] gadRewardedVideoRequest];
        break;
        case 3:
        [[AdController shared] unityAdShow];
        break;
        case 4:
        [[AdController shared] unityRewardedVideo];
        break;
        case 5:
        [[AdController shared] vungleVideo];
        break;
        case 6:
        [[AdController shared] chartboostInterstitial];
        break;
        case 7:
        [[AdController shared] chartboostRewardedVideo];
        break;
        
        default:
        [self randAnyAd];
        break;
    }
}

//1.unity 2.chartboost 3.vungle 4.Admob reward 5.unity rewarded 6.chartboost rewarded
- (void)specialVideoAd:(int)type
{
    NSLog(@"specialVideoAd:%d", type);
    switch (type) {
        case 1:
        [[AdController shared] unityAdShow];
        break;
        case 2:
        [[AdController shared] chartboostInterstitial];
        break;
        case 3:
        [[AdController shared] vungleVideo];
        break;
        case 4:
        [[AdController shared] gadRewardedVideoRequest];
        break;
        case 5:
        [[AdController shared] unityRewardedVideo];
        break;
        case 6:
        [[AdController shared] chartboostRewardedVideo];
        break;
        default:
        [self randAnyAd];
        break;
    }
}

- (void)specialFullscreenAd:(int)type
{
    NSLog(@"specialFullscreenAd:%d", type);
    switch (type) {
        case 1:
        [[AdController shared] gadInterstitialRequest];
        break;
        case 2:
        [[AdController shared] chartboostInterstitial];
        break;
        
        default:
        [self randAnyAd];
        break;
    }
}

@end
