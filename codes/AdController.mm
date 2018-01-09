#import "AdController.h"
#import "AdBox.h"

@implementation AdController

static AdController  *_AdController_ = NULL;

+ (AdController *)shared {
    if (!_AdController_) {
        _AdController_ = [[AdController alloc] init];
    }
    
    return _AdController_;
}

+ (void)clean {
    if (_AdController_) {
        _AdController_ = nil;
    }
}

#pragma mark ------------ setRootViewController ------
- (void)setRootViewController:(UIViewController *)viewController
{
    viewController_ = viewController;
}

- (UIViewController *)rootViewController {
    return viewController_;
}

#pragma mark ------------ gadInterstitial ------------
- (GADInterstitial *)gadInterstitialInit {
    
    self.gadInterstitial = [self gadInterstitialCreate];
    
    return self.gadInterstitial;
}

- (GADInterstitial *)gadInterstitialCreate
{
    NSString *gadInterstitialID = [[AdConfig instance] getGadInterstitialID];
    if (gadInterstitialID && [gadInterstitialID length] > 5) {
        GADInterstitial *_Interstitial = [[GADInterstitial alloc] initWithAdUnitID:gadInterstitialID];
        _Interstitial.delegate = self;
        
        GADRequest *request = [GADRequest request];
        request.testDevices = TEST_DEVICES;
        [_Interstitial loadRequest:request];
        
        NSLog(@"gadInterstitial Created");
        return _Interstitial;
    }
    
    return nil;
}

- (void)gadInterstitialRequest {
    if ([[AdBox instance] useAdmob] && [self.gadInterstitial isReady]) {
        NSLog(@"gadInterstitialRequest isReady");
        
        [self.gadInterstitial presentFromRootViewController:[self rootViewController]];
    }
    else if ([Chartboost hasInterstitial:CBLocationHomeScreen]) {
        [Chartboost showInterstitial:CBLocationHomeScreen];
    }
    else {
        NSLog(@"gadInterstitialRequest is not Ready");
        
        [[AdBox instance] video];
    }
}

#pragma mark  ------------  gadInterstitial delegate -----------
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
#ifdef DEBUG
    NSLog(@"interstitialDidReceiveAd:%@", [ad adNetworkClassName]);
#endif
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
#ifdef DEBUG
    NSLog(@"interstitial:%@ error:%@", [ad adNetworkClassName], [error localizedDescription]);
#endif
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    if (gadBannerView_) {
        gadBannerView_.hidden = YES;
    }
}

//关闭插屏广告，重新请求
- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    NSLog(@"interstitial did close");
    
    [self gadInterstitialInit];
    [self gadRewardedVideoInit];
    
    if (gadBannerView_) {
        gadBannerView_.hidden = NO;
    }
    
    [[AdBox instance] rewardReview];
}


#pragma mark  ------------  gadVideo -----------
//- (GADInterstitial *)gadVideoInit
//{
//    self.gadVideo = [self gadVideoCreate];
//    return self.gadVideo;
//    
//}
//
//- (GADInterstitial *)gadVideoCreate
//{
//    NSString *gadVideoID = [[AdConfig instance] getGadVideoID];
//    if (gadVideoID && [gadVideoID length] > 5) {
//        GADInterstitial *_interstitialVideo = [[GADInterstitial alloc] initWithAdUnitID:gadVideoID];
//        _interstitialVideo.delegate = self;
//        GADRequest *request = [GADRequest request];
//        //request.testDevices = TEST_DEVICES;
//        [_interstitialVideo loadRequest:request];
//        
//        NSLog(@"gadVideo Created");
//        
//        return _interstitialVideo;
//    }
//    
//    return nil;
//}
//
//- (void)gadVideoRequest
//{
//    if ([[AdBox instance] useAdmob] && [self.gadVideo isReady]) {
//        NSLog(@"gadVideo ready show");
//        [self.gadVideo presentFromRootViewController:[self rootViewController]];
//    }
//    else {
//        NSLog(@"gadVideo not ready");
//        
//        if ([[AdBox instance] useUnity]) {
//            [self unityAdShow];
//        }
//        else if([[AdBox instance] useChartboost]) {
//            [self chartboostRewardedVideo];
//        }
//        else if([[AdBox instance] useVungle]) {
//            [self vungleVideo];
//        }
//    }
//}


#pragma mark  ------------  gadRewardedVideo -----------
- (void)gadRewardedVideoInit
{
    NSString *rewardedVideoId = [[AdConfig instance] getGadRewardedVideoID];
    if ([rewardedVideoId length] < 5) {
        return;
    }
    
    [GADRewardBasedVideoAd sharedInstance].delegate = self;
    [[GADRewardBasedVideoAd sharedInstance] loadRequest:[GADRequest request] withAdUnitID:rewardedVideoId];
}

- (void)gadRewardedVideoRequest
{
    if ([[AdBox instance] useAdmob] && [[GADRewardBasedVideoAd sharedInstance] isReady]) {
        NSLog(@"gadRewardedVideo is ready");
        
        [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:[self rootViewController]];
    }
    else {
        NSLog(@"gadRewardedVideo is not ready");
        
        if ([[AdBox instance] useUnity]) {
            [self unityRewardedVideo];
        }
        else if ([[AdBox instance] useChartboost]) {
            [self chartboostRewardedVideo];
        }
        else if ([[AdBox instance] useVungle]) {
            [self vungleVideo];
        }
    }
}


#pragma mark  ------------  gadRewardedVideo delegate -----------
- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
   didRewardUserWithReward:(GADAdReward *)reward
{
    NSLog(@"rewardBasedVideoAd:%@", [rewardBasedVideoAd adNetworkClassName]);
}

/// Tells the delegate that the reward based video ad failed to load.
- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
    didFailToLoadWithError:(NSError *)error
{
    NSLog(@"rewardBasedVideoAd didFailToLoadWithError:%@", [error localizedDescription]);
}

/// Tells the delegate that a reward based video ad was received.
- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    NSLog(@"rewardBasedVideoAdDidReceiveAd");
}

/// Tells the delegate that the reward based video ad started playing.
- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    
}

/// Tells the delegate that the reward based video ad closed.
- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    [self gadInterstitialInit];
    [self gadRewardedVideoInit];
}





#pragma mark  ------------  gadBanner -----------
- (GADBannerView *)gadBannerInit {
    
    gadBannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    
    [self gadBannerGen:gadBannerView_];
    
    return gadBannerView_;
}

- (GADBannerView *)gadBannerInit:(NSString *)position {
    bannerPosition_ = position;
    
    // top
    CGPoint origin = CGPointMake(0.0, 0.0);
    
    if ([@"bottom" isEqualToString:position]) {
        origin = CGPointMake(0.0, [[UIScreen mainScreen] bounds].size.height - CGSizeFromGADAdSize(kGADAdSizeSmartBannerPortrait).height);
    }
    
    if ([@"top" isEqualToString:position]) {
        origin = CGPointMake(0.0, 0.0);
    }
    
    if ([@"topRight" isEqualToString:position]) {
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            origin = CGPointMake([[UIScreen mainScreen] bounds].size.width - CGSizeFromGADAdSize(kGADAdSizeBanner).width+80, -15);
        }
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            origin = CGPointMake([[UIScreen mainScreen] bounds].size.width - CGSizeFromGADAdSize(kGADAdSizeFullBanner).width+30, -10);
        }
        
    }
    
    gadBannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait origin:origin];
    
    [self gadBannerGen:gadBannerView_];
    
    return gadBannerView_;
}

- (void)gadBannerGen:(GADBannerView *)gadBannerView {
    
    gadBannerView.adUnitID = [[AdConfig instance] getGadBannerID];
    gadBannerView.autoloadEnabled = true;
    gadBannerView.delegate = self;
    gadBannerView.rootViewController = [self rootViewController];
    
    GADRequest *request = [GADRequest request];
    request.testDevices = TEST_DEVICES;
    [gadBannerView loadRequest:request];
}


#pragma mark  ------------  gadBanner delegate -----------
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    NSLog(@"--------adViewDidReceiveAd---------");
    
    bannerIsReady_ = true;
    
    [[self rootViewController].view addSubview:bannerView];
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView didFailToReceiveAdWithError:%@", [error localizedDescription]);
}

- (void)adViewWillPresentScreen:(GADBannerView *)bannerView {
    
}

- (void)adViewDidDismissScreen:(GADBannerView *)bannerView {
    if (bannerPosition_) {
        [self gadBannerInit:bannerPosition_];
    }
    else {
        [self gadBannerInit];
    }
}

- (void)gadBannerRequest {
    NSLog(@"----- gadBannerRequest -----");
    
    [self gadBannerInit:@"bottom"];
    
    //    if (bannerPosition_) {
    //        [self gadBannerInit:bannerPosition_];
    //    }
    //    else {
    //        [self gadBannerInit];
    //    }
}

- (void)gadBannerClose {
    NSLog(@"----- gadBannerClose -----");
    if (gadBannerView_) {
        [gadBannerView_ removeFromSuperview];
        gadBannerView_ = nil;
    }
}



#pragma mark  ------------  Unity Vieo -----------
- (void)unityAdInit {
    Boolean isTest = NO;
    //#ifdef DEBUG
    //    isTest = YES;
    //#endif
    
    //[UnityAds initialize:UNITYAD_ID delegate:self testMode:isTest];
    [UnityAds initialize:[[AdConfig instance] getUnityID] delegate:self testMode:isTest];
}

- (void)unityAdShow {
    if ([UnityAds isSupported] && [UnityAds isReady:@"video"]) {
        NSLog(@"unityAd ready and show");
        if (gadBannerView_) {
            gadBannerView_.hidden = YES;
        }
        
        [UnityAds show:[self rootViewController] placementId:@"video"];
    }
    else {
        NSLog(@"unityAd not ready");
        [self chartboostInterstitial];
    }
}

- (void)unityRewardedVideo {
    if ([UnityAds isSupported] && [UnityAds isReady:@"rewardedVideo"]) {
        if (gadBannerView_) {
            gadBannerView_.hidden = YES;
        }
        
        [UnityAds show:[self rootViewController] placementId:@"rewardedVideo"];
    }
    else {
        [self chartboostRewardedVideo];
    }
}

#pragma mark  ------------  Unity Vieo delegate -----------
- (void)unityAdsReady:(NSString *)placementId {
    NSLog(@"------unityAdsReady:%@-------", placementId);
}

- (void)unityAdsDidError:(UnityAdsError)error withMessage:(NSString *)message {
    NSLog(@"------unityAdsDidError:%@", message);
}

- (void)unityAdsDidStart:(NSString *)placementId {
    NSLog(@"------unityAdsDidStart:%@", placementId);
    
    unityAdRunning_ = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"videoOpen" object:self userInfo:nil];
}

- (void)unityAdsDidFinish:(NSString *)placementId withFinishState:(UnityAdsFinishState)state {
    NSLog(@"-------unityAdsDidFinish:%@  %ld", placementId, (long)state);
    
    unityAdRunning_ = NO;
    
    if (gadBannerView_) {
        gadBannerView_.hidden = NO;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"videoClose" object:self userInfo:nil];
    
    [[AdBox instance] rewardReview];
    
    [self gadInterstitialInit];
    [self gadRewardedVideoInit];
}


#pragma mark  ------------  Vungle Video -----------
- (void)vungleVideo
{
    VungleSDK* sdk = [VungleSDK sharedSDK];
    NSError *error;
    
    if (!unityAdRunning_ && [sdk isAdPlayable]) {
        [sdk playAd:[self rootViewController] error:&error];
    }
    else if ([UnityAds isReady:@"video"]) {
        [self unityAdShow];
    }
    else if ([[AdBox instance] useChartboost]) {
        [self chartboostInterstitial];
    }
    else {
        [[AdBox instance] randAnyAd];
    }
}


#pragma mark  ------------  Chartboost Interstitial -----------
- (void)chartboostInterstitial
{
    if ([Chartboost hasInterstitial:CBLocationHomeScreen]) {
        NSLog(@"chartboostInterstitial ready");
        [Chartboost showInterstitial:CBLocationHomeScreen];
    }
    else {
        NSLog(@"chartboostInterstitial not ready");
        //[[AdBox instance] randAnyAd];
        //[self gadInterstitialRequest];
        
        if (self.gadInterstitial && [self.gadInterstitial isReady]) {
            [self gadInterstitialRequest];
        }
    }
}


#pragma mark  ------------  Chartboost RewardedVideo -----------
- (void)chartboostRewardedVideo
{
    if ([Chartboost hasRewardedVideo:CBLocationHomeScreen]) {
        [Chartboost showRewardedVideo:CBLocationHomeScreen];
    }
    else {
        NSLog(@"chartboostRewardedVideo not ready");
        [self gadRewardedVideoRequest];
    }
}

@end
