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

@property (weak) IBOutlet UITextField *textField;
@property (weak) IBOutlet UIImageView *imageView;

- (IBAction)endEditing:(id)sender;
- (IBAction)generatorAction:(id)sender;

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
    DTQRCodeCorrectionLevel correctionLevel = DTQRCodeCorrectionLevelHeigh;
    
    CGSize preferredSize = CGSizeMake(300.0f, 300.0f);
    
    DTQRCodeGenerator *generator = [DTQRCodeGenerator QRCodeGeneratorWithString:inputString correctionLevel:correctionLevel];
    [generator setPerferredSize:preferredSize];
    
    UIImage *image = [generator outputImage];
    
    [self.imageView setImage:image];
}

@end
