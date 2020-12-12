//
//  ViewController.m
//  CameraPreview
//
//  Created by 高明阳 on 2020/12/12.
//  Copyright © 2020 高明阳. All rights reserved.
//

#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})


#define ScreenWidth      UIScreen.mainScreen.bounds.size.width
#define ScreenHeight     UIScreen.mainScreen.bounds.size.height


#import "ViewController.h"
#import "AppDelegate.h"
#import "CameraPortaitPreviewController.h"
#import "CameraLandscapePreviewController.h"

@interface ViewController ()
@property (nonatomic,strong)UIButton *startCamertPortaitButton;
@property (nonatomic,strong)UIButton *startCameraLandscapeButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self commonInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).allowRotation = NO;
    [UIDevice.currentDevice setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
}
-(void)commonInit{
    [self initViews];
}

-(void)initViews{
    self.title = @"相机预览";
    self.startCamertPortaitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.startCamertPortaitButton.backgroundColor = [UIColor blueColor];
    [self.startCamertPortaitButton setTitle:@"相机预览 竖屏" forState:UIControlStateNormal];
    self.startCamertPortaitButton.frame = CGRectMake(10, 10, 200, 60);
    self.startCamertPortaitButton.center = CGPointMake(ScreenWidth/2, ScreenHeight-300);
    [self.view addSubview:self.startCamertPortaitButton];
    [self.startCamertPortaitButton addTarget:self action:@selector(clickPortaitButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.startCameraLandscapeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.startCameraLandscapeButton.backgroundColor = [UIColor blueColor];
    [self.startCameraLandscapeButton setTitle:@"相机预览 横屏" forState:UIControlStateNormal];
    self.startCameraLandscapeButton.frame = CGRectMake(10, 10, 200, 60);
    self.startCameraLandscapeButton.center = CGPointMake(ScreenWidth/2, ScreenHeight-200);
    [self.view addSubview:self.startCameraLandscapeButton];
    [self.startCameraLandscapeButton addTarget:self action:@selector(clickLandscapeButton) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)clickPortaitButton {
    CameraPortaitPreviewController *vc = [[CameraPortaitPreviewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickLandscapeButton {
    CameraLandscapePreviewController *vc = [[CameraLandscapePreviewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
