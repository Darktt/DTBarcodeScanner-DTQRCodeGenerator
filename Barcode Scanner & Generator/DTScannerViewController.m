//
//  DTScannerViewController.m
//  Barcode Scanner & Generator
//
//  Created by Darktt on 15/07/02.
//  Copyright (c) 2015 Darktt. All rights reserved.
//

#import "DTScannerViewController.h"

#import "DTBarcodeScannerController.h"

@interface DTScannerViewController () <DTBarcodeScannerControllerDelegate>

- (IBAction)lanuchScannerAction:(id)sender;

@end

@implementation DTScannerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)lanuchScannerAction:(id)sender
{
    NSArray *types = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeInterleaved2of5Code, AVMetadataObjectTypeITF14Code, AVMetadataObjectTypeDataMatrixCode];
    DTBarcodeScannerController *scanner = [DTBarcodeScannerController barcodeScannerWithMetadataObjectTypes:types];
    [scanner setDelegate:self];
    
    [self presentViewController:scanner animated:YES completion:nil];
}

#pragma mark - DTBarcodeScannerControllerDelegate

- (void)barcodeScanner:(DTBarcodeScannerController *)barcodeScanner didScanedMetadataObjects:(NSArray *)metadataObjects
{
    
}

- (void)barcodeScannerDidCancel:(DTBarcodeScannerController *)barcodeScanner
{
    [barcodeScanner dismissViewControllerAnimated:YES completion:nil];
}

@end
