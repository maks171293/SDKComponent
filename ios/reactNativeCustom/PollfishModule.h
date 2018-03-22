//
//  PollfishModule.h
//  reactNativeCustom
//
//  Created by Taras Galagodza on 3/18/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <React/RCTConvert.h>

@interface PollfishModule : RCTEventEmitter <RCTBridgeModule>
@end

@interface RCTConvert (PollfishModule_Constants)
@end
