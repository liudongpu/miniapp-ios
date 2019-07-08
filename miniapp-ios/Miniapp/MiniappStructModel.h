//
//  MiniappStructModel.h
//  iComeKernel
//
//  Created by 刘流 on 2018/7/17.
//  Copyright © 2018年 XZWL. All rights reserved.
//
#import "JSONModel.h"

#ifndef MiniappStructModel_h
#define MiniappStructModel_h


@interface MiniappStructModel : JSONModel

/*
 private String userToken;
 
 private String userName;
 
 
 private String appVersion;
 
 private String bundlePath;
 
 
 private String bundleView;
 
 private String envName;
 
 private String envUrl;
 */



@property (nonatomic,copy) NSString *bundlePath;


@property (nonatomic,copy) NSString *bundleView;

@property (nonatomic,copy) NSString *userToken;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *appVersion;
@property (nonatomic,copy) NSString *envName;
@property (nonatomic,copy) NSString *envUrl;

@property (nonatomic,copy) NSString *miniInfo;


@property (nonatomic,copy) NSString *pathZip;
@property (nonatomic,copy) NSString *pathBundle;
@property (nonatomic,copy) NSString *pathFolder;


@property (nonatomic,copy) NSString *jsonUrl;

@end

#endif /* MiniappStructModel_h */
