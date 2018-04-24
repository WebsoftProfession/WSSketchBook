//
//  ViewController.m
//  WSSketchBook
//
//  Created by admin on 24/04/18.
//  Copyright © 2018 WebsoftProfession. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    sketchView.layer.borderColor = [UIColor blackColor].CGColor;
    sketchView.layer.borderWidth = 2.0;
    sketchView.penColor = [UIColor clearColor];
}

- (IBAction)undoAction:(id)sender {
    [sketchView undoDraw];
}

- (IBAction)redoAction:(id)sender {
    [sketchView redoDraw];
}

- (IBAction)fillAction:(id)sender {
    sketchView.fillImage = [UIImage imageNamed:@"table2.png"];
    [sketchView fillAction];
}


- (IBAction)colorAction:(id)sender {
    float low_bound = 0.0;
    float high_bound = 255.0;
    sketchView.penColor = [UIColor colorWithRed:(((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound)/255 green:(((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound)/255 blue:(((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound)/255 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
