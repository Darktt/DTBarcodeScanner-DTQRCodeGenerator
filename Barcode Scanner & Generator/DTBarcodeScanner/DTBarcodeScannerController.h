//
//  DTBarcodeScannerController.h
//
//  Created by Darktt on 15/6/9.
//  Copyright © 2015 Darktt Personal Company. All rights reserved.
//

@import UIKit;
@import AVFoundation;

NS_ASSUME_NONNULL_BEGIN
@protocol DTBarcodeScannerControllerDelegate;

/*!
 @class DTBarcodeScannerController
 @abstract
    DTBarcodeScannerController detect machine readable metadata via AVCaptureMetadataOutput
 
 @discussion
    Support Types:<br/>
        - AVMetadataObjectTypeUPCECode<br/>
        - AVMetadataObjectTypeCode39Code<br/>
        - AVMetadataObjectTypeCode39Mod43Code<br/>
        - AVMetadataObjectTypeEAN13Code<br/>
        - AVMetadataObjectTypeEAN8Code<br/>
        - AVMetadataObjectTypeCode93Code<br/>
        - AVMetadataObjectTypeCode128Code<br/>
        - AVMetadataObjectTypePDF417Code<br/>
        - AVMetadataObjectTypeQRCode<br/>
        - AVMetadataObjectTypeAztecCode<br/>
        - AVMetadataObjectTypeInterleaved2of5Code<br/>
        - AVMetadataObjectTypeITF14Code<br/>
        - AVMetadataObjectTypeDataMatrixCode<br/>
 */
@interface DTBarcodeScannerController : UIViewController

/**
 * @property delegate
 * @abstract The delegate for tell detected objects.
 */
@property (nullable, assign) id<DTBarcodeScannerControllerDelegate> delegate;

/** 
 * Default is AVCaptureDevicePositionBack if passable.
 * @property cameraPosition
 * @abstract Object that represents the physical camera on the device.
 */
@property (assign) AVCaptureDevicePosition cameraPosition;

/**
 * Default is AVCaptureTorchModeAuto
 * @property torchMode
 * @abstract Indicates current mode of the receiver's torch, if it has one.
 */
@property (assign) AVCaptureTorchMode torchMode;

/**
 * Default is Yes.
 * @propert showDetectRectangle
 * @abstract Show the rectangle when detect barcode, When detect one-dimensional barcode will show a line, not a rectangel.
 */
@property (assign, getter = isShowDetectRectangle) BOOL showDetectRectangle;

/*!
 @method barcodeScannerWithMetadataObjectTypes:
 @param metadataObjectTypes
    Array of AVMetadataObjectTypes to scan for. Only codes with types given in this array will be reported to the delegate.
 
 @abstract
    Initialize a scanner.
 
 @result
    An instance of DTBarcodeScannerController.
 
 @warning
    The barcode scanner did not support AVMetadataObjectTypeFace.
 
 @see
    -initWithMetadataObjectTypes:
    -barcodeScanner:didScanedMetadataObjects:
 
 */
+ (instancetype)barcodeScannerWithMetadataObjectTypes:(NSArray<NSString *> *)metadataObjectTypes NS_SWIFT_UNAVAILABLE("Unavalilable");

/*!
 @method initWithMetadataObjectTypes:
 @param metadataObjectTypes
     Array of AVMetadataObjectTypes to scan for. Only codes with types given in this array will be reported to the delegate.
 
 @abstract
     Initialize a scanner.
 
 @result
     An instance of DTBarcodeScannerController.
 
 @warning
     The barcode scanner did not support AVMetadataObjectTypeFace.
 
 @see
     +barcodeScannerWithMetadataObjectTypes:
     -barcodeScanner:didScanedMetadataObjects:
 
 */
- (instancetype)initWithMetadataObjectTypes:(NSArray<NSString *> *)metadataObjectTypes;

@end

@protocol DTBarcodeScannerControllerDelegate <NSObject>

/**
 * @method barcodeScanner:didScanedMetadataObjects:
 *
 * @abstract Tells the delegate is detect objects.
 *
 * @param barcodeScanner The instance of DTBarcodeScannerController.
 *
 * @param metadataObjects An array of AVMetadataMachineReadableCodeObject for detect objects.
 *
 */
- (void)barcodeScanner:(DTBarcodeScannerController *)barcodeScanner didScanedMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects;

/**
 * @method barcodeScannerDidCancel:
 *
 * @abstract Tells the delegate that the user cancelled the scan operation.
 *
 * @param barcodeScanner The instance of DTBarcodeScannerController.
 *
 */
- (void)barcodeScannerDidCancel:(DTBarcodeScannerController *)barcodeScanner;

@end
NS_ASSUME_NONNULL_END