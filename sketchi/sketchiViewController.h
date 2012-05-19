//
//  sketchiViewController.h
//  sketchi
//
//  Created by Nicolas Robertson on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface sketchiViewController : UIViewController {
    UIAccelerometer *tilter;
    UIImageView *drawImage, *selectionLayer;
    UIImage *undoScreens[6];
    IBOutlet UIViewController *brushOptionMenu, *mainMenu, *tiltMenu, *drawScreen, *introScreen, *emptyView, *creditScreen;
    IBOutlet UIButton *menu, *saveImage, *clear, *back, *brushOptionButton, *brush1, *brush2, *brush3, *cancelBrushMenu, *backToDrawingBrushMenu, *tiltMenuButton,*backToDrawingTiltMenu, *startNewDrawingButton, *creditBackButton, *undoButton;
    IBOutlet UISlider *red, *green, *blue, *sizeSlider;
    IBOutlet UILabel *colourLabel;
    IBOutlet UISwitch *cyclicSwitch, *tiltSwitch, *stampMode;
    int mouseMoved, brushOption, undoCounter, count;
    BOOL mouseSwiped, rmax, gmax, bmax, bmin, gmin, rmin, cyclic, tiltDraw, stamp, started, change;
    CGPoint lastPoint;
    double b, r, g, brushSize, accelX, accelY;
}
@property (nonatomic,retain) UIButton *menu, *saveImage, *clear, *back, *brushOptionButton, *brush1, *brush2, *brush3, *cancelBrushMenu, *backToDrawingBrushMenu, *tiltMenuButton, *backToDrawingTiltMenu, *startNewDrawingButton, *creditBackButton, *undoButton;
@property (nonatomic,retain) UIViewController *brushOptionMenu, *mainMenu, *tiltMenu, *drawScreen, *introScreen, *emptyView, *creditScreen;
@property (nonatomic,retain) UISlider *red, *green, *blue, *sizeSlider;
@property (nonatomic,retain) UILabel *colourLabel;
@property (nonatomic,retain) UISwitch *cyclicSwitch, *tiltSwitch, *stampMode;

-(IBAction) brushOptionClick:(id)sender;
-(IBAction) tiltMenuButton:(id)sender;
-(IBAction) menuButtonClick:(id)sender;
-(IBAction) saveButtonClick:(id)sender;
-(IBAction) clearButtonClick:(id)sender;
-(IBAction) backButtonClick:(id)sender;
-(IBAction) cancelBrushMenuButtonClick:(id)sender;
-(IBAction) tiltSwitchClick:(id)sender;
-(IBAction) colourSlider:(id)sender;
-(IBAction) backToDrawing:(id)sender;
-(IBAction) brushType:(id)sender;
-(IBAction) backToMainMenu:(id)sender;
-(IBAction) undo:(id)sender;
-(IBAction) stampModeChange:(id)sender;
-(IBAction) mainMenuButtonPressed:(id)sender;
-(void) changeColour;
@end
