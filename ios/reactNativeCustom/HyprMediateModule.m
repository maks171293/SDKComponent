//
//  HyprMediateModule.m
//  reactNativeCustom
//
//  Created by Taras Galagodza on 3/18/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "HyprMediateModule.h"
#import <HyprMediate/HyprMediate.h>

@interface HyprMediateModule() <HyprMediateDelegate>

@end

@implementation HyprMediateModule

RCT_EXPORT_MODULE();

- (void)dealloc
{
  [HYPRMediate setDelegate: nil];
}

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

- (id)init
{
  self = [super init];
  if (self != nil) {
    [HYPRMediate setDelegate: self];
  }
  return self;
}

- (NSArray<NSString *> *)supportedEvents
{
  return @[@"HyprMediateCanShowAd", @"HyprMediateRewardDelivered", @"HyprMediateErrorOccurred", @"HyprMediateAdStarted", @"HyprMediateAdFinished", @"HyprMediateInitializationComplete"];
}

RCT_EXPORT_METHOD(initializeWithDefaultUserId:(NSString *)developerKey)
{
  NSString *userIdStorageKey = @"hyprMediateUserId";
  NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:userIdStorageKey];
  if (!userId) {
    userId = [[NSUUID UUID] UUIDString];
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:userIdStorageKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
  }

  [HYPRMediate initialize:developerKey userId:userId];
}

RCT_EXPORT_METHOD(initialize:(NSString *)developerKey userId:(NSString *)userId)
{
  [HYPRMediate initialize:developerKey userId:userId];
}

RCT_EXPORT_METHOD(showAd)
{
  [HYPRMediate showAd];
}

RCT_EXPORT_METHOD(checkInventory)
{
  [HYPRMediate checkInventory];
}

RCT_EXPORT_METHOD(setUserId:(NSString *)userId)
{
  [HYPRMediate setUserId:userId];
}

- (void)hyprMediateCanShowAd:(BOOL)adCanBeDisplayed
{
  [self sendEventWithName:@"HyprMediateCanShowAd" body:@{}];
}

- (void)hyprMediateRewardDelivered:(HYPRMediateReward *)reward
{
  [self sendEventWithName:@"HyprMediateRewardDelivered" body:@{}];
}

- (void)hyprMediateErrorOccurred:(HYPRMediateError *)error
{
  [self sendEventWithName:@"HyprMediateErrorOccurred" body:@{}];
}

- (void)hyprMediateAdStarted
{
  [self sendEventWithName:@"HyprMediateAdStarted" body:@{}];
}

- (void)hyprMediateAdFinished
{
  [self sendEventWithName:@"HyprMediateAdFinished" body:@{}];
}

- (void)hyprMediateInitializationComplete
{
  [self sendEventWithName:@"HyprMediateInitializationComplete" body:@{}];
}

@end
