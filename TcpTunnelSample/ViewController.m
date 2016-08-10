//
//  ViewController.m
//  TcpTunnelSample
//
//  Created by hirauchi.shinichi on 2016/08/10.
//  Copyright © 2016年 SAPPOROWORKS. All rights reserved.
//

#import "ViewController.h"
#import "TcpTunnel.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;
@property (nonatomic) BOOL isRunning;
@property (nonatomic) TcpTunnel *tcpTunnel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isRunning = false;
    self.tcpTunnel = [TcpTunnel new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Action

- (IBAction)startStopButtonTaped:(id)sender {
    if ( self.isRunning) {
        [self stop];
    }
    else{
        [self start];
    }
}

#pragma mark - Private Method

- (void) start {
    [self.tcpTunnel start];

    [_startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
    self.view.backgroundColor =  [UIColor orangeColor];
    self.isRunning = true;
}

- (void) stop {
    [self.tcpTunnel stop];

    [_startStopButton setTitle:@"Start" forState:UIControlStateNormal];
    self.view.backgroundColor =  [UIColor whiteColor];
    self.isRunning = false;
}

@end
