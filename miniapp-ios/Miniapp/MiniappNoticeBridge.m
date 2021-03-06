//
//  MiniappNoticeBridge.m
//  miniapp-ios
//
//  Created by 刘流 on 2019/8/27.
//  Copyright © 2019 uhutu. All rights reserved.
//


#import "MiniappNoticeBridge.h"

@implementation MiniappNoticeBridge{
    bool hasListeners;
    bool flagObserver;
}

RCT_EXPORT_MODULE();

- (void)startObserving
{
    if(!flagObserver)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(emitEventInternal:)
                                                     name:@"MiniappNotificationNotice"
                                                   object:nil];
        
        flagObserver=YES;
    }
    
    
    hasListeners = YES;
}
- (void)stopObserving
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    hasListeners = NO;
}


- (void)emitEventInternal:(NSNotification *)notification
{
    if (hasListeners) {
        
        NSError *parseError = nil;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:notification.object options:NSJSONWritingPrettyPrinted error:&parseError];
        
        NSString *sReturn= [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [self sendEventWithName:@"MiniappNoticeReminder"
                       body:sReturn];
    }
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"MiniappNoticeReminder"];
}

 
@end
