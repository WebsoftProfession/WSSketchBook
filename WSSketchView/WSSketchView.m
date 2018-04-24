//
//  WSSketchView.m
//  WSSketchBook
//
//  Created by admin on 19/04/18.
//  Copyright © 2018 WebsoftProfessoin. All rights reserved.
//

#import "WSSketchView.h"

@implementation WSSketchView{
    CGPoint startPoint;
    CGPoint endPoint;
    BOOL isTouched;
    UIBezierPath *currentPath;
    BOOL isDrawingContinue;
    NSMutableArray *pathArray;
    NSMutableArray *pathColorsArray;
    NSMutableArray *tempPathArray;
    NSMutableArray *fillTexturePathArray;
    NSMutableArray *tempColorsPathArray;
    NSMutableArray *tempFillTexturePathArray;
    BOOL isFillAction;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.*/
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [[UIImage imageNamed:@"home2.jpg"] drawInRect:rect];
    for (UIBezierPath *path in pathArray) {
        UIColor *pathColor = [pathColorsArray objectAtIndex:[pathArray indexOfObject:path]];
        
        [pathColor setStroke];
        [path stroke];
        for (NSMutableDictionary *dict in fillTexturePathArray) {
            if ([[dict allValues] containsObject:[NSNumber numberWithInteger:[pathArray indexOfObject:path]]]) {
//                [path addClip];
                UIImage *img = [dict valueForKey:@"fill_image"];
                [img drawInRect:path.bounds];
                CGContextRef contenxt = UIGraphicsGetCurrentContext();
                CGContextResetClip(contenxt);
            }
        }
        if (isFillAction && [path containsPoint:startPoint]) {
//            [pathColor setFill];
//            [path fill];
        }
        else{
            
        }
    }
    if (!pathArray) {
        pathArray = [[NSMutableArray alloc] init];
        pathColorsArray = [[NSMutableArray alloc] init];
        tempPathArray = [[NSMutableArray alloc] init];
        tempColorsPathArray = [[NSMutableArray alloc] init];
        fillTexturePathArray = [[NSMutableArray alloc] init];
        tempFillTexturePathArray = [[NSMutableArray alloc] init];
        if (!self.penColor) {
            self.penColor = [UIColor blackColor];
        }
        if (self.penLineWidth==0) {
            self.penLineWidth = 1.0;
        }
    }
    if (isTouched && !currentPath) {
        currentPath = [UIBezierPath bezierPath];
        [currentPath moveToPoint:startPoint];
    }
    
    [currentPath addLineToPoint:endPoint];
    [self.penColor setStroke];
    [currentPath setFlatness:10.0];
    [currentPath setLineWidth:self.penLineWidth];
    [currentPath setLineCapStyle:kCGLineCapRound];
    [currentPath setLineJoinStyle:kCGLineJoinRound];
    [currentPath stroke];
    [currentPath addClip];
    [self.fillImage drawInRect:currentPath.bounds];
    if (!isDrawingContinue) {
        if (currentPath) {
            [pathArray addObject:[currentPath copy]];
            [pathColorsArray addObject:self.penColor];
            if (isFillAction) {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setValue:[NSNumber numberWithInteger:pathArray.count-1] forKey:@"fill_index"];
                [dict setValue:self.fillImage forKey:@"fill_image"];
                [fillTexturePathArray addObject:dict];
            }
        }
        currentPath = nil;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[touches allObjects] lastObject];
    CGPoint touchPoint = [touch locationInView:self];
    startPoint = touchPoint;
    endPoint = touchPoint;
    isTouched = true;
    isDrawingContinue = false;
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[touches allObjects] lastObject];
    CGPoint touchPoint = [touch locationInView:self];
    endPoint = touchPoint;
    startPoint = touchPoint;
    isTouched = true;
    isDrawingContinue = true;
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[touches allObjects] lastObject];
    CGPoint touchPoint = [touch locationInView:self];
    isDrawingContinue = false;
    isTouched = false;
    startPoint = touchPoint;
    endPoint = touchPoint;
    [self setNeedsDisplay];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self setNeedsDisplay];
    UITouch *touch = [[touches allObjects] lastObject];
    CGPoint touchPoint = [touch locationInView:self];
    currentPath = nil;
    isTouched = false;
    isDrawingContinue = false;
    startPoint = touchPoint;
    endPoint = touchPoint;
    [self setNeedsDisplay];
}

-(void)undoDraw{
    if (pathArray.count>0) {
        for (NSMutableDictionary *dict in fillTexturePathArray) {
            if ([[dict allValues] containsObject:[NSNumber numberWithInteger:pathArray.count-1]]) {
                [tempFillTexturePathArray addObject:dict];
                [fillTexturePathArray removeObject:dict];
                break;
            }
        }
        [tempPathArray addObject:[pathArray lastObject]];
        [tempColorsPathArray addObject:[pathColorsArray lastObject]];
        [pathArray removeLastObject];
        [pathColorsArray removeLastObject];
        [self setNeedsDisplay];
    }
}

-(void)redoDraw{
    if (tempPathArray.count>0) {
        for (NSMutableDictionary *dict in tempFillTexturePathArray) {
            if ([[dict allValues] containsObject:[NSNumber numberWithInteger:pathArray.count]]) {
                [fillTexturePathArray addObject:dict];
                [tempFillTexturePathArray removeObject:dict];
                break;
            }
        }
        [pathArray addObject:[tempPathArray lastObject]];
        [pathColorsArray addObject:[tempColorsPathArray lastObject]];
        [tempPathArray removeLastObject];
        [tempColorsPathArray removeLastObject];
    }
    [self setNeedsDisplay];
}

-(void)fillAction{
    isFillAction = true;
    [self setNeedsDisplay];
}

@end
