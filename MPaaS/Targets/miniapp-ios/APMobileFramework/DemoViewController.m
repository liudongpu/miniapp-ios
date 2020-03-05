//
//  DemoViewController.m
//  test
//
//  Created by mPaaS on 16/11/21.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "DemoViewController.h"

@interface DemoViewController ()

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(130, self.view.bounds.size.height/2-60, self.view.bounds.size.width-60, 40)];
    label.text = @"Hello World!";
    label.font = [UIFont systemFontOfSize:30];
    label.textColor = [UIColor redColor];
    
    label.userInteractionEnabled=YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
       
    [label addGestureRecognizer:labelTapGestureRecognizer];

    
    
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
   
   UILabel *label=(UILabel*)recognizer.view;
   
   NSLog(@"%@被点击了",label.text);
    
    [MPNebulaAdapterInterface startTinyAppWithId:@"1001100110011001" params:nil];

   
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
