//
//  ViewController.m
//  demo
//
//  Created by 余意 on 2018/5/24.
//  Copyright © 2018年 余意. All rights reserved.
//

#import "ViewController.h"

#import "MBProgressHUD.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "ViewModel.h"
#import "RACViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *mobileTF;
@property (weak, nonatomic) IBOutlet UITextField *psdTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (nonatomic,strong) ViewModel * viewModel;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.viewModel = [[ViewModel alloc]init];
    
    RAC(self.viewModel,mobile) = self.mobileTF.rac_textSignal;
    RAC(self.viewModel,password) = self.psdTF.rac_textSignal;
    self.loginBtn.rac_command = self.viewModel.loginCommand;
    
    @weakify(self)
    [[self.viewModel.loginCommand executionSignals] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [x subscribeNext:^(NSDictionary *  _Nullable x) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"%@  %@",x[@"mobile"],x[@"password"]);
            
            RACViewController * vc = [[RACViewController alloc]init];
            vc.subject = [RACSubject subject];
            [vc.subject subscribeNext:^(id  _Nullable x) {
                NSLog(@"%@",x);
            }];
            [self presentViewController:vc animated:YES completion:nil];
        }];
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)login:(id)sender {
    
}





@end
