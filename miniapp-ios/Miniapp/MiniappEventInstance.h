//
//  MiniappEventInstance.h
//  miniapp-ios
//
//  Created by 刘流 on 2019/7/8.
//  Copyright © 2019 uhutu. All rights reserved.
//

#ifndef MiniappEventInstance_h
#define MiniappEventInstance_h

#import "MiniappEventDelegate.h"

@interface MiniappEventInstance : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic,weak) id <MiniappEventDelegate> eventDelegate;

@end


#endif /* MiniappEventInstance_h */
