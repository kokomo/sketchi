//
//  sketchiViewController.m
//  sketchi
//
//  Created by Nicolas Robertson on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "sketchiViewController.h"
#define kFilteringFactor 0.1

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
@synthesize tiltMenu;
@synthesize tiltMenuButton;
@synthesize mainMenu;
@synthesize cancelBrushMenu;
@synthesize backToDrawingBrushMenu, backToDrawingTiltMenu;
@synthesize red, green, blue, sizeSlider;
@synthesize colourLabel;
@synthesize cyclicSwitch, tiltSwitch;

- (void) viewDidLoad {
    [super viewDidLoad];
    drawImage = [[UIImageView alloc] initWithImage:nil];
    selectionLayer = [[UIImageView alloc] initWithImage:nil];
    drawImage.frame = CGRectMake(0,36,self.view.frame.size.width, self.view.frame.size.height-36);
    drawImage.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    [self.view addSubview:drawImage];
    mouseMoved = 0;
    brushSize = 10.0;
    [[UIAccelerometer sharedAccelerometer]  setUpdateInterval:(1/20)];
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
    tiltDraw = false;
    stamp = false;
    brushOption = 0;
    accelX = 0;
    accelY = 0;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    if(tiltDraw && !drawImage.hidden){
        [self changeColour];
        accelX = (acceleration.x * kFilteringFactor) + (accelX * (1.0 - kFilteringFactor));
        accelY = (acceleration.y * kFilteringFactor) + (accelY * (1.0 - kFilteringFactor));
        int xValue, yValue;
        xValue = (int) (lastPoint.x + accelX);
        yValue = (int) (lastPoint.y + accelY);
        drawImage.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        [self drawLine:xValue :yValue];
        
    }
}
-(void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event {  
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:drawImage];
    [self changeColour];
        if(brushOption == 2){
        [self drawLine:lastPoint.x-1 :lastPoint.y-1];
    }else{
	[self drawLine:lastPoint.x :lastPoint.y];
    }
    
}

-(IBAction)tiltMenuButton:(id)sender{
    [self.view addSubview:tiltMenu.view];
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

-(IBAction)backToDrawing:(id)sender{
    if(backToDrawingBrushMenu.self == sender){
    [brushOptionMenu.view removeFromSuperview];
    }
    if(backToDrawingTiltMenu.self == sender){
    [tiltMenu.view removeFromSuperview];
    }
    drawImage.hidden = 0;
    menu.hidden = 0;
    saveImage.hidden = 0;
    clear.hidden = 0;
    
    
    cyclic = cyclicSwitch.on;
    if(cyclic){
        r = 1.0;
        b = 0.0;
        g = 0.0;
    }
    
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

-(IBAction)tiltSwitchClick:(id)sender{
    tiltDraw = tiltSwitch.isEnabled;
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
    /*selectionLayer.frame = drawImage.frame;
    selectionLayer.image = drawImage.image;
    [self.view addSubview:selectionLayer];
    drawImage.hidden = true;
    
    / *********************test* /
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [selectionLayer.image drawInRect:CGRectMake(0, 0, drawImage.frame.size.width, drawImage.frame.size.height)]; //originally self.frame.size.width, self.frame.size.height)];
    if(brushOption == 0){
        
        
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound); //kCGLineCapSquare, kCGLineCapButt, kCGLineCapRound
    }
    if(brushOption == 1){
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapSquare); //kCGLineCapSquare, kCGLineCapButt, kCGLineCapRound
    }
    if(brushOption == 2){
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapButt); //kCGLineCapSquare, kCGLineCapButt, kCGLineCapRound
    }
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 100); // for size
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0, 0, 0, 1.0); //values for R, G, B, and Alpha
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    if(stamp){
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 100,100);
    }else{
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 100, 100);
    }
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    selectionLayer.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    lastPoint.x = 100;
    lastPoint.y = 100;
    
    mouseMoved++;
    
    if (mouseMoved == 10) {
        mouseMoved = 0;
    }
    red.value = r;
    green.value = g;
    blue.value =b;
*/
}

-(IBAction) saveButtonClick:(id)sender {

        UIGraphicsBeginImageContext(CGSizeMake(320,444));
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.view.layer renderInContext:context];
        UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
        CGRect rect = CGRectMake(0, 36, self.view.frame.size.width, self.view.frame.size.height-36);
        screenShot = [self crop:rect :screenShot];
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(screenShot, nil, nil, nil); 
    

}

-(UIImage *) crop:(CGRect)rect:(UIImage *)image{
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    if (scale>1.0) {        
        rect = CGRectMake(rect.origin.x*scale , rect.origin.y*scale, rect.size.width*scale, rect.size.height*scale);        
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef]; 
    CGImageRelease(imageRef);
    return result;

}
    
-(void)changeColour{
    if(cyclic){
        double step_size = 0.02;
        if(stamp){
            step_size = 0.1;
        }
        if(bmax && !rmax && gmin){
            r += step_size;
            rmin = false; 
            if(r >= 1.0){
                rmax = true;
            }
        }
        
        if(!bmin && rmax && gmin){
            b -= step_size;
            bmax = false;
            if(b <= 0.0){
                bmin = true;
            }
        }
        if(bmin && rmax && !gmax){
            g += step_size;
            gmin = false;
            if(g >= 1.0){
                gmax = true;
            }
        }
        if(bmin && !rmin && gmax){
            r -= step_size;
            rmax = false;
            if(r <= 0.0){
                rmin = true;
            }
        }
        if(!bmax && rmin && gmax){
            b += step_size;
            bmin = false;
            if(b >= 1.0){
                bmax = true;
            }
        }
        if(bmax && rmin && !gmin){
            g -= step_size;
            gmax = false;
            if(g <= 0.0){
                gmin = true;
            }
        }
    }
    
}

-(void) drawLine:(int)x:(int)y{
    
    //UIGraphicsBeginImageContext(self.view.frame.size); //weird bug mode - comment out next line 
    UIGraphicsBeginImageContext(drawImage.frame.size);
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
    if(stamp){
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), x, y);
    }else{
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), x, y);
}
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    lastPoint.x = x;
    lastPoint.y = y;
    
    mouseMoved++;
    
    if (mouseMoved == 10) {
        mouseMoved = 0;
    }
    red.value = r;
    green.value = g;
    blue.value =b;

    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!drawImage.hidden && !stamp){
        [self changeColour];
        mouseSwiped = YES;
        UITouch *touch = [touches anyObject];	
        CGPoint currentPoint = [touch locationInView:drawImage];
        [self drawLine:currentPoint.x:currentPoint.y];
           }
}
   
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
