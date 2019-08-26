//
//  MiniappHUD.h
//  miniapp-ios
//
//  Created by liufan on 2019/8/26.
//  Copyright © 2019年 uhutu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MiniappHUD : NSObject

+ (void)showMessage:(NSString *)message;

+ (void)showLoading:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
