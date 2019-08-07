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


@interface MiniappViewController ()
    
    @end

@implementation MiniappViewController
    
    NSDictionary* dPrivateDict;
    
    
    MiniappStructModel* structModel;
    
-(void) initParam:(MiniappStructModel *)initStruct{
    structModel=initStruct;
}
    
- (BOOL)customizedEnabled{
    return NO;
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
    /*
     UIViewController *vc = [[UIViewController alloc] init];
     vc.view = rootView;
     [self presentViewController:vc animated:NO completion:nil];
     */
    //    UIViewController *vc = [[UIViewController alloc] init];
    //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    //    [self presentViewController:nav animated:NO completion:nil];
    
    
    self.view=rootView;
    
    
    
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
    /*
     #pragma mark - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
-(void)eventNotice:(NSNotification*) notification{
    
    NSDictionary *dic = (NSDictionary *)[notification object];
    //NSLog(@"eventNotice %@",[dic modelToJSONString]);
    
    
    NSString *sEventType=[dic objectForKey:@"eventType"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if([sEventType isEqualToString:@"nativeEventBack"]){
            [self.navigationController popViewControllerAnimated:NO];
            
        }else if([sEventType isEqualToString:@"nativeEventJump"]){
            
            NSString *sTargetUrl=[dic objectForKey:@"targetUrl"];
            //JumpUtil *jumpUtil=[JumpUtil new];
            //[jumpUtil jumpUrl:@"icome-miniapp://demo_one.app?a=1" withView:self];
            //[jumpUtil jumpUrl:sTargetUrl withView:self];
            
        }else if([sEventType isEqualToString:@"nativeEventHidenav"]){
            
            self.navigationController.navigationBar.hidden = YES;
            
        }else if([sEventType isEqualToString:@"nativeEventToast"]){
            
            NSString *message=[dic objectForKey:@"messageInfo"];
            
           // [MBProgressHUD py_showSuccess:message toView:self.view];
            
        }
    });
    
    
    
    //[self setLoginUI];
}
    
    
    //在控制器销毁的时候移除通知
-(void)dealloc{
    //移除通知有两种：1.移除所有通知；2.移除指定通知
    //1.移除所有通知
    //[[NSNotificationCenter defaultCenter]removeObserver:self];
    
    //2.移除指定通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MiniappNotificationEvent" object:nil];
    
}
    
    
    @end
