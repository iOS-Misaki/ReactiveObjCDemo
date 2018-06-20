//
//  RACViewController.h
//  demo
//
//  Created by 余意 on 2018/6/20.
//  Copyright © 2018年 余意. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <ReactiveObjC/ReactiveObjC.h>

@interface RACViewController : UIViewController

@property (nonatomic,strong) RACSubject * subject;

@end
