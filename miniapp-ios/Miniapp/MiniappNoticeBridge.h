//
//  MiniappNoticeBridge.h
//  miniapp-ios
//
//  Created by 刘流 on 2019/8/27.
//  Copyright © 2019 uhutu. All rights reserved.
//

#ifndef MiniappNoticeBridge_h
#define MiniappNoticeBridge_h



#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface MiniappNoticeBridge : RCTEventEmitter <RCTBridgeModule>

- (void)sendNativeNotice:(NSString *)notification;

@end


#endif /* MiniappNoticeBridge_h */
