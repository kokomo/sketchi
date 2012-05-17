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
@synthesize brushOptionMenu;
@synthesize mainMenu;
@synthesize cancelBrushMenu;
@synthesize backToDrawingBrushMenu;
@synthesize red, green, blue, sizeSlider;
@synthesize colourLabel;
@synthesize cyclicSwitch;

- (void) viewDidLoad {
    [super viewDidLoad];
    drawImage = [[UIImageView alloc] initWithImage:nil];
    drawImage.frame = self.view.frame;
    //drawImage.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height-30); //very interesting bug, check it out
    [self.view addSubview:drawImage];
    mouseMoved = 0;
    brushSize = 10.0;
    r = 0.0;
    b = 0.0;
    g = 0.0;
    rmax = true;
    bmax = false;
    gmax = false;
    rmin = false;
    bmin = true;
    gmin = true;
    cyclic = false;
    brushOption = 0;
}

-(void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event {
    
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.view];
	lastPoint.y -= 20;
}

-(IBAction)brushType0:(id)sender{
    brushOption = 0;
}

-(IBAction)brushType1:(id)sender{
    brushOption = 1;
}

-(IBAction)brushType2:(id)sender{
    brushOption = 2;
}

-(IBAction)backToDrawingBrushMenu:(id)sender{
    [brushOptionMenu.view removeFromSuperview];
    drawImage.hidden = 0;
    menu.hidden = 0;
    saveImage.hidden = 0;
    clear.hidden = 0;
    [mainMenu.view removeFromSuperview];
}

-(IBAction)sizeSlider:(id)sender{
    brushSize = sizeSlider.value;
}

-(IBAction)colourSlider:(id)sender{
    [colourLabel setTextColor:[UIColor colorWithRed:red.value green:green.value blue:blue.value alpha:1.0]];
    r = red.value;
    b = blue.value;
    g = green.value;
}

-(IBAction)cyclicSwitchClick:(id)sender{
    r = 1.0;
    b = 0.0;
    g = 0.0;
    cyclic = cyclicSwitch.isEnabled;
}

-(IBAction)cancelBrushMenuButtonClick:(id)sender{
    [brushOptionMenu.view removeFromSuperview];
}

-(IBAction) brushOptionClick:(id)sender{
    [self.view addSubview:brushOptionMenu.view];
    
    
}
-(IBAction) backButtonClick:(id)sender{
    
    drawImage.hidden = 0;
    menu.hidden = 0;
    saveImage.hidden = 0;
    clear.hidden = 0;
    [mainMenu.view removeFromSuperview];
    
}

-(IBAction) menuButtonClick:(id)sender{
    drawImage.hidden = 1;
    menu.hidden = 1;
    saveImage.hidden = 1;
    clear.hidden = 1;
    [self.view addSubview:mainMenu.view];
   
}

-(IBAction) clearButtonClick:(id)sender {
    drawImage.image = nil;
    return;
}

-(IBAction) saveButtonClick:(id)sender {

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
            r +=0.02;
            rmin = false;
            if(r >= 1.0){
                rmax = true;
            }
        }
        
        if(!bmin && rmax && gmin){
            b -=0.02;
            bmax = false;
            if(b <= 0.0){
                bmin = true;
            }
        }
        if(bmin && rmax && !gmax){
            g +=0.02;
            gmin = false;
            if(g >= 1.0){
                gmax = true;
            }
        }
        if(bmin && !rmin && gmax){
            r -=0.02;
            rmax = false;
            if(r <= 0.0){
                rmin = true;
            }
        }
        if(!bmax && rmin && gmax){
            b += 0.02;
            bmin = false;
            if(b >= 1.0){
                bmax = true;
            }
        }
        if(bmax && rmin && !gmin){
            g -=0.02;
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
        if(brushOption == 0){
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound); //kCGLineCapSquare, kCGLineCapButt, kCGLineCapRound
        }
        if(brushOption == 1){
            CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapSquare); //kCGLineCapSquare, kCGLineCapButt, kCGLineCapRound
        }
        if(brushOption == 2){
            CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapButt); //kCGLineCapSquare, kCGLineCapButt, kCGLineCapRound
        }
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brushSize); // for size
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
        red.value = r;
        green.value = g;
        blue.value =b;
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
