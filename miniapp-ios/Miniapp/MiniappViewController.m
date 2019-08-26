//
//  MiniappViewController.m
//  iComeKernel
//
//  Created by 刘流 on 2018/7/11.
//  Copyright © 2018年 XZWL. All rights reserved.
//

#import "MiniappViewController.h"
#import <React/RCTRootView.h>
#import <React/RCTBundleURLProvider.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "MiniappStructModel.h"
#import "MiniappEventInstance.h"
#import "MiniappHUD.h"

@interface MiniappViewController () {
    NSDictionary* dPrivateDict;
    MiniappStructModel* structModel;
}
@end

@implementation MiniappViewController

- (void)initParam:(MiniappStructModel *)initStruct {
    structModel=initStruct;
}
    
- (BOOL)customizedEnabled {
    return NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(eventNotice:) name: @"MiniappNotificationEvent" object: nil];
    
    NSString *sBundleUrl=[structModel bundlePath];
    NSString *sBundleView=[structModel bundleView];
    // Do any additional setup after loading the view.
    NSLog(@"bundle file %@",sBundleUrl);
    NSURL *jsCodeLocation = [NSURL URLWithString:sBundleUrl];
    
    if(sBundleUrl.length==0){
        jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
    }
    
    structModel.userToken=[[MiniappEventInstance  sharedInstance].eventDelegate upNativeUserInfo].token ;
    
    NSString *structjson=  [structModel toJSONString];
    
    // Do any additional setup after loading the view.
    //NSLog(@"structjson %@",structjson);
    
    RCTRootView *rootView =
    [[RCTRootView alloc] initWithBundleURL: jsCodeLocation
                                moduleName: sBundleView
                         initialProperties:
     @{
       @"initapp" : structjson
       }
                             launchOptions: nil];
    
    
    self.view = rootView;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:(UIBarButtonItemStyleDone) target:self action:nil];
    self.view.backgroundColor = [UIColor whiteColor];
}
    
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
    
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

    
-(void)eventNotice:(NSNotification*) notification{
    
    NSDictionary *dic = (NSDictionary *)[notification object];
    //NSLog(@"eventNotice %@",[dic modelToJSONString]);
    
    
    NSString *sEventType=[dic objectForKey:@"eventType"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if([sEventType isEqualToString:@"nativeEventBack"]){
            [self.navigationController popViewControllerAnimated:YES];
            
        }else if([sEventType isEqualToString:@"nativeEventHidenav"]){
            
            self.navigationController.navigationBar.hidden = YES;
            
        }else if([sEventType isEqualToString:@"nativeEventToast"]){
            [MiniappHUD showMessage:dic[@"messageInfo"]];
        }else if([sEventType isEqualToString:@"nativeEventLoadClose"]){
            [MiniappHUD showLoading:NO];
        }else if([sEventType isEqualToString:@"nativeEventLoadOpen"]){
            [MiniappHUD showLoading:YES];
        }
    });
}





-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MiniappNotificationEvent" object:nil];
}
@end
