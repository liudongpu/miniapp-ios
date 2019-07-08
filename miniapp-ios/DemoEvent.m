//
//  DemoEvent.m
//  miniapp-ios
//
//  Created by 刘流 on 2019/7/5.
//  Copyright © 2019 uhutu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Miniapp/MiniappEventDelegte.h"
#import "DemoEvent.h"
@implementation  DemoEvent

    
    -(NSString*) upNativeUserInfo{
        return @"abc";
    }
    
    -(NSString*) upRequestUrl{
        //return @"http://icomeminiapp.srnpr.com/mapps/version/%@/beta_ios.json";
        return @"http://localhost:8870/build/version/%@/alpha_ios.json";
    }
    
@end
