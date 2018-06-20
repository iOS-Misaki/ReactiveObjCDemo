//
//  NetworkTool.m
//  demo
//
//  Created by 余意 on 2018/6/20.
//  Copyright © 2018年 余意. All rights reserved.
//

#import "NetworkTool.h"

@implementation NetworkTool

+ (RACSignal *)loginWithMobile:(NSString *)mobile WithPassword:(NSString *)password
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //模拟网络请求
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@{@"mobile":mobile,@"password":password}];
            [subscriber sendCompleted];
        });
        
        return nil;
    }];
}

@end
