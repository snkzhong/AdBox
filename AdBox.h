
#import <Foundation/Foundation.h>
#import <Chartboost/Chartboost.h>
#import <VungleSDK/VungleSDK.h>

@class UIViewController;
@interface AdBox : NSObject<ChartboostDelegate, VungleSDKDelegate> {
    NSInteger intervalAdSecs;
}

@property(nonatomic,assign) bool initialized;
@property(nonatomic,assign) NSTimeInterval rewardReviewStart;
@property(nonatomic,assign) bool rewardReviewBegining;

@property(nonatomic,assign) bool useAdmob;
@property(nonatomic,assign) bool useUnity;
@property(nonatomic,assign) bool useVungle;
@property(nonatomic,assign) bool useChartboost;

+ (AdBox *)instance;
- (void)initVarious;
- (void)banner;
- (void)bannerClose;
- (void)fullscreen;
- (void)video;
- (void)rewardedVideo;
- (void)vungleVideo;
- (void)moreGames;
- (void)rewardReview;
- (void)intervalShowAd;
- (void)anyAD;
- (void)randAnyAd;

- (void)showStartAd;

@end