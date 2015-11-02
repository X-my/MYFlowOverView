//
//  ViewController.m
//  MYFlowOverView
//
//  Created by 梦阳 许 on 15/10/30.
//  Copyright © 2015年 梦阳 许. All rights reserved.
//

#import "ViewController.h"
#import "MYFlowOverView.h"

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

- (IBAction)buttonClicked:(UIButton *)sender {
    
    UIImageView* content = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"panda_bg"]];

    MYFlowOverView* flowOverView = [[MYFlowOverView alloc]initWithTargetView:sender contentView:content];
    
    flowOverView.flowDirection = sender.tag%2 ? MYFlowOverViewFlowDirectionDown : MYFlowOverViewFlowDirectionUp;
    
    [flowOverView show];
}
@end
