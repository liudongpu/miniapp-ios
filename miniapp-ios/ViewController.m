//
//  ViewController.m
//  miniapp-ios
//
//  Created by 刘流 on 2019/7/5.
//  Copyright © 2019 uhutu. All rights reserved.
//

#import "ViewController.h"
#import "Miniapp/MiniappJumpUtil.h"
#import "DemoEvent.h"
#import "MiniappEventInstance.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


    

    
- (IBAction)jumpUrl:(id)sender {

    [MiniappEventInstance  sharedInstance].eventDelegate =[DemoEvent sharedInstance];
    
     MiniappJumpUtil *miniJump=[MiniappJumpUtil new];
    //[miniJump jumpUrl:@"icome-miniapp://demo_one.app?system_uec-init_router=url%3ffield_a1%3d%e5%ad%97%e6%ae%b5%e4%b8%80%e5%8f%b7%26field_a2%3d%e5%ad%97%e6%ae%b5%e4%ba%8c%e5%8f%b7" withView:self ];
    [miniJump jumpUrl:@"debug-miniapp://" withView:self ];
    
}
    
    @end
