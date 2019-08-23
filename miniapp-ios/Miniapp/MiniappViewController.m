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
#import "MiniappDownloadService.h"
#import "MBProgressHUD.h"
@interface MiniappViewController ()<MiniappDownloadServiceDelegate> {
    
    MiniappDownloadService *downloadService;
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

- (void)finishData:(MiniappStructModel *)model {

    [self initParam:model];
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
    self.view=rootView;
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    downloadService = [[MiniappDownloadService alloc] init];
    downloadService.delegate = self;
    [downloadService jumpUrl:self.jumpURL];
    
    [self showLoading:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:(UIBarButtonItemStyleDone) target:self action:nil];
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
            [self.navigationController popViewControllerAnimated:NO];
            
        }else if([sEventType isEqualToString:@"nativeEventHidenav"]){
            
            self.navigationController.navigationBar.hidden = YES;
            
        }else if([sEventType isEqualToString:@"nativeEventToast"]){
            [self showMessage:dic[@"msg"]];
        }else if([sEventType isEqualToString:@"nativeEventLoadClose"]){
            [self showLoading:NO];
        }else if([sEventType isEqualToString:@"nativeEventLoadOpen"]){
            [self showLoading:YES];
        }
    });
}


- (void)showLoading:(BOOL)show{
    
    UIWindow *view = [UIApplication sharedApplication].keyWindow;
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    MBProgressHUD *hudView = nil;
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:[MBProgressHUD class]]) {
             hudView = (MBProgressHUD *)subview;
            [hudView hideAnimated:YES];
        }
    }
    
    if (show) {
        // 快速显示一个提示信息
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.removeFromSuperViewOnHide =  YES;
    }
}


- (void)showMessage:(NSString *)message {
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.removeFromSuperViewOnHide = YES;
    hud.backgroundView.color = [UIColor clearColor];
    [hud hideAnimated:YES afterDelay:1.5];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MiniappNotificationEvent" object:nil];
}
@end
