//
//  PageTHREEViewController.m
//  Myrella
//
//  Created by Filip Kralj on 12/08/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import "SensorTableView.h"

@interface SensorTableView ()

@end

@implementation SensorTableView

@synthesize ambientTemp;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    self.title = @"TI BLE Sensor Tag application";

}

-(void)deinit {
    [self.sensorTag deinit];
    self.sensorTag = nil;
}


-(void)viewWillDisappear:(BOOL)animated {
    
}

-(void)viewDidDisappear:(BOOL)animated {

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.view.backgroundColor = [UIColor clearColor];
    
    if (!self.ambientTemp){
        self.ambientTemp = [[temperatureCellTemplate alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Ambient temperature"];
        self.ambientTemp.temperatureIcon.image = [UIImage imageNamed:@"temperature.png"];
        self.ambientTemp.temperatureLabel.text = @"Ambient Temperature";
        self.ambientTemp.temperature.text = @"-.-°C";
    }
    if (!self.irTemp) {
        self.irTemp = [[temperatureCellTemplate alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IR temperature"];
        self.irTemp.temperatureIcon.image = [UIImage imageNamed:@"objecttemperature.png"];
        self.irTemp.temperatureLabel.text = @"Object Temperature";
        self.irTemp.temperature.text = @"-.-°C";
    }
    if (!self.acc) {
        self.acc = [[accelerometerCellTemplate alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Accelerometer"];
        self.acc.accLabel.text = @"Accelerometer";
        self.acc.accValueX.text = @"-";
        self.acc.accValueY.text = @"-";
        self.acc.accValueZ.text = @"-";
        self.acc.accCalibrateButton.hidden = YES;
    }
    if (!self.rH) {
        self.rH = [[temperatureCellTemplate alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Relative humidity"];
        self.rH.temperatureIcon.image = [UIImage imageNamed:@"relativehumidity.png"];
        self.rH.temperatureLabel.text = @"Relative humidity";
        self.rH.temperature.text = @"-%rH";
    }
    if (!self.mag) {
        self.mag = [[accelerometerCellTemplate alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Magnetometer"];
        self.mag.accLabel.text = @"Magnetometer";
        self.mag.accIcon.image = [UIImage imageNamed:@"magnetometer.png"];
        self.mag.accValueX.text = @"-";
        self.mag.accValueY.text = @"-";
        self.mag.accValueZ.text = @"-";
        [self.mag.accCalibrateButton addTarget:self action:@selector(handleCalibrateMag) forControlEvents:UIControlEventTouchUpInside];        }
    if (!self.baro) {
        self.baro = [[temperatureCellTemplate alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Barometer"];
        self.baro.temperatureLabel.text = @"Barometer";
        self.baro.temperatureIcon.image = [UIImage imageNamed:@"barometer.png"];
        self.baro.temperature.text = @"1000mBar";
    }
    if (!self.gyro) {
        self.gyro = [[accelerometerCellTemplate alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Gyroscope"];
        self.gyro.accLabel.text = @"Gyroscope";
        self.gyro.accIcon.image = [UIImage imageNamed:@"gyroscope.png"];
        self.gyro.accValueX.text = @"-";
        self.gyro.accValueY.text = @"-";
        self.gyro.accValueZ.text = @"-";
        [self.gyro.accCalibrateButton addTarget:self action:@selector(handleCalibrateGyro) forControlEvents:UIControlEventTouchUpInside];
    }
    
    

    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateView:) userInfo:nil repeats:YES];


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = [self.sensorTag.sensorsEnabled objectAtIndex:indexPath.row];
    
    if ([cellType isEqualToString:@"Ambient temperature"]) return self.ambientTemp.height;
    if ([cellType isEqualToString:@"IR temperature"]) return self.irTemp.height;
    if ([cellType isEqualToString:@"Accelerometer"]) return self.acc.height;
    if ([cellType isEqualToString:@"Humidity"]) return self.rH.height;
    if ([cellType isEqualToString:@"Magnetometer"]) return self.mag.height;
    if ([cellType isEqualToString:@"Barometer"]) return self.baro.height;
    if ([cellType isEqualToString:@"Gyroscope"]) return self.gyro.height;
    
    return 50;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.sensorTag.sensorsEnabled.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellType = [self.sensorTag.sensorsEnabled objectAtIndex:indexPath.row];
    
    if ([cellType isEqualToString:@"Ambient temperature"]) {
        
        return self.ambientTemp;
    }
    else if ([cellType isEqualToString:@"IR temperature"]) {
        return self.irTemp;
    }
    else if ([cellType isEqualToString:@"Accelerometer"]) {
        return self.acc;
    }
    else if ([cellType isEqualToString:@"Humidity"]) {
        return self.rH;
    }
    else if ([cellType isEqualToString:@"Barometer"]) {
        return self.baro;
    }
    else if ([cellType isEqualToString:@"Gyroscope"]) {
        return self.gyro;
    }
    else if ([cellType isEqualToString:@"Magnetometer"]) {
        return self.mag;
    }
    
    // Something has gone wrong, because we should never get here, return empty cell
    return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Unkown Cell"];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction) handleCalibrateMag {
    NSLog(@"Calibrate magnetometer pressed !");
    [self.sensorTag calibrateMag];
}
- (IBAction) handleCalibrateGyro {
    NSLog(@"Calibrate gyroscope pressed ! ");
    [self.sensorTag calibrateGyro];
}

-(void) updateView:(NSTimer *)timer {
    CGFloat w,a;
    if (self.ambientTemp) {
        [self.ambientTemp.temperature.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.ambientTemp.temperature.textColor = [self.ambientTemp.temperature.textColor colorWithAlphaComponent:a];
    
        self.ambientTemp.temperature.text = [NSString stringWithFormat:@"%.1f°C", self.sensorTag.currentVal.tAmb];
        self.ambientTemp.temperature.textColor = [UIColor blackColor];
        self.ambientTemp.temperatureGraph.progress = (self.sensorTag.currentVal.tAmb / 100.0) + 0.5;
    }
    if (self.irTemp) {
        [self.irTemp.temperature.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.irTemp.temperature.textColor = [self.irTemp.temperature.textColor colorWithAlphaComponent:a];
        
        self.irTemp.temperature.text = [NSString stringWithFormat:@"%.1f°C", self.sensorTag.currentVal.tIR];
        self.irTemp.temperatureGraph.progress = (self.sensorTag.currentVal.tIR / 1000.0) + 0.5;
        self.irTemp.temperature.textColor = [UIColor blackColor];
    }
    if (self.acc) {
        [self.acc.accValueX.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.acc.accValueX.textColor = [self.acc.accValueX.textColor colorWithAlphaComponent:a];
        
        [self.acc.accValueY.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.acc.accValueY.textColor = [self.acc.accValueY.textColor colorWithAlphaComponent:a];
        
        [self.acc.accValueZ.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.acc.accValueZ.textColor = [self.acc.accValueZ.textColor colorWithAlphaComponent:a];
        
        self.acc.accValueX.text = [NSString stringWithFormat:@"X: % 0.1fG",self.sensorTag.currentVal.accX];
        self.acc.accValueY.text = [NSString stringWithFormat:@"Y: % 0.1fG",self.sensorTag.currentVal.accY];
        self.acc.accValueZ.text = [NSString stringWithFormat:@"Z: % 0.1fG",self.sensorTag.currentVal.accZ];
        
        self.acc.accValueX.textColor = [UIColor blackColor];
        self.acc.accValueY.textColor = [UIColor blackColor];
        self.acc.accValueZ.textColor = [UIColor blackColor];
        
        self.acc.accGraphX.progress = (self.sensorTag.currentVal.accX / [sensorKXTJ9 getRange]) + 0.5;
        self.acc.accGraphY.progress = (self.sensorTag.currentVal.accY / [sensorKXTJ9 getRange]) + 0.5;
        self.acc.accGraphZ.progress = (self.sensorTag.currentVal.accZ / [sensorKXTJ9 getRange]) + 0.5;
    }
    if (self.rH) {
        [self.rH.temperature.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.rH.temperature.textColor = [self.rH.temperature.textColor colorWithAlphaComponent:a];
        
        self.rH.temperature.text = [NSString stringWithFormat:@"%0.1f%%rH",self.sensorTag.currentVal.humidity];
        self.rH.temperatureGraph.progress = (self.sensorTag.currentVal.humidity / 100);
        self.rH.temperature.textColor = [UIColor blackColor];
    }
    if (self.mag) {
        [self.mag.accValueX.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.mag.accValueX.textColor = [self.mag.accValueX.textColor colorWithAlphaComponent:a];
        
        [self.mag.accValueY.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.mag.accValueY.textColor = [self.mag.accValueY.textColor colorWithAlphaComponent:a];
        
        [self.mag.accValueZ.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.mag.accValueZ.textColor = [self.mag.accValueZ.textColor colorWithAlphaComponent:a];
        
        self.mag.accValueX.text = [NSString stringWithFormat:@"X: % 0.1fuT",self.sensorTag.currentVal.magX];
        self.mag.accValueY.text = [NSString stringWithFormat:@"Y: % 0.1fuT",self.sensorTag.currentVal.magY];
        self.mag.accValueZ.text = [NSString stringWithFormat:@"Z: % 0.1fuT",self.sensorTag.currentVal.magZ];
        
        self.mag.accValueX.textColor = [UIColor blackColor];
        self.mag.accValueY.textColor = [UIColor blackColor];
        self.mag.accValueZ.textColor = [UIColor blackColor];
        
        self.mag.accGraphX.progress = (self.sensorTag.currentVal.magX / [sensorMAG3110 getRange]) + 0.5;
        self.mag.accGraphY.progress = (self.sensorTag.currentVal.magY / [sensorMAG3110 getRange]) + 0.5;
        self.mag.accGraphZ.progress = (self.sensorTag.currentVal.magZ / [sensorMAG3110 getRange]) + 0.5;
    }
    if (self.baro) {
        [self.baro.temperature.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.baro.temperature.textColor = [self.baro.temperature.textColor colorWithAlphaComponent:a];
        
        self.baro.temperature.text = [NSString stringWithFormat:@"%d mBar", (int)self.sensorTag.currentVal.press];
        self.baro.temperatureGraph.progress = ((float)((float)self.sensorTag.currentVal.press - (float)800) / (float)400);
        self.baro.temperature.textColor = [UIColor blackColor];
    }
    if (self.gyro) {
        [self.gyro.accValueX.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.gyro.accValueX.textColor = [self.gyro.accValueX.textColor colorWithAlphaComponent:a];
        
        [self.gyro.accValueY.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.gyro.accValueY.textColor = [self.gyro.accValueY.textColor colorWithAlphaComponent:a];
        
        [self.gyro.accValueZ.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.gyro.accValueZ.textColor = [self.gyro.accValueZ.textColor colorWithAlphaComponent:a];
        
        self.gyro.accValueX.text = [NSString stringWithFormat:@"X: % 0.1f°/S",self.sensorTag.currentVal.gyroX];
        self.gyro.accValueY.text = [NSString stringWithFormat:@"Y: % 0.1f°/S",self.sensorTag.currentVal.gyroY];
        self.gyro.accValueZ.text = [NSString stringWithFormat:@"Z: % 0.1f°/S",self.sensorTag.currentVal.gyroZ];
        
        self.gyro.accValueX.textColor = [UIColor blackColor];
        self.gyro.accValueY.textColor = [UIColor blackColor];
        self.gyro.accValueZ.textColor = [UIColor blackColor];
        
        self.gyro.accGraphX.progress = (self.sensorTag.currentVal.gyroX / [sensorIMU3000 getRange]) + 0.5;
        self.gyro.accGraphY.progress = (self.sensorTag.currentVal.gyroY / [sensorIMU3000 getRange]) + 0.5;
        self.gyro.accGraphZ.progress = (self.sensorTag.currentVal.gyroZ / [sensorIMU3000 getRange]) + 0.5;
    }
    [self.tableView reloadData];
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
