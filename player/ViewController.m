//
//  ViewController.m
//  player
//
//  Created by 周超哲 on 2020/4/22.
//  Copyright © 2020 周超哲. All rights reserved.
//

#import "ViewController.h"
#import "JTPlayer.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
@interface ViewController ()<JTPlayerDelegate>
@property (nonatomic,strong) JTPlayer *player;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.player = [[JTPlayer alloc]init];
    _player.delegate = self;
    self.player.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
    [self.view addSubview:self.player];
    
    NSURL *url = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"Food" ofType:@"mp4"]];
    [self.player playWithUrl:url options: JTPlayerOptionsSoftDec];
}

- (IBAction)nextVideoAction:(id)sender {
    NSURL *url = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"Food" ofType:@"mp4"]];
    [self.player playWithUrl:url options: JTPlayerOptionsSoftDec];
}

- (IBAction)realtimeVideo:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://ivi.bupt.edu.cn/hls/cctv2.m3u8"];
    [self.player playWithUrl:url options: JTPlayerOptionsVideoToolbox];
}

- (IBAction)videotoolboxAction:(id)sender {
    NSURL *url = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"Food" ofType:@"mp4"]];
    [self.player playWithUrl:url options: JTPlayerOptionsVideoToolbox];
}

- (IBAction)logShowAction:(id)sender {
    [self.player showOrHideLogHUD];
}

- (void)playerDidPlayFailedWithMessage:(NSString *)failMesssage{
    UIAlertController *failAlert = [UIAlertController alertControllerWithTitle:nil message:failMesssage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [failAlert addAction:confirm];
    [self presentViewController:failAlert animated:YES completion:nil];
}

@end
