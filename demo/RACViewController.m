//
//  RACViewController.m
//  demo
//
//  Created by 余意 on 2018/6/20.
//  Copyright © 2018年 余意. All rights reserved.
//

#import "RACViewController.h"

@interface RACViewController ()

@end

@implementation RACViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.subject) {
        [self.subject sendNext:@1];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)RACSignal
{
    //1 创建信号
    RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        //3 发送信号
        [subscriber sendNext:@"发送信号"];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"取消订阅");
        }];
//        return nil;
    }];
    
    //2 订阅信号
    RACDisposable * disposable = [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //4 取消订阅
    [disposable dispose];
}

- (void)RACSubject
{
    //RACSubject必须先订阅才能发送  RACReplaySubject可以先发送后订阅
    
    //1 创建信号
    RACSubject * subject = [RACSubject subject];
    
    //2 订阅信号
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //3 发送信号
    [subject sendNext:@"发送信号"];
}

- (void)RACSequence
{
    //遍历
    
    NSArray * array = @[@"1",@"2",@"3",@"3",@"5"];
    [array.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //元祖
    RACTuple * tuple = RACTuplePack(array);
    NSLog(@"%@",tuple[0]);
    NSLog(@"%@",[tuple first]);
    NSLog(@"%@",[tuple last]);
    
    NSDictionary * dict = @{@"key1":@"value1",@"key2":@"value2"};
    [dict.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        RACTupleUnpack(NSString * key,NSString * value) = x;
        NSLog(@"%@  %@",key,value);
    }];
    
    //替换数组的元素 生成新的数组 单个操作
    NSArray * newArray1 = [[array.rac_sequence map:^id _Nullable(id  _Nullable value) {
        return @"0";
    }] array];
    NSLog(@"%@",newArray1);
    
    //替换数组的元素 生成新的数组 全部操作
    NSArray * newArray2 = [[array.rac_sequence mapReplace:@"1"] array];
    NSLog(@"%@",newArray2);
}

- (void)RACMulticastConnection
{
    /*
     * ReactiveCocoa中信号默认都是冷的，每次有新的订阅者订阅信号的时候都会执行信号创建时传入的block
     * 举个例子 一个网络请求的结果为信号 多个UI都订阅了这个信号 那么每次订阅 都会进行一次网络请求
     * 避免这种情况用RACMulticastConnection
     */
    
    //多个订阅者 只发一个信号
    RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"发送信号"];
        return nil;
    }];
    
    //创建链接类
    RACMulticastConnection * connection = [signal publish];
    
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //连接 把信号源变为热信号
    [connection connect];
}

- (void)RACCommand
{
    //命令 事件的执行
    /*
     * 一般用于监听按钮点击、网络请求
     * - (id)initWithSignalBlock:(RACSignal * (^)(id input))signalBlock;
     * - (id)initWithEnabled:(RACSignal *)enabledSignal signalBlock:(RACSignal * (^)(id input))signalBlock;
     * 两者的区别是第二个 加了一个BOOL事件的信号 相当于过滤的作用
     */
    
    
    //1 创建命令 不能返回空的信号
    RACCommand * command = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        //执行命令的时候就会调用 input执行命令的参数
        NSLog(@"%@",input);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"执行命令"];
            return nil;
        }];
    }];
    
    
    //执行命令
    RACSignal * signal = [command execute:@"0"];
    //再订阅
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    
    
    //或者 和刚才的区别在于先订阅和后订阅
    [command.executionSignals subscribeNext:^(id  _Nullable x) {
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"%@",x);
        }];
    }];
    [command execute:@"0"];
    
    //或者 还有一种做法switchToLatest获取最新发送的信号
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [command execute:@"0"];
}

- (void)Notification
{
    //不用写removeObserver
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"NotificationName" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (void)KVO
{
    [[self.view rac_valuesForKeyPath:@"color" observer:self] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (void)UI
{
    UITextField * tf = [UITextField new];
    UITextField * tf2 = [UITextField new];
    UIButton * btn = [UIButton new];
    
    [[tf rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //filter 和 ignore
    [[[tf2.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        return value.length > 6;
    }] ignore:@"666"] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //响应事件
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //两个输入框长度大于3的时候 按钮才可以点击
    RAC(btn,enabled) = [RACSignal combineLatest:@[tf.rac_textSignal,tf2.rac_textSignal] reduce:^id (NSString * str1, NSString * str2){
        return @(str1.length > 3 && str2.length > 3);
    }];
}

- (void)Timer
{
    RACDisposable * disposable = [[RACSignal interval:1.f onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        //当前时间
        NSLog(@"%@",x);
        
        [disposable dispose];
    }];
}

- (void)merge
{
    RACSubject * subject1 = [RACSubject subject];
    RACSubject * subject2 = [RACSubject subject];
    RACSubject * subject3 = [RACSubject subject];
    
    [[RACSignal merge:@[subject1,subject2,subject3]] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [subject1 sendNext:@"subject1"];
    [subject2 sendNext:@"subject2"];
    [subject3 sendNext:@"subject3"];
}

- (void)group
{
    //类似于GCD的任务组
    RACSignal * signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        /*网络请求1*/
        [subscriber sendNext:@"请求1完成"];
        return nil;
    }];
    
    RACSignal * signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        /*网络请求2*/
        [subscriber sendNext:@"请求2完成"];
        return nil;
    }];
    
    [self rac_liftSelector:@selector(dependSignalA:WithSignalB:) withSignalsFromArray:@[signalA,signalB]];
}

- (void)dependSignalA:(NSString *)str1 WithSignalB:(NSString *)str2
{
    
}


@end
