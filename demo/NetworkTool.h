//
//  NetworkTool.h
//  demo
//
//  Created by 余意 on 2018/6/20.
//  Copyright © 2018年 余意. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface NetworkTool : NSObject

+ (RACSignal *)loginWithMobile:(NSString *)mobile WithPassword:(NSString *)password;

@end
