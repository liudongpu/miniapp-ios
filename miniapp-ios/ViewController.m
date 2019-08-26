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
//    [miniJump jumpUrl:@"icome-miniapp://demo_one.app?a=1" withView:self ];
    [miniJump jumpUrl:@"debug-miniapp://" withView:self ];
    
}
    
    @end
