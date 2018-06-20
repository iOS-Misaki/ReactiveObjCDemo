//
//  ViewModel.m
//  demo
//
//  Created by 余意 on 2018/6/20.
//  Copyright © 2018年 余意. All rights reserved.
//

#import "ViewModel.h"
#import "NetworkTool.h"

@implementation ViewModel

- (instancetype)init
{
    if (self)
    {
        self = [super init];
        
        RACSignal * mobileSignal = [RACObserve(self, mobile) map:^id (NSString *  value) {
            
            return @(value.length == 11);
        }];
        
        RACSignal * psdSignal = [RACObserve(self, password) map:^id _Nullable(NSString *  _Nullable value) {
            
            return @(value.length >= 6);
        }];
        
        RACSignal * loginSignal = [RACSignal combineLatest:@[mobileSignal,psdSignal] reduce:^id (NSNumber * num1,NSNumber * num2){
            return @([num1 boolValue] && [num2 boolValue]);
        }];
        
        _loginCommand = [[RACCommand alloc]initWithEnabled:loginSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [NetworkTool loginWithMobile:self.mobile WithPassword:self.password];
        }];
    }
    return self;
}




























@end
