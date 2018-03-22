//
//  PollfishModule.m
//  reactNativeCustom
//
//  Created by Taras Galagodza on 3/18/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "PollfishModule.h"
#import <pollfish/pollfish.h>
#import <React/RCTConvert.h>

@implementation RCTConvert (PollfishModule_Constants)

RCT_ENUM_CONVERTER(PollfishPosition, (@{@"PollFishPositionTopLeft" : @(PollFishPositionTopLeft),
                                        @"PollFishPositionTopRight" : @(PollFishPositionTopRight),
                                        @"PollFishPositionBottomLeft" : @(PollFishPositionBottomLeft),
                                        @"PollFishPositionBottomRight" : @(PollFishPositionBottomRight),
                                        @"PollFishPositionMiddleLeft" : @(PollFishPositionMiddleLeft),
                                        @"PollFishPositionMiddleRight" : @(PollFishPositionMiddleRight)
                                        }), PollFishPositionTopLeft, integerValue)
@end

@implementation PollfishModule

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
  self = [super init];
  if (self != nil) {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pollfishNotAvailable) name:@"PollfishSurveyNotAvailable" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pollfishOpened) name:@"PollfishOpened" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pollfishClosed) name:@"PollfishClosed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pollfishUsernotEligible) name:@"PollfishUserNotEligible" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pollfishCompleted:) name:@"PollfishSurveyCompleted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pollfishReceived:) name:@"PollfishSurveyReceived" object:nil];
  }
  return self;
}

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

- (NSArray<NSString *> *)supportedEvents
{
  return @[@"PollfishCompleted", @"PollfishReceived", @"PollfishOpened", @"PollfishClosed", @"PollfishNotAvailable", @"PollfishUsernotEligible"];
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(initialize:(NSString *)developerKey withPadding:(int)padding position:(PollfishPosition)pollfishPosition customMode:(BOOL)customMode)
{
  [Pollfish initAtPosition: pollfishPosition
               withPadding: padding
           andDeveloperKey: developerKey
             andDebuggable: YES
             andCustomMode: customMode];
}

RCT_EXPORT_METHOD(show)
{
  [Pollfish show];
}

RCT_EXPORT_METHOD(hide)
{
  [Pollfish hide];
}

RCT_EXPORT_METHOD(isPollfishPresent:(RCTResponseSenderBlock)callback)
{
  if (callback) {
    callback(@[ @([Pollfish isPollfishPresent]) ]);
  }
}

- (void)pollfishCompleted:(NSNotification *)notification
{
  BOOL playfulSurvey = [[[notification userInfo] valueForKey:@"playfulSurvey"] boolValue];
  int surveyPrice = [[[notification userInfo] valueForKey:@"surveyPrice"] intValue];
  [self sendEventWithName:@"PollfishCompleted" body:@{@"playfulSurvey" : @(playfulSurvey), @"surveyPrice" : @(surveyPrice)}];
}

- (void)pollfishReceived:(NSNotification *)notification
{
  BOOL playfulSurvey = [[[notification userInfo] valueForKey:@"playfulSurvey"] boolValue];
  int surveyPrice = [[[notification userInfo] valueForKey:@"surveyPrice"] intValue];
  [self sendEventWithName:@"PollfishReceived" body:@{@"playfulSurvey" : @(playfulSurvey), @"surveyPrice" : @(surveyPrice)}];
}

- (void)pollfishOpened
{
  [self sendEventWithName:@"PollfishOpened" body:@{}];
}

- (void)pollfishClosed
{
  [self sendEventWithName:@"PollfishClosed" body:@{}];
}

- (void)pollfishNotAvailable
{
  [self sendEventWithName:@"PollfishNotAvailable" body:@{}];
}

- (void)pollfishUsernotEligible
{
  [self sendEventWithName:@"PollfishUsernotEligible" body:@{}];
}

@end
