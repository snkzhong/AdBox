#ifndef AdController_h
#define AdController_h

#import "AdConfig.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GADMobileAds.h>
#import <GoogleMobileAds/GADInterstitial.h>
#import <GoogleMobileAds/GADBannerView.h>
#import <GoogleMobileAds/GADRewardBasedVideoAd.h>
#import <GoogleMobileAds/GADRewardBasedVideoAdDelegate.h>
#import <UnityAds/UnityAds.h>
#import <VungleSDK/VungleSDK.h>


@interface AdController: NSObject <GADInterstitialDelegate, GADBannerViewDelegate, GADRewardBasedVideoAdDelegate, UnityAdsDelegate> {
    
    NSString *bannerPosition_;
    GADBannerView *gadBannerView_;
    bool bannerIsReady_;
    
    UIViewController *viewController_;
    
    bool unityAdRunning_;
}

@property(nonatomic, strong) GADInterstitial *gadInterstitial;
@property(nonatomic, strong) GADInterstitial *gadVideo;

+ (AdController *) shared;
+ (void) clean;

- (void)setRootViewController:(UIViewController *)viewController;
- (UIViewController *)rootViewController;

//- (void) attachEgretInterfaces;

- (GADInterstitial *) gadInterstitialInit;
- (void) gadInterstitialRequest;

//- (GADInterstitial *)gadVideoInit;
//- (void) gadVideoRequest;

- (void) gadRewardedVideoInit;
- (void) gadRewardedVideoRequest;

- (GADBannerView *) gadBannerInit;
- (GADBannerView *) gadBannerInit:(NSString*)position;
- (void) gadBannerRequest;
- (void) gadBannerClose;

- (void) unityAdInit;
- (void) unityAdShow;
- (void) unityRewardedVideo;

- (void) vungleVideo;

//- (void) inmobiInit;
//- (void) inmobiFullscreen;
//- (void) inmobiBanner;

- (void) chartboostInterstitial;
- (void) chartboostRewardedVideo;


@end

#endif /* AdController_h */
