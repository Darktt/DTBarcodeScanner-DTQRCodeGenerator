//
//  DTGeneratorViewController.m
//  Barcode Scanner & Generator
//
//  Created by Darktt on 15/07/02.
//  Copyright (c) 2015 Darktt. All rights reserved.
//

#import "DTGeneratorViewController.h"
#import "DTQRCodeGenerator.h"

@interface DTGeneratorViewController ()
{
    DTQRCodeCorrectionLevel _correctionLevel;
}

@property (weak) IBOutlet UITextField *textField;
@property (weak) IBOutlet UIImageView *imageView;

- (IBAction)endEditing:(id)sender;
- (IBAction)generatorAction:(id)sender;
- (IBAction)changeImageSizeAction:(id)sender;

@end

@implementation DTGeneratorViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _correctionLevel = DTQRCodeCorrectionLevelHeigh;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)endEditing:(id)sender
{
    [self generatorAction:nil];
}

- (void)generatorAction:(id)sender
{
    NSString *inputString = self.textField.text;
    
    CGSize preferredSize = CGSizeMake(300.0f, 300.0f);
    
    DTQRCodeGenerator *generator = [DTQRCodeGenerator QRCodeGeneratorWithString:inputString correctionLevel:_correctionLevel];
    [generator setPerferredSize:preferredSize];
    
    UIImage *image = [generator outputImage];
    
    [self.imageView setImage:image];
}

- (void)changeImageSizeAction:(UISegmentedControl *)sender
{
    NSInteger index = sender.selectedSegmentIndex;
    
    switch (index) {
        case 0:
            _correctionLevel = DTQRCodeCorrectionLevelHeigh;
            break;
            
        case 1:
            _correctionLevel = DTQRCodeCorrectionLevelMediumHeigh;
            break;
            
        case 2:
            _correctionLevel = DTQRCodeCorrectionLevelLow;
            break;
            
        default:
            break;
    }
    
    if (self.imageView.image != nil) {
        [self generatorAction:nil];
    }
}

@end
