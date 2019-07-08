//
//  MiniappJumpUtil.h
//  miniapp-ios
//
//  Created by 刘流 on 2019/7/5.
//  Copyright © 2019 uhutu. All rights reserved.
//

#ifndef MiniappJumpUtil_h
#define MiniappJumpUtil_h
#import <UIKit/UIKit.h>
#import "MiniappEventDelegte.h"
@interface MiniappJumpUtil : NSObject
   
-(void)jumpUrl:(NSString *)sJumpUrl withView:(UIViewController *)view withDelegate: (id<MiniappEventDelegte>)miniappEventDelegte;
@end

#endif /* MiniappJumpUtil_h */
