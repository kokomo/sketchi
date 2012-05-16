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
    int mouseMoved;
    BOOL mouseSwiped, rmax, gmax, bmax, bmin, gmin, rmin, cyclic;
    CGPoint lastPoint;
    double b;
    double r;
    double g;
}

@end
