//
//  DTScannerViewController.m
//  Barcode Scanner & Generator
//
//  Created by Darktt on 15/07/02.
//  Copyright (c) 2015 Darktt. All rights reserved.
//

#import "DTScannerViewController.h"

#import "DTBarcodeScannerController.h"

@interface DTScannerViewController () <UIViewControllerPreviewingDelegate, DTBarcodeScannerControllerDelegate>

@property (weak) IBOutlet UIButton *scannerButton;

- (IBAction)lanuchScannerAction:(id)sender;

@end

@implementation DTScannerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (![self respondsToSelector:@selector(registerForPreviewingWithDelegate:sourceView:)]) {
        return;
    }
    
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:self.scannerButton];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)lanuchScannerAction:(id)sender
{
    NSArray<NSString *> *types = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeInterleaved2of5Code, AVMetadataObjectTypeITF14Code, AVMetadataObjectTypeDataMatrixCode];
    
    DTBarcodeScannerController *scanner = [DTBarcodeScannerController barcodeScannerWithMetadataObjectTypes:types];
    [scanner setTorchMode:AVCaptureTorchModeOff];
    [scanner setDelegate:self];
    
    [self presentViewController:scanner animated:YES completion:nil];
}

#pragma mark - UIViewControllerPreviewingDelegate

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    NSArray<NSString *> *types = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeInterleaved2of5Code, AVMetadataObjectTypeITF14Code, AVMetadataObjectTypeDataMatrixCode];
    
    DTBarcodeScannerController *scanner = [DTBarcodeScannerController barcodeScannerWithMetadataObjectTypes:types];
    [scanner setDelegate:self];
    
    return scanner;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    [self presentViewController:viewControllerToCommit animated:YES completion:nil];
}

#pragma mark - DTBarcodeScannerControllerDelegate

- (void)barcodeScanner:(DTBarcodeScannerController *)barcodeScanner didScanedMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects
{
    AVMetadataMachineReadableCodeObject *codeObject = metadataObjects.firstObject;
    NSString *readedString = codeObject.stringValue;
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Result" message:readedString preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:action];
    
    void (^completionBlock) (void) = ^{
        [self presentViewController:alertController animated:YES completion:nil];
    };
    
    [barcodeScanner dismissViewControllerAnimated:YES completion:completionBlock];
}

- (void)barcodeScannerDidCancel:(DTBarcodeScannerController *)barcodeScanner
{
    [barcodeScanner dismissViewControllerAnimated:YES completion:nil];
}

@end
