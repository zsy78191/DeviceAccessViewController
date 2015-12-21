//
//  ViewController.m
//  DeviceAccessDemo
//
//  Created by 张超 on 15/12/17.
//  Copyright © 2015年 gerinn. All rights reserved.
//

#import "ViewController.h"
#import "DeviceAccessViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)open:(id)sender {
    DeviceAccessViewController* avc = [[DeviceAccessViewController alloc] initWithNibName:@"DeviceAccessViewController" bundle:[NSBundle mainBundle]];
    [self presentViewController:avc animated:YES completion:nil];
}

@end
