//
//  sketchiViewController.m
//  sketchi
//
//  Created by Nicolas Robertson on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "sketchiViewController.h"

@implementation sketchiViewController

@synthesize menu;
@synthesize saveImage;
@synthesize clear;
@synthesize back;
@synthesize brushOptionButton;
@synthesize brush1;
@synthesize brush2;
@synthesize brush3;

- (void) viewDidLoad {
    [super viewDidLoad];
    [saveImage addTarget:self action:@selector(saveButtonClick:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [clear addTarget:self action:@selector(clearButtonClick:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [menu addTarget:self action:@selector(menuButtonClick:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [back addTarget:self action:@selector(backButtonClick:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [brushOptionButton addTarget:self action:@selector(brushOptionClick) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    drawImage = [[UIImageView alloc] initWithImage:nil];
    drawImage.frame = self.view.frame;
    [self.view addSubview:drawImage];
    mouseMoved = 0;
    r = 1.0;
    b = 0.0;
    g = 0.0;
    rmax = true;
    bmax = false;
    gmax = false;
    rmin = false;
    bmin = true;
    gmin = true;
    cyclic = true;
    back.hidden = 1;
    brushOption = 0;
    brushOptionButton.hidden = 1;
}

-(void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event {
    
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.view];
	lastPoint.y -= 20;
}

-(void) brushOptionClick:(id)sender{
    brush1.hidden = 0;
    
    
}
-(void) backButtonClick:(id)sender{
    
    drawImage.hidden = 0;
    menu.hidden = 0;
    saveImage.hidden = 0;
    clear.hidden = 0;
    back.hidden = 1;
    brushOptionButton.hidden = 1;
    
}

-(void) menuButtonClick:(id)sender{
    
    drawImage.hidden = 1;
    menu.hidden = 1;
    saveImage.hidden = 1;
    clear.hidden = 1;
    back.hidden = 0;
    brushOptionButton.hidden = 0;
}

-(void) clearButtonClick:(id)sender {
    drawImage.image = nil;
    return;
}

-(void) saveButtonClick:(id)sender {

        UIGraphicsBeginImageContext(CGSizeMake(320,480));
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.view.layer renderInContext:context];
        UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(screenShot, nil, nil, nil); 
    

}
    
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!drawImage.hidden){
    if(cyclic){
        if(bmax && !rmax && gmin){
            r +=0.01;
            rmin = false;
            if(r >= 1.0){
                rmax = true;
            }
        }
        
        if(!bmin && rmax && gmin){
            b -=0.01;
            bmax = false;
            if(b <= 0.0){
                bmin = true;
            }
        }
        if(bmin && rmax && !gmax){
            g +=0.01;
            gmin = false;
            if(g >= 1.0){
                gmax = true;
            }
        }
        if(bmin && !rmin && gmax){
            r -=0.01;
            rmax = false;
            if(r <= 0.0){
                rmin = true;
            }
        }
        if(!bmax && rmin && gmax){
            b += 0.01;
            bmin = false;
            if(b >= 1.0){
                bmax = true;
            }
        }
        if(bmax && rmin && !gmin){
            g -=0.01;
            gmax = false;
            if(g <= 0.0){
                gmin = true;
            }
        }
    }
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];	
    CGPoint currentPoint = [touch locationInView:self.view];
    currentPoint.y -= 20; // only for 'kCGLineCapRound'
    UIGraphicsBeginImageContext(self.view.frame.size);
    [drawImage.image drawInRect:CGRectMake(0, 0, drawImage.frame.size.width, drawImage.frame.size.height)]; //originally self.frame.size.width, self.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound); //kCGLineCapSquare, kCGLineCapButt, kCGLineCapRound
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 10.0); // for size
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), r, g, b, 1.0); //values for R, G, B, and Alpha
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
    
    mouseMoved++;
    
    if (mouseMoved == 10) {
        mouseMoved = 0;
    }
    }
}
   /* 
    - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
        
        UITouch *touch = [touches anyObject];
        
        if ([touch tapCount] == 7) {
            drawImage.image = nil;
            return;
        }
        if(!mouseSwiped) {
            //if color == green
            UIGraphicsBeginImageContext(self.view.frame.size);
            [drawImage.image drawInRect:CGRectMake(0, 0, drawImage.frame.size.width, drawImage.frame.size.height)]; //originally self.frame.size.width, self.frame.size.height)];
            CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound); //kCGLineCapSquare, kCGLineCapButt, kCGLineCapRound
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 10.0);
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 1.0, 0.0, 1.0);
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
            CGContextStrokePath(UIGraphicsGetCurrentContext());
            CGContextFlush(UIGraphicsGetCurrentContext());
            drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
    */
    - (void)didReceiveMemoryWarning {
        // Releases the view if it doesn't have a superview.
        [super didReceiveMemoryWarning];
        
        // Release any cached data, images, etc that aren't in use.
    }
    
    - (void)viewDidUnload {
        // Release any retained subviews of the main view.
        // e.g. self.myOutlet = nil;
    }
    
    


@end
