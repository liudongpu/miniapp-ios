//
//  MiniappDownloadService.h
//  miniapp-ios
//
//  Created by liufan on 2019/8/23.
//  Copyright © 2019年 uhutu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MiniappStructModel.h"

@protocol MiniappDownloadServiceDelegate <NSObject>
- (void)finishData:(MiniappStructModel *)model;
@end

@interface MiniappDownloadService : NSObject

@property (nonatomic, weak) id <MiniappDownloadServiceDelegate> delegate;

/**
 跳转页面地址  注意：在调用这个方法前需要实现MiniappEventDelegate协议并绑定到MiniappEventInstance
 
 @param sJumpUrl 跳转地址
 */
-(void)jumpUrl:(NSString *)sJumpUrl;

@end
