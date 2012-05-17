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
    UIImageView *drawImage;
    IBOutlet UIViewController *brushOptionMenu, *mainMenu;
    IBOutlet UIButton *menu, *saveImage, *clear, *back, *brushOptionButton, *brush1, *brush2, *brush3, *cancelBrushMenu, *backToDrawingBrushMenu;
    IBOutlet UISlider *red, *green, *blue, *sizeSlider;
    IBOutlet UILabel *colourLabel;
    IBOutlet UISwitch *cyclicSwitch;
    int mouseMoved, brushOption;
    BOOL mouseSwiped, rmax, gmax, bmax, bmin, gmin, rmin, cyclic, tiltDraw;
    CGPoint lastPoint;
    double b, r, g, brushSize;
}
@property (nonatomic,retain) UIButton *menu, *saveImage, *clear, *back, *brushOptionButton, *brush1, *brush2, *brush3, *cancelBrushMenu, *backToDrawingBrushMenu;
@property (nonatomic,retain) UIViewController *brushOptionMenu, *mainMenu;
@property (nonatomic,retain) UISlider *red, *green, *blue, *sizeSlider;
@property (nonatomic,retain) UILabel *colourLabel;
@property (nonatomic,retain) UISwitch *cyclicSwitch;

-(IBAction) brushOptionClick:(id)sender;
-(IBAction) menuButtonClick:(id)sender;
-(IBAction) saveButtonClick:(id)sender;
-(IBAction) clearButtonClick:(id)sender;
-(IBAction) backButtonClick:(id)sender;
-(IBAction) cancelBrushMenuButtonClick:(id)sender;
-(IBAction) cyclicSwitchClick:(id)sender;
-(IBAction) colourSlider:(id)sender;
-(IBAction) backToDrawingBrushMenu:(id)sender;
-(IBAction) brushType0:(id)sender;
-(IBAction) brushType1:(id)sender;
-(IBAction) brushType2:(id)sender;
@end
