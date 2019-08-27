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
#import "MiniappEventDelegate.h"
@interface MiniappJumpUtil : NSObject



/**
 跳转页面地址  注意：在调用这个方法前需要实现MiniappEventDelegate协议并绑定到MiniappEventInstance

 @param sJumpUrl 跳转地址
 @param view 视图显示
 */
-(void)jumpUrl:(NSString *)sJumpUrl withView:(UIViewController *)view ;





-(void)sendNativeNotice:(NSString *)sListenerName withDic:(NSMutableDictionary *)dic;


@end

#endif /* MiniappJumpUtil_h */
