//
//  sketchiViewController.h
//  sketchi
//
//  Created by Nicolas Robertson on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface sketchiViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAccelerometerDelegate> {
    UIAccelerometer *tilter;
    UIImageView *drawImage, *selectionLayer;
    UIImage *undoScreens[6], *backgroundImage, *pictureToStamp;
    UIImagePickerController *backgroundPicker;
    UIPopoverController *popoverController;
    IBOutlet UIViewController *brushOptionMenu, *mainMenu, *tiltMenu, *drawScreen, *introScreen, *emptyView, *creditScreen, *stampScreen;
    IBOutlet UIButton *menu, *saveImage, *clear, *back, *brushOptionButton, *brush1, *brush2, *brush3, *cancelBrushMenu, *backToDrawingBrushMenu, *tiltMenuButton,*backToDrawingTiltMenu, *startNewDrawingButton, *creditBackButton, *undoButton, *loadImageButton, *stampMenuButton, *backToDrawingStampMenu;
    IBOutlet UISlider *red, *green, *blue, *sizeSlider, *alphaSlider;
    IBOutlet UILabel *colourLabel, *currentColourLabel;
    IBOutlet UISwitch *cyclicSwitch, *tiltSwitch, *stampMode, *pictureStamp;
    int mouseMoved, brushOption, undoCounter, count;
    BOOL mouseSwiped, rmax, gmax, bmax, bmin, gmin, rmin, cyclic, tiltDraw, stampBrush, stampPicture, started, change;
    CGPoint lastPoint;
    double b, r, g, alpha, brushSize, accelX, accelY;
}
@property (nonatomic,retain) UIButton *menu, *saveImage, *clear, *back, *brushOptionButton, *brush1, *brush2, *brush3, *cancelBrushMenu, *backToDrawingBrushMenu, *tiltMenuButton, *backToDrawingTiltMenu, *startNewDrawingButton, *creditBackButton, *undoButton, *stampMenuButton, *backToDrawingStampMenu;
@property (nonatomic,retain) UIViewController *brushOptionMenu, *mainMenu, *tiltMenu, *drawScreen, *introScreen, *emptyView, *creditScreen, *stampScreen;
@property (nonatomic,retain) UISlider *red, *green, *blue, *sizeSlider, *alphaSlider;
@property (nonatomic,retain) UILabel *colourLabel, *currentColourLabel;
@property (nonatomic,retain) UISwitch *cyclicSwitch, *tiltSwitch, *stampMode, *pictureStamp;
@property (nonatomic,retain) UIImagePickerController *backgroundPicker;
@property (nonatomic,retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIAccelerometer *tilter;


-(UIImage*) addImages:(UIImage*)background:(UIImage*)toPaste:(int)x:(int)y;
-(void) drawLine:(int)x:(int)y;
-(IBAction) fromMenuClick:(id)sender;
-(IBAction) menuButtonClick:(id)sender;
-(IBAction) saveButtonClick:(id)sender;
-(IBAction) clearButtonClick:(id)sender;
-(IBAction) backButtonClick:(id)sender;
-(IBAction) cancelBrushMenuButtonClick:(id)sender;
-(IBAction) switchClick:(id)sender;
-(IBAction) colourSlider:(id)sender;
-(IBAction) backToDrawing:(id)sender;
-(IBAction) brushType:(id)sender;
-(IBAction) backToMainMenu:(id)sender;
-(IBAction) undo:(id)sender;
-(IBAction) stampModeChange:(id)sender;
-(IBAction) mainMenuButtonPressed:(id)sender;
-(void) changeColour;
@end
