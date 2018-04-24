//
//  WSSketchView.h
//  WSSketchBook
//
//  Created by admin on 19/04/18.
//  Copyright © 2018 WebsoftProfessoin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSSketchView : UIView
@property (nonatomic, strong) UIColor *penColor;
@property (assign) float penLineWidth;
@property (nonatomic, strong) UIImage *fillImage;
-(void)undoDraw;
-(void)redoDraw;
-(void)fillAction;
@end
