//
//  MiniappEventDelegte.h
//  miniapp-ios
//
//  Created by 刘流 on 2019/7/5.
//  Copyright © 2019 uhutu. All rights reserved.
//

#ifndef MiniappEventDelegte_h
#define MiniappEventDelegte_h

@protocol MiniappEventDelegte <NSObject>

    @required
    -(NSString*) upNativeUserInfo;
    
    
    @required
    -(NSString*) upRequestUrl;
    
@end

#endif /* MiniappEventDelegte_h */
