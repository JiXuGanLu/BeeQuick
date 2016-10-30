//
//  YBZYScanView.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/27.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYScanView.h"
#import <AVFoundation/AVFoundation.h>

static CGFloat borderRatio = 0.15;

@interface YBZYScanView () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, assign) CGRect scanWindowRect;

@end

@implementation YBZYScanView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = true;
    self.layer.masksToBounds = true;
    
    //管理对象
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    self.session = session;
    
    //输入设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    //输出
    AVCaptureMetadataOutput *dataOutput = [[AVCaptureMetadataOutput alloc] init];
    [dataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    if ([self.session canAddInput:deviceInput]) {
        [self.session addInput:deviceInput];
    }
    if ([self.session canAddOutput:dataOutput]) {
        [self.session addOutput:dataOutput];
        dataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    }
    
    //摄像头实时图像
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = self.bounds;
    [self.layer addSublayer:previewLayer];
    
    //扫描区域
    CGFloat scanWindowWH = YBZYScreenWidth * (1 - 2 * borderRatio);
    CGFloat minYRatio = (self.height - scanWindowWH) * 0.5 / self.height;
    CGFloat maxYRatio = (self.height + scanWindowWH) * 0.5 / self.height;
    
    self.scanWindowRect = CGRectMake(YBZYScreenWidth * borderRatio, minYRatio * self.height, scanWindowWH, scanWindowWH);
    dataOutput.rectOfInterest = CGRectMake(minYRatio, borderRatio, maxYRatio, 1 - 2 * borderRatio);
    
    //绘制阴影图层
    CAShapeLayer *shadowMaskLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, YBZYScreenWidth, minYRatio * self.height)];
    [path appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(0, minYRatio * self.height, YBZYScreenWidth * borderRatio, (1 - minYRatio) * self.height)]];
    [path appendPath:[UIBezierPath bezierPathWithRect:CGRectMake((1 - borderRatio) * YBZYScreenWidth, minYRatio * self.height, YBZYScreenWidth * borderRatio, (1 - minYRatio) * self.height)]];
    [path appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(borderRatio * YBZYScreenWidth, maxYRatio * self.height, scanWindowWH, (1 - maxYRatio) * self.height)]];
    shadowMaskLayer.path = path.CGPath;
    
    CAShapeLayer *shadowLayer = [CAShapeLayer layer];
    shadowLayer.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    shadowLayer.fillColor = [UIColor colorWithWhite:0 alpha: 0.75].CGColor;
    shadowLayer.mask = shadowMaskLayer;
    [self.layer addSublayer:shadowLayer];
    
    //绘制扫描区域提示框
    CGRect scanBorderRect = self.scanWindowRect;
    scanBorderRect.origin.x += 1;
    scanBorderRect.origin.y += 1;
    scanBorderRect.size.width -= 2;
    scanBorderRect.size.height -= 2;
    
    CAShapeLayer *scanBorderLayer = [CAShapeLayer layer];
    scanBorderLayer.path = [UIBezierPath bezierPathWithRect:scanBorderRect].CGPath;
    scanBorderLayer.fillColor = [UIColor clearColor].CGColor;
    scanBorderLayer.strokeColor = YBZYCommonYellowColor.CGColor;
    [self.layer addSublayer:scanBorderLayer];
    
    //提示label
    UILabel *noticeLabel = [UILabel ybzy_labelWithText:@"请将二维码放入框内" andTextColor:[UIColor whiteColor] andFontSize:16];
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    noticeLabel.frame = CGRectMake(0, maxYRatio * self.height + 16, YBZYScreenWidth, 20);
    [self addSubview:noticeLabel];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *scanedMetaData = [metadataObjects firstObject];
        if ([self.delegate respondsToSelector:@selector(scanView:scanSuccessWithCodeInfo:)]) {
            [self.delegate scanView:self scanSuccessWithCodeInfo:scanedMetaData.stringValue];
        }
    }
}

- (void)startScan {
    [self.session startRunning];
}

- (void)stopScan {
    [self.session stopRunning];
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    [self.session stopRunning];
}

- (void)dealloc {
    [self.session stopRunning];
}

@end
