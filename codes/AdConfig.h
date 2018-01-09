#ifndef AdConfig_h
#define AdConfig_h

//http port
#define HTTP_PORT 10000

//1.landspace    2.Portrait
#define SCREEN_ORIENTATION 1

#define INTERVAL_AD_SECS 120


#define PUSH_APP_ID @""

#define IOS_APP_ID @"1206749874"

//umeng
#define UMENG_KEY @"595302d65312dd5262000aff"
//unity
#define UNITYAD_ID @"1446878"


//vungle
#define VUNGLE_ID @""

//chartboost
#define CHARTBOOST_APP_ID @"593f70b9f6cd45299f49c49d"

#define CHARTBOOST_SIGNATURE @"cb8986c2356adc8b8e3546ff7f76e53407a7f201"

//Admob
#define GAD_APP_ID @"ca-app-pub-3402191935484721~7875587695"

#define GAD_VIDEO_UNIT_ID @"ca-app-pub-3402191935484721/3305787295"

#define GAD_REWARDEDVIDEO_UNIT_ID @"ca-app-pub-3402191935484721/4782520491"

#define GAD_FULLSCREEN_UNIT_ID @"ca-app-pub-3402191935484721/9352320894"

#define GAD_BANNER_UNIT_ID @"ca-app-pub-6497790326672925/6507372693"



#define TEST_DEVICES @[ @"1374246f09ebaf417a7f90451110ca70" ]




#import <Foundation/Foundation.h>
@interface AdConfig : NSObject{
    bool useOcp_;
    
    NSDictionary *_ol_config_;
    NSDictionary *local_config;
}

+ (AdConfig *)instance;

- (void) initConfig;

- (NSString *)getUnityID;

- (NSString *)getVungleID;

- (NSString *)getChartboostID;
- (NSString *)getChartboostSign;

- (NSString *)getGadInterstitialID;
- (NSString *)getGadRewardedVideoID;
- (NSString *)getGadBannerID;

@end


#endif /* AdDef_h */
