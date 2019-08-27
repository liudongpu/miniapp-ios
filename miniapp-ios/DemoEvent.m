//
//  DemoEvent.m
//  miniapp-ios
//
//  Created by 刘流 on 2019/7/5.
//  Copyright © 2019 uhutu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DemoEvent.h"

#import "Miniapp/MiniappNoticeBridge.h"

@implementation  DemoEvent

+ (instancetype)sharedInstance{
    static DemoEvent * abc;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        abc = [[DemoEvent alloc] init];
    });
    return abc;
}



    
    -(MiniappModelUser*) upNativeUserInfo{
        
        MiniappModelUser *user=[MiniappModelUser new];
        user.token=@"bc931aea6bb4acd8081de24679c2e5d9";

        return user;
    }
    
    -(NSString*) upRequestUrl{
        return @"http://icomeminiapp.srnpr.com/mapps/version/%@/beta_ios.json";
        //return @"http://localhost:8870/build/version/%@/alpha_ios.json";
    }


- (void)jumpWtihParam:(NSDictionary *)sJson {
    
    
    MiniappNoticeBridge *bridge=[MiniappNoticeBridge new];
    
     
    
    [bridge sendNativeNotice:@"fdafdaf"];
    
    
    
}

    
@end
