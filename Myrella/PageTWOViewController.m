//
//  PageTWOViewController.m
//  Myrella
//
//  Created by Filip Kralj on 12/08/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import "PageTWOViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "AFHTTPRequestOperation.h"
#import "WeatherShader.h"


// Local interface for PageTWOViewController
// We'll hide a few things here
@interface PageTWOViewController ()
{
    
    // Base layer
    NSString *baseLayerName;
    MaplyViewControllerLayer *baseLayer;
    
    // Overlay layers
    NSMutableDictionary *ovlLayers;
    
    // These represent a group of objects we've added to the globe.
    // This is how we track them for removal
    MaplyComponentObject *autoLabels;
    NSArray *vecObjects;
    NSMutableDictionary *loftPolyDict;
    
    // The view we're using to track a selected object
    MaplyViewTracker *selectedViewTrack;
    
    NSDictionary *screenLabelDesc,*labelDesc,*vectorDesc;
    
    int maxLayerTiles;
}

// Change what we're showing based on the Configuration
- (void)changeMapContents;
@end

@implementation PageTWOViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        ovlLayers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)initWithMapType:(MapType)mapType
{
    self = [super init];
    if (self) {
        ovlLayers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    // This should release the globe view
    if (baseViewC)
    {
        [baseViewC.view removeFromSuperview];
        [baseViewC removeFromParentViewController];
        baseViewC = nil;
        globeViewC = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create an empty globe or map controller
    maxLayerTiles = 256;
    globeViewC = [[WhirlyGlobeViewController alloc] init];
    globeViewC.delegate = self;
    baseViewC = globeViewC;
    maxLayerTiles = 128;
    [self.view addSubview:baseViewC.view];
    baseViewC.view.frame = CGRectMake(0, 65, self.view.frame.size.width, 441);
    [self addChildViewController:baseViewC];
    
    // Note: Debugging
    baseViewC.frameInterval = 2;  // 30fps
    
    // Set the background color for the globe
    baseViewC.clearColor = [UIColor clearColor];
    
    // We'll let the toolkit create a thread per image layer.
    baseViewC.threadPerLayer = true;
    
    if (globeViewC)
    {
        // Start up over San Francisco
        globeViewC.height = 0.8;
        [globeViewC animateToPosition:MaplyCoordinateMakeWithDegrees(-122.4192, 37.7793) time:1.0];
    }
    
    // Maximum number of objects for the layout engine to display
    [baseViewC setMaxLayoutObjects:1000];
    
    // Bring up things based on what's turned on
    [self performSelector:@selector(changeMapContents) withObject:nil afterDelay:0.0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // This should release the globe view
    if (baseViewC)
    {
        [baseViewC.view removeFromSuperview];
        [baseViewC removeFromParentViewController];
        baseViewC = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Data Display

// Add country outlines.  Pass in the names of the geoJSON files
/*- (void)addCountries:(NSArray *)names stride:(int)stride
{
    // Parsing the JSON can take a while, so let's hand that over to another queue
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),
                   ^{
                       NSMutableArray *locVecObjects = [NSMutableArray array];
                       NSMutableArray *locAutoLabels = [NSMutableArray array];
                       
                       int ii = 0;
                       for (NSString *name in names)
                       {
                           if (ii % stride == 0)
                           {
                               NSString *fileName = [[NSBundle mainBundle] pathForResource:name ofType:@"geojson"];
                               if (fileName)
                               {
                                   NSData *jsonData = [NSData dataWithContentsOfFile:fileName];
                                   if (jsonData)
                                   {
                                       MaplyVectorObject *wgVecObj = [MaplyVectorObject VectorObjectFromGeoJSON:jsonData];
                                       NSString *vecName = [[wgVecObj attributes] objectForKey:@"ADMIN"];
                                       wgVecObj.userObject = vecName;
                                       MaplyComponentObject *compObj = [baseViewC addVectors:[NSArray arrayWithObject:wgVecObj] desc:vectorDesc];
                                       MaplyScreenLabel *screenLabel = [[MaplyScreenLabel alloc] init];
                                       // Add a label right in the middle
                                       MaplyCoordinate center;
                                       if ([wgVecObj centroid:&center])
                                       {
                                           screenLabel.loc = center;
                                           //screenLabel.size = CGSizeMake(0, 20);
                                           screenLabel.layoutImportance = 1.0;
                                           screenLabel.text = vecName;
                                           screenLabel.userObject = screenLabel.text;
                                           screenLabel.selectable = true;
                                           if (screenLabel.text)
                                               [locAutoLabels addObject:screenLabel];
                                       }
                                       if (compObj)
                                           [locVecObjects addObject:compObj];
                                   }
                               }
                           }
                           ii++;
                       }
                       
                       // Keep track of the created objects
                       // Note: You could lose track of the objects if you turn the countries on/off quickly
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          // Toss in all the labels at once, more efficient
                                          MaplyComponentObject *autoLabelObj = [baseViewC addScreenLabels:locAutoLabels desc:
                                                                                @{kMaplyTextColor: [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0],
                                                                                  kMaplyFont: [UIFont systemFontOfSize:24.0],
                                                                                  kMaplyTextOutlineColor: [UIColor blackColor],
                                                                                  kMaplyTextOutlineSize: @(1.0),
                                                                                  //                                                                               kMaplyShadowSize: @(1.0)
                                                                                  }];
                                          
                                          vecObjects = locVecObjects;
                                          autoLabels = autoLabelObj;
                                      });
                       
                   }
                   );
}
*/

// Set this to reload the base layer ever so often.  Purely for testing
//#define RELOADTEST 1

// Set up the base layer depending on what they've picked.
// Also tear down an old one
- (void)setupBaseLayer
{
    
    // Tear down the old layer
    if (baseLayer)
    {
        baseLayerName = nil;
        [baseViewC removeLayer:baseLayer];
        baseLayer = nil;
    }
    
    // For network paging layers, where we'll store temp files
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)  objectAtIndex:0];
    
    // We'll pick default colors for the labels
    UIColor *screenLabelColor = [UIColor whiteColor];
    UIColor *screenLabelBackColor = [UIColor clearColor];
    UIColor *labelColor = [UIColor whiteColor];
    UIColor *labelBackColor = [UIColor clearColor];
    // And for the vectors to stand out
    UIColor *vecColor = [UIColor whiteColor];
    float vecWidth = 4.0;
    
    NSString *jsonTileSpec = nil;
    NSString *thisCacheDir = nil;
    
#ifdef RELOADTEST
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadLayer:) object:nil];
#endif
    
    if (true)
    {
        self.title = @"Stamen Water Color - Remote";
        // These are the Stamen Watercolor tiles.
        // They're beautiful, but the server isn't so great.
        thisCacheDir = [NSString stringWithFormat:@"%@/stamentiles/",cacheDir];
        int maxZoom = 10;
        MaplyRemoteTileSource *tileSource = [[MaplyRemoteTileSource alloc] initWithBaseURL:@"http://tile.stamen.com/watercolor/" ext:@"png" minZoom:0 maxZoom:maxZoom];
        tileSource.cacheDir = thisCacheDir;
        MaplyQuadImageTilesLayer *layer = [[MaplyQuadImageTilesLayer alloc] initWithCoordSystem:tileSource.coordSys tileSource:tileSource];
        layer.handleEdges = true;
        layer.requireElev = false;
        [baseViewC addLayer:layer];
        layer.drawPriority = 0;
        layer.waitLoad = false;
        layer.singleLevelLoading = false;
        baseLayer = layer;
        screenLabelColor = [UIColor whiteColor];
        screenLabelBackColor = [UIColor whiteColor];
        labelColor = [UIColor blackColor];
        labelBackColor = [UIColor blackColor];
        vecColor = [UIColor grayColor];
        vecWidth = 4.0;
    }  else if (false)
    {
        self.title = @"MapBox Tiles Regular - Remote";
        jsonTileSpec = @"http://a.tiles.mapbox.com/v3/examples.map-zswgei2n.json";
        thisCacheDir = [NSString stringWithFormat:@"%@/mbtilesregular1/",cacheDir];
        screenLabelColor = [UIColor whiteColor];
        screenLabelBackColor = [UIColor whiteColor];
        labelColor = [UIColor blackColor];
        labelBackColor = [UIColor whiteColor];
        vecColor = [UIColor blackColor];
        vecWidth = 4.0;
    }
    // If we're fetching one of the JSON tile specs, kick that off
    if (jsonTileSpec)
    {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:jsonTileSpec]];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             // Add a quad earth paging layer based on the tile spec we just fetched
             MaplyRemoteTileSource *tileSource = [[MaplyRemoteTileSource alloc] initWithTilespec:responseObject];
             tileSource.cacheDir = thisCacheDir;
             MaplyQuadImageTilesLayer *layer = [[MaplyQuadImageTilesLayer alloc] initWithCoordSystem:tileSource.coordSys tileSource:tileSource];
             layer.handleEdges = true;
             layer.waitLoad = false;
             layer.requireElev = false;
             layer.maxTiles = maxLayerTiles;
             [baseViewC addLayer:layer];
             layer.drawPriority = 0;
             baseLayer = layer;
             
#ifdef RELOADTEST
             [self performSelector:@selector(reloadLayer:) withObject:nil afterDelay:10.0];
#endif
         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Failed to reach JSON tile spec at: %@",jsonTileSpec);
         }
         ];
        
        [operation start];
    }
    
    // Set up some defaults for display
    screenLabelDesc = @{kMaplyTextColor: screenLabelColor,
                        //                        kMaplyBackgroundColor: screenLabelBackColor,
                        kMaplyFade: @(1.0),
                        kMaplyTextOutlineSize: @(1.5),
                        kMaplyTextOutlineColor: [UIColor blackColor],
                        };
    labelDesc = @{kMaplyTextColor: labelColor,
                  kMaplyBackgroundColor: labelBackColor,
                  kMaplyFade: @(1.0)};
    vectorDesc = @{kMaplyColor: vecColor,
                   kMaplyVecWidth: @(vecWidth),
                   kMaplyFade: @(1.0),
                   kMaplySelectable: @(true)};
}

// Reload testing
- (void)reloadLayer:(MaplyQuadImageTilesLayer *)layer
{
    if (baseLayer && [baseLayer isKindOfClass:[MaplyQuadImageTilesLayer class]])
    {
        MaplyQuadImageTilesLayer *layer = (MaplyQuadImageTilesLayer *)baseLayer;
        NSLog(@"Reloading layer");
        [layer reload];
        
        [self performSelector:@selector(reloadLayer:) withObject:nil afterDelay:10.0];
    }
}

// Run through the overlays the user wants turned on
- (void)setupOverlays
{
    /*// For network paging layers, where we'll store temp files
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)  objectAtIndex:0];
    NSString *layerName = @"Forecast.IO Snapshot - Remote";
    MaplyViewControllerLayer *layer = ovlLayers[layerName];
    
    // Need to create the layer
    if (!layer)
    {
        // Collect up the various precipitation sources
        NSMutableArray *tileSources = [NSMutableArray array];
        for (unsigned int ii=0;ii<5;ii++)
        {
            MaplyRemoteTileSource *precipTileSource = [[MaplyRemoteTileSource alloc] initWithBaseURL:[NSString stringWithFormat:@"http://a.tiles.mapbox.com/v3/mousebird.precip-example-layer%d/",ii] ext:@"png" minZoom:0 maxZoom:6];
            precipTileSource.cacheDir = [NSString stringWithFormat:@"%@/forecast_io_weather_layer%d/",cacheDir,ii];
            [tileSources addObject:precipTileSource];
        }
        MaplyMultiplexTileSource *precipTileSource = [[MaplyMultiplexTileSource alloc] initWithSources:tileSources];
        // Create a precipitation layer that animates
        MaplyQuadImageTilesLayer *precipLayer = [[MaplyQuadImageTilesLayer alloc] initWithCoordSystem:precipTileSource.coordSys tileSource:precipTileSource];
        precipLayer.imageDepth = (int)[tileSources count];
        precipLayer.animationPeriod = 6.0;
        precipLayer.imageFormat = MaplyImageUByteRed;
        //                precipLayer.texturAtlasSize = 512;
        precipLayer.numSimultaneousFetches = 4;
        precipLayer.handleEdges = false;
        precipLayer.coverPoles = false;
        precipLayer.shaderProgramName = [WeatherShader setupWeatherShader:baseViewC];
        [baseViewC addLayer:precipLayer];
        layer = precipLayer;
    
        // And keep track of it
        if (layer)
            ovlLayers[layerName] = layer;
    } else if (layer)
    {
        // Get rid of the layer
        [baseViewC removeLayer:layer];
        [ovlLayers removeObjectForKey:layerName];
    }*/
}

// Look at the configuration controller and decide what to turn off or on
- (void)changeMapContents
{
    [self setupBaseLayer];
    [self setupOverlays];
    
    globeViewC.keepNorthUp = true;
    globeViewC.pinchGesture = true;
    //globeViewC.rotateGesture = true;
    
    // Update rendering hints
    NSMutableDictionary *hintDict = [NSMutableDictionary dictionary];
    [hintDict setObject:[NSNumber numberWithBool:false] forKey:kMaplyRenderHintCulling];
    [baseViewC setHints:hintDict];
}

#pragma mark - Whirly Globe Delegate

// User didn't select anything, but did tap
- (void)globeViewController:(WhirlyGlobeViewController *)viewC didTapAt:(MaplyCoordinate)coord
{
    // Just clear the selection
    if (selectedViewTrack)
    {
        [baseViewC removeViewTrackForView:selectedViewTrack.view];
        selectedViewTrack = nil;        
    }
}

- (void)globeViewControllerDidTapOutside:(WhirlyGlobeViewController *)viewC
{
    //    [self showPopControl];
}

- (void)globeViewController:(WhirlyGlobeViewController *)viewC layerDidLoad:(MaplyViewControllerLayer *)layer
{
    NSLog(@"Spherical Earth Layer loaded.");
}

#pragma mark - Maply delegate

- (void)maplyViewController:(MaplyViewController *)viewC didTapAt:(MaplyCoordinate)coord
{
    // Just clear the selection
    if (selectedViewTrack)
    {
        [baseViewC removeViewTrackForView:selectedViewTrack.view];
        selectedViewTrack = nil;
    }    
}

#pragma mark - Popover Delegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self changeMapContents];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
