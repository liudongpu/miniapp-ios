//
//  MiniappEventInstance.m
//  miniapp-ios
//
//  Created by 刘流 on 2019/7/8.
//  Copyright © 2019 uhutu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MiniappEventInstance.h"


@implementation MiniappEventInstance


+ (instancetype)sharedInstance{
    static MiniappEventInstance * abc;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        abc = [[MiniappEventInstance alloc] init];
    });
    return abc;
}


@end
