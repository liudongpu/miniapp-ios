//
//  DemoEvent.h
//  miniapp-ios
//
//  Created by 刘流 on 2019/7/5.
//  Copyright © 2019 uhutu. All rights reserved.
//

#ifndef DemoEvent_h
#define DemoEvent_h
#import <Foundation/Foundation.h>
#import "Miniapp/MiniappEventDelegate.h"

@interface DemoEvent : NSObject<MiniappEventDelegate>
    + (instancetype)sharedInstance;
@end

#endif /* DemoEvent_h */
