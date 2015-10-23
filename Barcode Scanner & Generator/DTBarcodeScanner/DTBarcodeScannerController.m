//
//  DTBarcodeScannerController.m
//
//  Created by Darktt on 15/6/9.
//  Copyright (c) 2015 Darktt Personal Company. All rights reserved.
//

#import "DTBarcodeScannerController.h"

#import "AVCaptureDevice+Device.h"
#import "UIImage+Bundle.h"

#import "DTLocalizableString.h"

#import "DTFadeView.h"

#pragma mark - DTCameraPreviewView

@interface DTCameraPreviewView: UIView

@property (retain, nonatomic) AVCaptureSession *session;
@property (readonly) AVCaptureVideoPreviewLayer *previewLayer;

+ (instancetype)previewViewWithFrame:(CGRect)frame;

@end

@implementation DTCameraPreviewView

+ (Class)layerClass
{
    return [AVCaptureVideoPreviewLayer class];
}

+ (instancetype)previewViewWithFrame:(CGRect)frame
{
    DTCameraPreviewView *previewView = [[DTCameraPreviewView alloc] initWithFrame:frame];
    
    return [previewView autorelease];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setBackgroundColor:[UIColor blackColor]];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self == nil) return nil;
    
    [self setBackgroundColor:[UIColor blackColor]];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    return self;
}

- (AVCaptureVideoPreviewLayer *)previewLayer
{
    return (AVCaptureVideoPreviewLayer *)self.layer;
}

- (AVCaptureSession *)session
{
    return [self.previewLayer session];
}

- (void)setSession:(AVCaptureSession *)session
{
    [self.previewLayer setSession:session];
}

@end

static NSString *const kBundleName = @"DTBarcodeScannerResource.bundle";
static UIImage *kFlashOffImage = nil;
static UIImage *kFlashOnImage = nil;

NSInteger const kFlashButtonTag = 1000;

#pragma mark - DTBarcodeScannerController

@interface DTBarcodeScannerController () <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureDeviceInput *_videoDeviceInput;
    BOOL _torchAvailable;
    
    dispatch_queue_t _sessionQueue;
}

@property (readonly) DTCameraPreviewView *previewView;
@property (retain, nonatomic) NSArray *metadataObjectTypes;

@end

@implementation DTBarcodeScannerController

+ (instancetype)barcodeScannerWithMetadataObjectTypes:(NSArray *)metadataObjectTypes
{
    DTBarcodeScannerController *barcodeScanner = [[DTBarcodeScannerController alloc] initWithMetadataObjectTypes:metadataObjectTypes];
    
    return [barcodeScanner autorelease];
}

#pragma mark Instance Method -
#pragma mark View Live Cycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupProperties];
}

- (instancetype)initWithMetadataObjectTypes:(NSArray *)metadataObjectTypes
{
    self = [super initWithNibName:nil bundle:nil];
    if (self == nil) return nil;
    
    NSAssert(![metadataObjectTypes containsObject:AVMetadataObjectTypeFace], @"The type %@ is not supported by DTBarcodeScannerController", AVMetadataObjectTypeFace);
    
    [self setupProperties];
    [self setMetadataObjectTypes:metadataObjectTypes];
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    dispatch_async(_sessionQueue, ^{
        AVCaptureSession *session = self.previewView.session;
        
        [session startRunning];
    });
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    dispatch_async(_sessionQueue, ^{
        AVCaptureSession *session = self.previewView.session;
        
        [session stopRunning];
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DTCameraPreviewView *perviewView = [DTCameraPreviewView previewViewWithFrame:CGRectZero];
    
    [self setView:perviewView];
    
    [self setupCameraPreview];
    [self setupUI];
}

#pragma mark #Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark #View Rotation

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

#pragma mark #Dealloc

- (void)dealloc
{
    [self setMetadataObjectTypes:nil];
    
    [_videoDeviceInput release];
    
    dispatch_release(_sessionQueue);
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup Property And UI

- (void)setupProperties
{
    [self setCameraPosition:AVCaptureDevicePositionBack];
    [self setTorchMode:AVCaptureTorchModeAuto];
    [self setShowDetectRectangle:YES];
}

- (DTCameraPreviewView *)previewView
{
    return (DTCameraPreviewView *)self.view;
}

#pragma mark #CameraPreview

- (void)setupCameraPreview
{
    AVCaptureSession *captureSession = [AVCaptureSession new];
    
    [self.previewView setSession:captureSession];
    [captureSession release];
    
    [self checkDeviceAuthorizationStatus];
    
    _sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    dispatch_retain(_sessionQueue);
    
    dispatch_async(_sessionQueue, ^{
        AVCaptureSession *session = self.previewView.session;
        [session beginConfiguration];
        
        NSError *error = nil;
        
        AVCaptureDevice *captureDevice = [AVCaptureDevice deviceWithMediaType:AVMediaTypeVideo preferringPosition:self.cameraPosition];
        _videoDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
 
        if (error != nil)
        {
            NSLog(@"%@", error);
            
            if (error.code == AVErrorApplicationIsNotAuthorizedToUseDevice) {
                double delayInSeconds = 1.0f;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self showCameraDeviceNotAuthorizedAlert];
                });
            }
            
            [session commitConfiguration];
            return;
        }
        
        if ([session canAddInput:_videoDeviceInput]) {
            [session addInput:_videoDeviceInput];
            
            [self setupTorchMode];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateCameraAbility];
                
                AVCaptureVideoPreviewLayer *previewLayer = self.previewView.previewLayer;
                [previewLayer.connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
            });
        }
        
        if ([session canSetSessionPreset:AVCaptureSessionPreset1920x1080]) {
            [session setSessionPreset:AVCaptureSessionPreset1920x1080];
        } else
        if ([session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
            [session setSessionPreset:AVCaptureSessionPreset1280x720];
        }
        
        AVCaptureMetadataOutput *captureOutput = [AVCaptureMetadataOutput new];
        
        if ([session canAddOutput:captureOutput]) {
            [session addOutput:captureOutput];
            
            [captureOutput setMetadataObjectsDelegate:self queue:_sessionQueue];
            [captureOutput setMetadataObjectTypes:self.metadataObjectTypes];
        }
        
        [captureOutput release];
        
        [session commitConfiguration];
    });
}

- (void)checkDeviceAuthorizationStatus
{
    NSString *mediaType = AVMediaTypeVideo;
    
    void (^completionHandler) (BOOL) = ^(BOOL granted) {
        if (granted) {
            return;
        }
        
        NSString *message = @"I do not have permission to use Camera, please change privacy settings";
        NSLog(@"%s: \n %@", __func__, message);
    };
    
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:completionHandler];
}

- (void)setupTorchMode
{
    AVCaptureDevice *device = _videoDeviceInput.device;
    _torchAvailable = [device hasTorch];
    
    if (!_torchAvailable) {
        return;
    }
    
    dispatch_block_t dispatchBlock = ^{
        NSError *error = nil;
        
        BOOL lockSuccess = [device lockForConfiguration:&error];
        
        if (!lockSuccess) {
            NSLog(@"Device lock fail: %@", error);
            
            return;
        }
        
        if ([device isTorchModeSupported:self.torchMode]) {
            [device setTorchMode:self.torchMode];
        }
        
        [device unlockForConfiguration];
    };
    
    BOOL isMainQueue = [NSThread isMainThread];
    
    if (isMainQueue) {
        dispatch_async(_sessionQueue, dispatchBlock);
    } else {
        dispatchBlock();
    }
}

- (void)updateCameraAbility
{
    UIButton *flashButton = (UIButton *)[self.view viewWithTag:kFlashButtonTag];
    [flashButton setHidden:!_torchAvailable];
    
//    BOOL hasBackCamera = [AVCaptureDevice hasDeviceWithPosition:AVCaptureDevicePositionBack];
    
//    [self.bottomPanelView setSwitchCameraButtonHidden:!hasBackCamera];
}

#pragma mark #UI

- (void)setupUI
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    BOOL isPortrait = UIInterfaceOrientationIsPortrait(orientation);
    
    if (!isPortrait) {
        CGFloat widthOfScreen = CGRectGetHeight(screenRect);
        CGFloat heightOfScreen = CGRectGetWidth(screenRect);
        
        screenRect.size = CGSizeMake(widthOfScreen, heightOfScreen);
    }
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    /// Status Bar Cover
    CGRect statusCoverViewFrame = [[UIApplication sharedApplication] statusBarFrame];
    
    UIVisualEffectView *statusCoverView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [statusCoverView setFrame:statusCoverViewFrame];
    
    [self.view addSubview:statusCoverView];
    [statusCoverView release];
    
    /// Flash Button
    if (kFlashOffImage == nil) {
        UIImage *flashOffImage = [UIImage imageNamed:@"flash" inBundleName:kBundleName];
        
        kFlashOffImage = [flashOffImage retain];
    }
    
    if (kFlashOnImage == nil) {
        UIImage *flashImage = [UIImage imageNamed:@"flash_on" inBundleName:kBundleName];
        
        kFlashOnImage = [flashImage retain];
    }
    
    UIButton *flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [flashButton setImage:kFlashOffImage forState:UIControlStateNormal];
    [flashButton setImage:kFlashOnImage forState:UIControlStateSelected];
    [flashButton addTarget:self action:@selector(switchFlash:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect flashFrame = (CGRect) {
        .origin = (CGPoint) {
            .x = CGRectGetMaxX(screenRect) - 44.0f/* Width of button */ - 10.0f,
            .y = CGRectGetMaxY(statusCoverViewFrame) + 10.0f
        },
        .size = CGSizeMake(44.0f, 44.0f)
    };
    
    [flashButton setFrame:flashFrame];
    
    [self.view addSubview:flashButton];
    
    /// Cancel Button
    NSString *cancelTitle = DTLocalizableString(@"Cancel", @"");
    
    UIFont *font = [UIFont systemFontOfSize:20.0f];
    NSDictionary *attributes = @{NSFontAttributeName: font};
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:cancelTitle attributes:attributes];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setAttributedTitle:attributedTitle forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton sizeToFit];
    
    [attributedTitle release];
    
    CGPoint centerOfButton = (CGPoint) {
        .x = CGRectGetMidX(cancelButton.bounds) + 10.0f,
        .y = 32.0f
    };
    
    [cancelButton setCenter:centerOfButton];
    
    /// Switch camera utton
//    UIButton *switchCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    /// Bottom Cover
    CGFloat widthOfBottomCoverView = CGRectGetWidth(screenRect);
    
    CGRect bottomCoverViewFrame = (CGRect) {
        .origin = (CGPoint) {
            .y = CGRectGetMaxY(screenRect) - 64.0f
        },
        .size = CGSizeMake(widthOfBottomCoverView, 64.0f)
    };
    
    UIVisualEffectView *bottomCoverView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [bottomCoverView setFrame:bottomCoverViewFrame];
    
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    [vibrancyEffectView setFrame:bottomCoverView.bounds];
    [vibrancyEffectView.contentView addSubview:cancelButton];
    
    [bottomCoverView.contentView addSubview:vibrancyEffectView];
    [vibrancyEffectView release];
    
    [self.view addSubview:bottomCoverView];
    [bottomCoverView release];
}

- (DTFadeView *)setupFadeViewWithFrame:(CGRect)frame
{
    UIColor *borderColor = [UIColor redColor];
    
    DTFadeView *view = [DTFadeView fadeViewWithFrame:frame];
    [view setDuration:0.5f];
    [view setDelay:0.25f];
    
    [view.layer setBorderWidth:1.0f];
    [view.layer setBorderColor:borderColor.CGColor];
    
    return view;
}

- (void)showFadeViewWithFrame:(CGRect)frame
{
    if (!self.showDetectRectangle) {
        return;
    }
    
    DTFadeView *fadeView = [self setupFadeViewWithFrame:frame];
    
    void (^operationBlock) (void) = ^{
        [fadeView fadeOut];
        [self.view addSubview:fadeView];
    };
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:operationBlock];
}

#pragma mark - Action

- (void)switchFlash:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
    BOOL selected = sender.selected;
    AVCaptureTorchMode torchMode = selected ? AVCaptureTorchModeOn : AVCaptureTorchModeOff;
    
    [self setTorchMode:torchMode];
    [self setupTorchMode];
}

- (void)dismiss:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(barcodeScannerDidCancel:)]) {
        [self.delegate barcodeScannerDidCancel:self];
    }
}

#pragma mark - Alert

- (void)showCameraDeviceNotAuthorizedAlert
{
    NSString *settingActionTitle = DTLocalizableString(@"Setting", @"");
    
    void (^settingActionHandler) (UIAlertAction *action) = ^(UIAlertAction *action) {
        NSURL *openURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        [[UIApplication sharedApplication] openURL:openURL];
    };
    
    UIAlertAction *settingAction = [UIAlertAction actionWithTitle:settingActionTitle style:UIAlertActionStyleDefault handler:settingActionHandler];
    
    NSString *dismissActionTitle = DTLocalizableString(@"Dismiss", @"");
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:dismissActionTitle style:UIAlertActionStyleDefault handler:nil];
    
    NSString *alertTitle = DTLocalizableString(@"Error", @"");
    NSString *alertMessage = DTLocalizableString(@"I do not have permission to use Camera,\nplease change privacy settings", @"");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:settingAction];
    [alertController addAction:dismissAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:0];
    
    void (^ArrayEnumeratorBlock) (id object, NSUInteger idx, BOOL *stop) = ^(AVMetadataMachineReadableCodeObject *readableObject, NSUInteger idx, BOOL *stop) {
        AVMetadataMachineReadableCodeObject *transformedObject = (AVMetadataMachineReadableCodeObject *)[self.previewView.previewLayer transformedMetadataObjectForMetadataObject:readableObject];
        
        if (transformedObject == nil) {
            return;
        }
        
        [objects addObject:transformedObject];
        
        CGRect bounds = transformedObject.bounds;
        [self showFadeViewWithFrame:bounds];
    };
    
    [metadataObjects enumerateObjectsUsingBlock:ArrayEnumeratorBlock];
    
    void (^operationBlock) (void) = ^{
        if ([self.delegate respondsToSelector:@selector(barcodeScanner:didScanedMetadataObjects:)]) {
            [self.delegate barcodeScanner:self didScanedMetadataObjects:objects];
        }
    };
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:operationBlock];
}

@end
