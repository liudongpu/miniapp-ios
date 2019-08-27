//
//  MiniappNoticeBridge.m
//  miniapp-ios
//
//  Created by 刘流 on 2019/8/27.
//  Copyright © 2019 uhutu. All rights reserved.
//


#import "MiniappNoticeBridge.h"

@implementation MiniappNoticeBridge

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"EventReminder"];
}

- (void)sendNativeNotice:(NSString *)notification
{
    
    [self sendEventWithName:@"EventReminder" body:@{@"name": notification}];
}

@end
