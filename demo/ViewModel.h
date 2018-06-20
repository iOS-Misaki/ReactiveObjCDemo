//
//  ViewModel.h
//  demo
//
//  Created by 余意 on 2018/6/20.
//  Copyright © 2018年 余意. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface ViewModel : NSObject

@property (nonatomic,copy) NSString * mobile;
@property (nonatomic,copy) NSString * password;

@property (nonatomic,strong,readonly) RACCommand * loginCommand;

@end
