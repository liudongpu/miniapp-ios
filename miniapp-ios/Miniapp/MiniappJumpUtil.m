//
//  MiniappJumpUtil.m
//  miniapp-ios
//
//  Created by 刘流 on 2019/7/5.
//  Copyright © 2019 uhutu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MiniappJumpUtil.h"
#import <UIKit/UIKit.h>
#import "MiniappViewController.h"
#import "SSZipArchive.h"
#import <AFURLSessionManager.h>
#import <AFHTTPSessionManager.h>
#import "MiniappStructModel.h"
#import "MiniappEventInstance.h"
#import "MiniappViewController.h"
#import "MiniappHUD.h"
@interface MiniappJumpUtil ()

@end


@implementation MiniappJumpUtil

#pragma mark - Jump

- (void)jumpForDebugMiniapp:(NSString *)sJumpUrl
                   withView:(UIViewController *)view {
    
    MiniappStructModel* initModel=[[MiniappStructModel alloc] init];
    [initModel setBundlePath:@""];
    //这里特殊判断 如果调试url中存在http链接 则指定请求该http链接
    if([sJumpUrl containsString:@"http://"]) {
         [initModel setBundlePath:[sJumpUrl substringFromIndex:16]];
    }
    
    
    [initModel setBundleView:@"MiniappPoject"];
    [initModel setEnvUrl:sJumpUrl];
    [initModel setEnvName:@"alpha"];
    [initModel setMiniInfo:@"{\"id\":\"\",\"code\":\"0\",\"version\":\"0.0.0\"}"];
    [self openMiniapp:initModel withView:view];
}

- (void)openMiniapp:(MiniappStructModel*)initModel withView:(UIViewController *)view{
    MiniappViewController *mVC = [[MiniappViewController alloc] init];
    [mVC initParam:initModel];
    [view.navigationController pushViewController:mVC animated:YES];
}

- (void)jumpUrl:(NSString *)sJumpUrl withView:(UIViewController *)view {
    
    [MiniappHUD showLoading:YES];
    if([sJumpUrl hasPrefix:@"debug-miniapp://"]) {
        [self jumpForDebugMiniapp:sJumpUrl withView:view];
    } else {
        [self targetMiniapp:sJumpUrl withView:view ];
    }
}



-(void)sendNativeNotice:(NSString *)sListenerName withDic:(NSMutableDictionary *)dic{
    
    dic[@"miniapp_lisenter_name"]=sListenerName;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MiniappNotificationNotice" object:dic];
}




- (void)targetMiniapp:(NSString *)sJumpUrl withView:(UIViewController *)view  {
    
    NSRange rStartIndex = [sJumpUrl rangeOfString:@":"];
    NSString *sAfter=[sJumpUrl substringFromIndex:rStartIndex.location+3];
    NSRange rAppIndex=[sAfter rangeOfString:@".app"];
    NSString *sId= [sAfter substringToIndex:rAppIndex.location];
    NSString *sRequestUrl= [NSString stringWithFormat:[[MiniappEventInstance sharedInstance].eventDelegate upRequestUrl],sId];
    
    
    NSString *escapedString = [sJumpUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    sRequestUrl=[[sRequestUrl stringByAppendingString:@"?system_source="] stringByAppendingString:escapedString];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:sRequestUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);

        //iOS自带解析类NSJSONSerialization从response中解析出数据放到字典中
        NSDictionary *weatherDic = responseObject;
        
        MiniappStructModel* initModel=[[MiniappStructModel alloc] init];
        NSString *sPathRoot=[NSHomeDirectory() stringByAppendingString:@"/Documents/icome_miniapp/"];
        [initModel setPathBundle:[sPathRoot stringByAppendingString:@"bundle/"]];
        
        NSString *sPathFolder=[[initModel.pathBundle stringByAppendingString:[weatherDic objectForKey:@"folder" ]] stringByAppendingString:@"/"];
        [initModel setBundlePath:[sPathFolder stringByAppendingString:[weatherDic objectForKey:@"file"  ]]];
        
        [initModel setPathZip:[sPathRoot stringByAppendingString:@"zip/"]];
        
        [initModel setPathFolder:sPathFolder];
        [initModel setJsonUrl:[weatherDic objectForKey:@"url" ]];
        
        [initModel setBundleView:[weatherDic objectForKey:@"view" ]];
        
        [initModel setEnvUrl:sJumpUrl];
        [initModel setEnvName:[weatherDic objectForKey:@"env" ]];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:weatherDic options:0 error:0];
        
        NSString *sMiniInfo  =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        
        [initModel setMiniInfo:sMiniInfo];
        
        
        [self checkExec:initModel withView:view];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        [MiniappHUD showMessage:@"网络请求失败"];
    }];
}



/**
 检查然后执行模型
 
 @param initModel <#initModel description#>
 @param view <#view description#>
 */
-(void)checkExec:(MiniappStructModel*) initModel withView:(UIViewController *)view{
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSLog(@"file bundle %@",initModel.bundlePath);
    if ([fm fileExistsAtPath:initModel.bundlePath]) {
        [self openMiniapp:initModel withView:view];
        
    }
    else{
        
        if(![fm fileExistsAtPath:initModel.pathZip ]){
            [fm createDirectoryAtPath:initModel.pathZip withIntermediateDirectories:YES attributes:nil error:nil];
        }
        if(![fm fileExistsAtPath:initModel.pathBundle] ){
            [fm createDirectoryAtPath:initModel.pathBundle withIntermediateDirectories:YES attributes:nil error:nil];
        }
        if(![fm fileExistsAtPath:initModel.pathFolder ]){
            [fm createDirectoryAtPath:initModel.pathFolder withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        
        NSURL *url = [NSURL URLWithString:initModel.jsonUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        NSString *sNameZip=url.lastPathComponent;
        
        NSString *sFileZip = [initModel.pathZip stringByAppendingPathComponent:sNameZip];
        
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            
            return [NSURL fileURLWithPath:sFileZip];
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            
            if([fm fileExistsAtPath:filePath.path]){
                
                [SSZipArchive unzipFileAtPath:filePath.path toDestination:initModel.pathFolder progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
                    //                    // entry : 解压出来的文件名
                    //                    //entryNumber : 第几个, 从1开始
                    //                    //total : 总共几个
                    //                    NSLog(@"progressHandler:%@, , entryNumber:%ld, total:%ld", entry, entryNumber, total);
                } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
                    //                    //path : 被解压的压缩吧全路径
                    //                    //succeeded 是否成功
                    //                    // error 错误信息
                    //                    NSLog(@"completionHandler:%@, , succeeded:%d, error:%@", path, succeeded, error);
                    
                    if(succeeded==1){
                        [self openMiniapp:initModel withView:view];
                    }
                    
                }];
            }
            else{
                [MiniappHUD showMessage:@"网络请求失败"];
            }
        }];
        
        [downloadTask resume];
    }
}
@end


