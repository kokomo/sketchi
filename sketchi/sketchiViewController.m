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



@synthesize startNewDrawingButton, saveImage, clear, back, brushOptionButton, brush1, brush2, brush3, cancelBrushMenu, backToDrawingBrushMenu, backToDrawingTiltMenu, creditBackButton, tiltMenuButton, undoButton, stampMenuButton, backToDrawingStampMenu;
@synthesize brushOptionMenu, tiltMenu;
@synthesize mainMenu, drawScreen, introScreen, creditScreen, emptyView, menu, stampScreen;
@synthesize red, green, blue, sizeSlider, alphaSlider;
@synthesize colourLabel, currentColourLabel;
@synthesize cyclicSwitch, tiltSwitch, stampMode, pictureStamp;
@synthesize backgroundPicker;
@synthesize popoverController;
@synthesize tilter;



- (void) viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:introScreen.view];
    
    self.tilter = [UIAccelerometer sharedAccelerometer];
    self.tilter.updateInterval = .03;
    self.tilter.delegate = self;
    
    pictureToStamp = nil;
    mouseMoved = 0;
    brushSize = 10.0;
    r = 0.0;
    b = 0.0;
    g = 0.0;
    alpha = 1.0;
    started = false;
    rmax = true;
    bmax = false;
    gmax = false;
    rmin = false;
    bmin = true;
    gmin = true;
    cyclic = false;
    tiltDraw = false;
    stampBrush = false;
    stampPicture = false;
    brushOption = 0;
    accelX = 0;
    accelY = 0;
    undoCounter = 0;
    count = 1;
    
    self.contentSizeForViewInPopover = self.view.frame.size;
    
}

-(IBAction)mainMenuButtonPressed:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Drawing will be erased when returning to main menu, do you wish to save first?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];
    
}

-(IBAction)setStampPicture:(id)sender{
    UIButton* picked = (UIButton*)sender;
    pictureToStamp = picked.imageView.image;
}

-(IBAction) loadImageButtonClicked: (id)sender {
    
    
    backgroundPicker = [[UIImagePickerController alloc] init];
    backgroundPicker.delegate = self;
    
    if(sender == loadImageButton.self){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            
            backgroundPicker.sourceType = UIImagePickerControllerSourceTypeCamera;  
        }
    }else{
        
        backgroundPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    if([[UIDevice currentDevice].model isEqualToString:@"iPad"] || [[UIDevice currentDevice].model hasPrefix:@"iPad"]){ //iPhone has no uipopover controller support so this is for iPad
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:backgroundPicker];
        [popoverController setPopoverContentSize:self.view.frame.size];
        [self.popoverController presentPopoverFromRect:CGRectMake(0.0, 0.0, self.view.frame.size.width,1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    }else{
        [self startNewImage:nil];
        [self presentModalViewController:backgroundPicker animated:YES];
    }
    
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *) Picker {
    if([[UIDevice currentDevice].model isEqualToString:@"iPad"] || [[UIDevice currentDevice].model hasPrefix:@"iPad"]){
        [self.popoverController dismissPopoverAnimated:YES];
    }else{
        [Picker dismissModalViewControllerAnimated:YES]; 
    }
    
}

- (void)imagePickerController:(UIImagePickerController *) Picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    backgroundImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if([[UIDevice currentDevice].model isEqualToString:@"iPad"] || [[UIDevice currentDevice].model hasPrefix:@"iPad"]){
        [self.popoverController dismissPopoverAnimated:YES];
        [self startNewImage:nil];   
    }else{
        for(count = 0; count < 6; count++){
            undoScreens[count] = backgroundImage;
        }
        count = 1;
        drawImage.image = backgroundImage;
        [Picker dismissModalViewControllerAnimated:YES];
    }
    
    //Dont know why but if i call the start new image with background function in here the view dissappears for iphone. quick hack is to call the method before picker shows up and then change the drawimage.image afterwards.
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 1)
    {
        [self saveButtonClick:saveImage.self];
    }
    drawImage.image = nil;
    backgroundImage = nil;
    [mainMenu.view removeFromSuperview];
    
    /* add a new view for emptyView so that self.view can be overwritten*/
    //[drawScreen.view removeFromSuperview];
    self.view = emptyView.view;
    //[self.view setBackgroundColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:1]];
    [self.view addSubview:introScreen.view];
}

-(IBAction)undo:(id)sender{
    if(count>1){
        [drawImage setImage:undoScreens[--undoCounter%6]];
        count--;
    }
}

-(IBAction)stampModeChange:(id)sender{
    stampBrush = stampMode.on;
}

-(IBAction)creditMenu:(id)sender{
    [self.view addSubview:creditScreen.view];
}
-(IBAction)backToMainMenu:(id)sender{
    if(sender == creditBackButton.self){
        [creditScreen.view removeFromSuperview];
    }
}


//starts a new image and initializes the drawscreen and undo screens with nil image
-(IBAction)startNewImage:(id)sender{
    [introScreen.view removeFromSuperview];
    drawImage = [[UIImageView alloc] initWithImage:backgroundImage];
    selectionLayer = [[UIImageView alloc] initWithImage:nil];
    drawImage.frame = CGRectMake(10,36,self.view.frame.size.width -20, (self.view.frame.size.height-46)); 
    //for bug mode remove changes in x direction [possible future game mode]
    drawImage.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    //backgroundImage = drawImage.image;
    self.view = drawScreen.view;
    [drawScreen.view addSubview:drawImage];
    for(count = 0; count < 6; count++){
        undoScreens[count] = drawImage.image;
    }
    count = 1;
    started = true;
    drawImage.hidden = 0;
    menu.hidden = 0;
    saveImage.hidden = 0;
    clear.hidden = 0;
    undoButton.hidden = 0;
    
    
    
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    if(tiltDraw && !drawImage.hidden){
        [self changeColour];
        accelX = -5*acceleration.x;
        accelY = 5*acceleration.y;         
        int xValue, yValue;
        xValue = (int) (lastPoint.x - accelX);
        yValue = (int) (lastPoint.y - accelY);
        
        if(xValue > drawScreen.view.frame.size.width -20){
            xValue = drawScreen.view.frame.size.width -20;
        }
        if(xValue < 0){
            xValue = 0;
        }
        if(yValue > drawScreen.view.frame.size.height -46){
            yValue = drawScreen.view.frame.size.height -46;
        }
        if(yValue < 0){
            yValue = 0;
        }
        if(stampPicture){
            [self drawStamp:xValue :yValue];
        }else{
        [self drawLine:xValue :yValue];
        }
    }
}

-(void)drawStamp:(int)x:(int)y{
        
        drawImage.image = [self addImages:drawImage.image:pictureToStamp:x:y];
    lastPoint.x = x;
    lastPoint.y = y;
    
}
-(void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event {  
    if(started){
        mouseSwiped = NO;
        UITouch *touch = [touches anyObject];
        lastPoint = [touch locationInView:drawImage];
        if(!drawImage.hidden && stampPicture){
            [self drawStamp:lastPoint.x :lastPoint.y];
        }else{
            if(!drawImage.hidden && stampBrush){
                [self changeColour];
                [self drawLine:lastPoint.x :lastPoint.y];
            }
        }
    }
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if(count<6){
        count++;
    }
    undoScreens[++undoCounter%6] = drawImage.image;
    
}
-(IBAction)tiltMenuButton:(id)sender{
    [self.view addSubview:tiltMenu.view];
}

-(IBAction)brushType:(id)sender{
    if(brush1.self == sender){
        brushOption = 0;
        [brush1 setBackgroundImage:[UIImage imageNamed:@"round line highlighted.png"] forState:UIControlStateNormal];
        [brush2 setBackgroundImage:[UIImage imageNamed:@"type2.png"] forState:UIControlStateNormal];
        [brush3 setBackgroundImage:[UIImage imageNamed:@"type3.png"] forState:UIControlStateNormal];
        
    }
    if(brush2.self == sender){
        brushOption = 1;
        [brush1 setBackgroundImage:[UIImage imageNamed:@"round line.png"] forState:UIControlStateNormal];
        [brush2 setBackgroundImage:[UIImage imageNamed:@"type2 highlighted.png"] forState:UIControlStateNormal];
        [brush3 setBackgroundImage:[UIImage imageNamed:@"type3.png"] forState:UIControlStateNormal];
        
    }
    if(brush3.self == sender){
        brushOption = 2;
        [brush1 setBackgroundImage:[UIImage imageNamed:@"round line.png"] forState:UIControlStateNormal];
        [brush2 setBackgroundImage:[UIImage imageNamed:@"type2.png"] forState:UIControlStateNormal];
        [brush3 setBackgroundImage:[UIImage imageNamed:@"type3 highlighted.png"] forState:UIControlStateNormal];
    }
}



-(IBAction)backToDrawing:(id)sender{
    if(backToDrawingBrushMenu.self == sender){
        [brushOptionMenu.view removeFromSuperview];
    }
    if(backToDrawingTiltMenu.self == sender){
        [tiltMenu.view removeFromSuperview];
    }
    if(backToDrawingStampMenu.self == sender){
        [stampScreen.view removeFromSuperview];
    }
    drawImage.hidden = 0;
    menu.hidden = 0;
    saveImage.hidden = 0;
    clear.hidden = 0;
    undoButton.hidden = 0;
    
    cyclic = cyclicSwitch.on;
    if(cyclic){
        r = 1.0;
        b = 0.0;
        g = 0.0;
        [currentColourLabel setBackgroundColor:[UIColor colorWithRed:red.value green:green.value blue:blue.value alpha:1.0]];
    }
    
    [mainMenu.view removeFromSuperview];
}

-(IBAction)sizeSlider:(id)sender{
    brushSize = sizeSlider.value;
}

-(IBAction)colourSlider:(id)sender{
    //[colourLabel setTextColor:[UIColor colorWithRed:red.value green:green.value blue:blue.value alpha:1.0]];
    [currentColourLabel setBackgroundColor:[UIColor colorWithRed:red.value green:green.value blue:blue.value alpha:alphaSlider.value]];
    r = red.value;
    b = blue.value;
    g = green.value;
    alpha = alphaSlider.value;
}

-(IBAction)switchClick:(id)sender{
    tiltDraw = tiltSwitch.on;
    cyclic = cyclicSwitch.on;
    stampBrush = stampMode.on;
    stampPicture = pictureStamp.on;
}


-(IBAction)cancelBrushMenuButtonClick:(id)sender{
    if(sender == cancelBrushMenu.self){
        [brushOptionMenu.view removeFromSuperview];
    }else{
        [tiltMenu.view removeFromSuperview];
    }
    cyclic = cyclicSwitch.on;
    if(cyclic){
        r = 1.0;
        b = 0.0;
        g = 0.0;
    }
    
}

-(IBAction) fromMenuClick:(id)sender{
    if(sender == brushOptionButton){
        [self.view addSubview:brushOptionMenu.view];
    }
    if(sender == tiltMenuButton){
        [self.view addSubview:tiltMenu.view];
    }
    if(sender == stampMenuButton){
        [self.view addSubview:stampScreen.view];
    }
    
}
-(IBAction) backButtonClick:(id)sender{
    
    drawImage.hidden = 0;
    menu.hidden = 0;
    saveImage.hidden = 0;
    clear.hidden = 0;
    undoButton.hidden =0;
    [mainMenu.view removeFromSuperview];
    
}

-(IBAction) menuButtonClick:(id)sender{
    //These need to be updated to change with view controllers instead of hiding the buttons in the final, this is messy at the moment
    drawImage.hidden = 1;
    menu.hidden = 1;
    saveImage.hidden = 1;
    clear.hidden = 1;
    undoButton.hidden = 1;
    [self.view addSubview:mainMenu.view];
    
}

-(IBAction) clearButtonClick:(id)sender {
    //to prevent accidental deletions
    if(count<6){
        count++;
    }
    undoScreens[++undoCounter%6] = drawImage.image;
    undoScreens[++undoCounter%6] = backgroundImage;
    drawImage.image = backgroundImage;
}

-(IBAction) saveButtonClick:(id)sender {
    /*
     UIGraphicsBeginImageContext(drawImage.frame.size);
     CGContextRef context = UIGraphicsGetCurrentContext();
     [drawImage.layer renderInContext:context];
     UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
     / *
     CGRect rect = drawImage.frame;
     screenShot = [self crop:rect :screenShot];
     UIGraphicsEndImageContext();
     */
    UIImageWriteToSavedPhotosAlbum(drawImage.image, nil, nil, nil); 
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Drawing Saved"
                                                    message:@"Your drawing has been saved to the photo album."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}



-(UIImage *) crop:(CGRect)rect:(UIImage *)image{
    /*CGFloat scale = [[UIScreen mainScreen] scale];
     
     if (scale>1.0) {        
     rect = CGRectMake(rect.origin.x*scale , rect.origin.y*scale, rect.size.width*scale, rect.size.height*scale);        
     }
     */
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef]; 
    CGImageRelease(imageRef);
    return result;
    
}

-(void)changeColour{
    if(cyclic){
        double step_size = 0.02;
        if(stampBrush){
            step_size = 0.2;
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


- (UIImage*) addImages:(UIImage*)background :(UIImage*)toPaste:(int)x:(int)y
{
    CGSize size = drawScreen.view.frame.size;
    UIGraphicsBeginImageContext(size);
    
    
    CGPoint thumbPoint = CGPointMake(0, 0);
    [background drawAtPoint:thumbPoint];
    
    CGPoint stampPoint = CGPointMake(x-(toPaste.size.width/2), y-(toPaste.size.height/2));
    [toPaste drawAtPoint:stampPoint];
    
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect cropped = CGRectMake(-20, -46, size.width, size.height);
    return [self crop:cropped:result];
}

-(void) drawLine:(int)x:(int)y{
    
    //UIGraphicsBeginImageContext(self.view.frame.size); //weird bug mode - comment out next line 
    UIGraphicsBeginImageContext(drawImage.frame.size);
    [drawImage.image drawInRect:CGRectMake(0, 0, drawImage.frame.size.width, drawImage.frame.size.height)]; 
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
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), r, g, b, alpha); //values for R, G, B, and Alpha
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    if(stampBrush){
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), x, y);
        
        if(brushOption == 2){
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), x-1, y-1);
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), x, y);
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), x+1, y-1);
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), x, y);
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), x+1, y);
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), x, y);
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), x, y+1);
        }else{
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), x-1, y);
        }
    }
    
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), x, y);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    lastPoint.x = x;
    lastPoint.y = y;
    
    mouseMoved++;
    
    if (mouseMoved == 5) {
        mouseMoved = 0;
    }
    red.value = r;
    green.value = g;
    blue.value =b;
    [currentColourLabel setBackgroundColor:[UIColor colorWithRed:red.value green:green.value blue:blue.value alpha:alpha]];
    
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if(started){
        if(!drawImage.hidden && !stampBrush && !stampPicture){
            [self changeColour];
            mouseSwiped = YES;
            UITouch *touch = [touches anyObject];	
            CGPoint currentPoint = [touch locationInView:drawImage];
            [self drawLine:currentPoint.x:currentPoint.y];
        }
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
