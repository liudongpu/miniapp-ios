//
//  MiniappEventDelegte.h
//  miniapp-ios
//
//  Created by 刘流 on 2019/7/5.
//  Copyright © 2019 uhutu. All rights reserved.
//
#import "MiniappModelUser.h"
#ifndef MiniappEventDelegate_h
#define MiniappEventDelegate_h

@protocol MiniappEventDelegate <NSObject>

-(MiniappModelUser*) upNativeUserInfo;


-(NSString*) upRequestUrl;

-(void)jumpWtihParam:(NSDictionary *)sJson;

@end

#endif /* MiniappEventDelegte_h */
