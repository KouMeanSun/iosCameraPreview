//
//  CameraPortaitPreviewController.m
//  CameraPreview
//
//  Created by 高明阳 on 2020/12/12.
//  Copyright © 2020 高明阳. All rights reserved.
//

#import "CameraPortaitPreviewController.h"
#import "MyCamera.h"

#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define ScreenWidth      UIScreen.mainScreen.bounds.size.width
#define ScreenHeight     UIScreen.mainScreen.bounds.size.height

@interface CameraPortaitPreviewController ()<MyCameraDelegate>
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) MyCamera *camera;
@property (nonatomic, strong) UIImageView *cameraImageView;
@end

@implementation CameraPortaitPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_camera startCapture];
}
-(void)commonInit{
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
      _camera = [[MyCamera alloc] initWithCameraPosition:AVCaptureDevicePositionBack captureFormat:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange];
      _camera.delegate = self;
       self.camera.videoOrientation = AVCaptureVideoOrientationPortrait;
    
    [self initViews];
}

-(void)initViews{
    
    [self.view addSubview:self.cameraImageView];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    CGFloat backButtonY = IPHONE_X ? 20 : 10;
    self.backButton.frame = CGRectMake(10, backButtonY, 60, 60);
    [self.backButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [self.view addSubview:self.backButton];
    [self.backButton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];

}


// handle sampleBuffer
- (void)projectionImagesWith:(CMSampleBufferRef)sampleBuffer {
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *ciImage = [CIImage imageWithCVImageBuffer:imageBuffer];
    UIImage *image = [UIImage imageWithCIImage:ciImage];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.cameraImageView.image = image;
    
    });
}

- (void)projectionImagesWithImage:(UIImage *)image {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.cameraImageView.image = image;
    });
}

- (void)clickBackButton {
    [_camera stopCapture];
    [self.navigationController popViewControllerAnimated:YES];
}


// Delegate
- (void)didOutputVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer {
   [self projectionImagesWith:sampleBuffer];
}


// lazy
- (UIImageView *)cameraImageView {
    if (_cameraImageView == nil) {
        _cameraImageView = [[UIImageView alloc] init];
        float scale = MAX(ScreenHeight / 1280, ScreenWidth / 720);
        float leftMargin = (720 * scale - ScreenWidth) / 2;
        float topMargin = (1280 * scale - ScreenHeight) / 2;
        _cameraImageView.bounds = CGRectMake(-leftMargin, 0, ScreenWidth + leftMargin * 2, ScreenHeight + topMargin * 2);
        _cameraImageView.center = self.view.center;
        
        
    }
    return _cameraImageView;
}
@end
