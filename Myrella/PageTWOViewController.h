//
//  PageTWOViewController.h
//  Myrella
//
//  Created by Filip Kralj on 12/08/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhirlyGlobeComponent.h"

// Map or globe or startup
typedef enum {MaplyGlobe,MaplyGlobeWithElevation,Maply3DMap,Maply2DMap,MaplyNumTypes} MapType;

/** The Test View Controller brings up the WhirlyGlobe Component
 and allows the user to test various functionality.
 */
@interface PageTWOViewController : UIViewController <WhirlyGlobeViewControllerDelegate,MaplyViewControllerDelegate,UIPopoverControllerDelegate>
{
    /// This is the base class shared between the MaplyViewController and the WhirlyGlobeViewController
    MaplyBaseViewController *baseViewC;
    /// If we're displaying a globe, this is set
    WhirlyGlobeViewController *globeViewC;
}

// Fire it up with a particular base layer and map or globe display
- (id)initWithMapType:(MapType)mapType;

@end