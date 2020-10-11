//
//  IndoorMapViewController.m
//  AnyMap
//
//  Created by bytedance on 2020/9/8.
//  Copyright © 2020 hwl. All rights reserved.
//

#import "IndoorMapViewController.h"
#import <SceneKit/SceneKit.h>
#import "FloorPickerView.h"
#import <SpriteKit/SpriteKit.h>

@interface IndoorMapViewController ()
@property(strong, nonatomic) SCNView *scnView;
@property(strong, nonatomic) SCNNode *floorNode;
@property(strong, nonatomic) SCNNode *floorNode2;
@property int cameraNodeY;

@property (strong, nonatomic) NSMutableDictionary<NSString*, MotionDna*> *networkUsers;
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSNumber*> *networkUsersTimestamps;

@property (strong, nonatomic) SCNNode *node;

- (void)startMotionDna;
@end

#pragma mark - TODO: 单例，左侧楼层选项，抽出ViweModel，navi接入

const int pickerViewWidth = 50;
const int pickerViewHeight = 250;
@implementation IndoorMapViewController
- (void) viewDidLoad {
    [super viewDidLoad];
    self.title = @"Indoor Map";
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    backBtn.titleLabel.text = @"back";
    [backBtn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchDown];
    
    SCNSceneSource *sceneSource = [SCNSceneSource sceneSourceWithURL:[[NSBundle mainBundle] URLForResource:@"1" withExtension:@".scn"] options:nil];
    
    _scnView = [[SCNView alloc] initWithFrame:self.view.bounds];
    _scnView.allowsCameraControl = YES;
    _scnView.showsStatistics = YES;
    _scnView.backgroundColor = UIColor.cyanColor;
    
    SCNScene *scene  = [sceneSource sceneWithOptions:nil error:nil];
    
    _cameraNodeY = 7250;
    
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.camera.automaticallyAdjustsZRange = true;
//    cameraNode.camera.orthographicScale = 2;
    [scene.rootNode addChildNode:cameraNode];
    cameraNode.position = SCNVector3Make(0, _cameraNodeY, 0);
    cameraNode.eulerAngles = SCNVector3Make(-M_PI/2, 0, 0);
    
    // create and add a light to the scene
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(0, 0, 100);
    [scene.rootNode addChildNode:lightNode];
    
    // create and add an ambient light to the scene
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor whiteColor];
    [scene.rootNode addChildNode:ambientLightNode];
    
    _floorNode = [scene.rootNode childNodeWithName:@"1" recursively:YES];
    
    _floorNode2 = [scene.rootNode childNodeWithName:@"2" recursively:YES];
    [_floorNode2 setHidden:YES];
    
    _floorNode2 = [scene.rootNode childNodeWithName:@"3" recursively:YES];
    [_floorNode2 setHidden:YES];
    
    _scnView.scene = scene;
    [self.view addSubview:_scnView];
    
    SCNMaterial *redMaterial = [[SCNMaterial alloc] init];
    redMaterial.diffuse.contents = UIColor.blueColor;
    redMaterial.specular.contents = UIColor.whiteColor;
    redMaterial.shininess = 1.0;
    
    CGFloat halfSide = 30.0;
    CGFloat deltaX = 0;
    CGFloat deltaY = 0;
    CGFloat deltaZ = 0;
    
    SCNVector3 positions[] = {
        SCNVector3Make(-(halfSide+deltaX), deltaY,  (halfSide+deltaZ)),
        SCNVector3Make( (halfSide+deltaX), deltaY,  (halfSide+deltaZ)),
        SCNVector3Make(-(halfSide+deltaX), deltaY, -(halfSide+deltaZ)),
        SCNVector3Make( (halfSide+deltaX), deltaY, -(halfSide+deltaZ)),
        SCNVector3Make(-(halfSide+deltaX), deltaY + 2*halfSide,  (halfSide+deltaZ)),
        SCNVector3Make( (halfSide+deltaX), deltaY + 2*halfSide,  (halfSide+deltaZ)),
        SCNVector3Make(-(halfSide+deltaX), deltaY + 2*halfSide, -(halfSide+deltaZ)),
        SCNVector3Make( (halfSide+deltaX), deltaY + 2*halfSide, -(halfSide+deltaZ))
    };
    
    int indices[] = {
        // bottom
        0, 2, 1,
        1, 2, 3,
        // back
        2, 6, 3,
        3, 6, 7,
        // left
        0, 4, 2,
        2, 4, 6,
        // right
        1, 3, 5,
        3, 7, 5,
        // front
        0, 1, 4,
        1, 5, 4,
        // top
        4, 5, 6,
        5, 7, 6
    };
    
    SCNGeometrySource *vertexSource = [SCNGeometrySource geometrySourceWithVertices:positions count:8];
    
    NSData *indexData = [NSData dataWithBytes:indices
                                       length:sizeof(indices)];

    SCNGeometryElement *element =
    [SCNGeometryElement geometryElementWithData:indexData
                                primitiveType:SCNGeometryPrimitiveTypeTriangles
                                 primitiveCount:12
                                  bytesPerIndex:sizeof(int)];
    
    SCNGeometry *geometry = [SCNGeometry geometryWithSources:@[vertexSource]
    elements:@[element]];
    
    _node = [SCNNode nodeWithGeometry:geometry];
    _node.geometry.materials = @[redMaterial];
    [_scnView.scene.rootNode addChildNode: _node];
    
    [self.view addSubview:backBtn];
    
    NSArray *floors = @[@"1", @"2", @"3"];
    FloorPickerView *floorPickerView = [[FloorPickerView alloc] initWithFloors:floors action:^void (NSString* toFloor, uint toIdx){
        static uint onIdx = 0;
        static NSString *onFloor = @"1";
        
        while(onIdx<toIdx){
            ++onIdx;
            SCNNode *floorNode = [scene.rootNode childNodeWithName:[floors objectAtIndex:onIdx] recursively:YES];
            [floorNode setHidden:NO];
        }
        while(onIdx>toIdx){
            SCNNode *floorNode = [scene.rootNode childNodeWithName:[floors objectAtIndex:onIdx] recursively:YES];
            [floorNode setHidden:YES];
            --onIdx;
        }
    }];
    [self.view addSubview:floorPickerView];
    
    floorPickerView.translatesAutoresizingMaskIntoConstraints = NO;
    [[NSLayoutConstraint constraintWithItem:floorPickerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:5] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:floorPickerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:floorPickerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:pickerViewWidth] setActive:YES];
    [NSLayoutConstraint constraintWithItem:floorPickerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:NSLayoutAttributeHeight];
    
//    [floorPickerView setBackgroundColor:UIColor.blackColor];
    [floorPickerView.delegate pickerView:floorPickerView didSelectRow:1 inComponent:0];
    [floorPickerView selectRow:1 inComponent:0 animated:YES];
    
    _networkUsers = [NSMutableDictionary dictionary];
    _networkUsersTimestamps = [NSMutableDictionary dictionary];
    [self startMotionDna];
}

- (void)moveCubeToX:(CGFloat)x ToY:(CGFloat)y ToZ:(CGFloat)z {
    CGFloat m = 20;
    x *= m;
    y *= m;
    z *= m;
    SCNAction *moveAction = [SCNAction moveTo:SCNVector3Make(x, y, z) duration:0.5];
    [_node runAction:moveAction];
}

- (void)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

NSString *motionTypeToNSString(MotionType motionType) {
    switch (motionType) {
        case STATIONARY:
            return @"STATIONARY";
            break;
        case FIDGETING:
            return @"FIDGETING";
            break;
        case FORWARD:
            return @"FORWARD";
            break;
        default:
            return @"UNKNOWN MOTION";
            break;
    }
    return nil;
}

@interface IndoorMapViewController (navisens)

@property (strong, nonatomic) MotionDnaManager *manager;
-(void)receiveMotionDna:(MotionDna*)motionDna;
-(void)receiveNetworkData:(MotionDna*)motionDna;
-(void)receiveNetworkData:(NetworkCode)opcode WithPayload:(NSDictionary*)payload;

@end

@implementation IndoorMapViewController (navisens)

#pragma mark MotionDna Callback Methods

//    This event receives the estimation results using a MotionDna object.
//    Check out the Getters section to learn how to read data out of this object.

- (void)receiveMotionDna:(MotionDna *)motionDna {
    Location location = [motionDna getLocation];
    XYZ localLocation = location.localLocation;
    GlobalLocation globalLocation = location.globalLocation;
//    Motion motion = [motionDna getMotion];
    
    NSString *motionDnaLocalString = [NSString stringWithFormat:@"Local XYZ Coordinates (meters): \n(%.2f,%.2f,%.2f)",localLocation.x,localLocation.y,localLocation.z];
    NSString *motionDnaHeadingString = [NSString stringWithFormat:@"Current Heading: %.2f",location.heading];
    NSString *motionDnaGlobalString = [NSString stringWithFormat:@"Global Position: \n(Lat: %.6f, Lon: %.6f)",globalLocation.latitude,globalLocation.longitude];
//    NSString *motionDnaMotionTypeString = [NSString stringWithFormat:@"Motion Type: %@",motionTypeToNSString(motion.motionType)];
//    NSDictionary<NSString*,Classifier*> *classifiers = [motionDna getClassifiers];
//    NSString *motionDnaPredictionsString = @"Predictions (BETA):\n";
//    for (NSString *classifierKey in classifiers) {
//        motionDnaPredictionsString = [motionDnaPredictionsString stringByAppendingFormat:@"Classifier: %@\n",classifierKey];
//        Classifier *classifier = [classifiers objectForKey:classifierKey];
//
//        motionDnaPredictionsString = [motionDnaPredictionsString stringByAppendingFormat:@"\tprediction: %@ confidence: %.2f\n",classifier.currentPredictionLabel,classifier.currentPredictionConfidence];
//        motionDnaPredictionsString = [motionDnaPredictionsString stringByAppendingString:@" stats:\n"];
//        for (NSString *predictionLabel in classifier.predictionStats) {
//            PredictionStats *predictionStats = [classifier.predictionStats objectForKey:predictionLabel];
//            motionDnaPredictionsString = [motionDnaPredictionsString stringByAppendingFormat:@"\t%@\n",predictionLabel];
//            motionDnaPredictionsString = [motionDnaPredictionsString stringByAppendingFormat:@"\t duration: %.2f\n",predictionStats.duration];
//            motionDnaPredictionsString = [motionDnaPredictionsString stringByAppendingFormat:@"\t distance: %.2f\n",predictionStats.distance];
//        }
//        motionDnaPredictionsString = [motionDnaPredictionsString stringByAppendingString:@"\n"];
//    }
//    [motionDnaPredictionsString stringByAppendingFormat:@"\n%@",classifiers];
//    NSString *motionDnaString = [NSString stringWithFormat:@"MotionDna Location:\n%@\n%@\n%@\n%@\n\n%@",motionDnaLocalString,
//                                 motionDnaHeadingString,
//                                 motionDnaGlobalString,
//                                 motionDnaMotionTypeString,
//                                 motionDnaPredictionsString];
    
    NSString *motionDnaString = [NSString stringWithFormat:@"MotionDna Location:\n%@\n%@\n%@\n",motionDnaLocalString,
    motionDnaHeadingString,
    motionDnaGlobalString];
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self->_receiveMotionDnaTextField setText:motionDnaString];
        NSLog(@"receiveMotionDna: %@", motionDnaLocalString);
        [self moveCubeToX:localLocation.x ToY:localLocation.y ToZ:localLocation.z];
    });
}

//    This event receives estimation results from other devices in the server room. In order
//    to receive anything, make sure you call startUDP to connect to a room. Again, it provides
//    access to a MotionDna object, which can be unpacked the same way as above.
//
//
//    If you aren't receiving anything, then the room may be full, or there may be an error in
//    your connection. See the reportError event below for more information.

- (void)receiveNetworkData:(MotionDna *)motionDna {
//    [_networkUsers setObject:motionDna forKey:[motionDna getID]];
//    double timeSinceBootSeconds = [[NSProcessInfo processInfo] systemUptime];
//    [_networkUsersTimestamps setObject:@(timeSinceBootSeconds) forKey:[motionDna getID]];
//    __block NSString *activeNetworkUsersString = [NSString string];
//    NSMutableArray<NSString*> *toRemove = [NSMutableArray array];
//
//    activeNetworkUsersString = [activeNetworkUsersString stringByAppendingString:@"Network Shared Devices:\n"];
//    [_networkUsers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, MotionDna * _Nonnull user, BOOL * _Nonnull stop) {
//        if (timeSinceBootSeconds - [[self->_networkUsersTimestamps objectForKey:[user getID]] doubleValue] > 2.0) {
//            [toRemove addObject:[user getID]];
//        } else {
//            activeNetworkUsersString = [activeNetworkUsersString stringByAppendingString:[[[user getDeviceName] componentsSeparatedByString:@";"] lastObject]];
//            XYZ location = [user getLocation].localLocation;
//            activeNetworkUsersString = [activeNetworkUsersString stringByAppendingString:[NSString stringWithFormat:@" (%.2f, %.2f, %.2f)\n",location.x, location.y, location.z]];
//        }
//    }];
//    for (NSString *key in toRemove) {
//        [_networkUsers removeObjectForKey:key];
//        [_networkUsersTimestamps removeObjectForKey:key];
//    }
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self->_receiveNetworkDataTextField.text = activeNetworkUsersString;
//    });
}

- (void)receiveNetworkData:(NetworkCode)opcode WithPayload:(NSDictionary *)payload {
    
}

- (void)startMotionDna {
    _manager = [[MotionDnaManager alloc] init];
    _manager.receiver = self;
    
    //    This functions starts up the SDK. You must pass in a valid developer's key in order for
    //    the SDK to function. IF the key has expired or there are other errors, you may receive
    //    those errors through the reportError() callback route.
    
    [_manager runMotionDna:@"6tTUNe52BD5dA6Vlm8FpW54ABDoLjRivq903gOiekpxCfBLapNcZgqsKMI70q2CV"];
    
    //    Use our internal algorithm to automatically compute your location and heading by fusing
    //    inertial estimation with global location information. This is designed for outdoor use and
    //    will not compute a position when indoors. Solving location requires the user to be walking
    //    outdoors. Depending on the quality of the global location, this may only require as little
    //    as 10 meters of walking outdoors.
    
    [_manager setLocationNavisens];
    
    //   Set accuracy for GPS positioning, states :HIGH/LOW_ACCURACY/OFF, OFF consumes
    //   the least battery.
    
    [_manager setExternalPositioningState:LOW_ACCURACY];
    
    //    Manually sets the global latitude, longitude, and heading. This enables receiving a
    //    latitude and longitude instead of cartesian coordinates. Use this if you have other
    //    sources of information (for example, user-defined address), and need readings more
    //    accurate than GPS can provide.
//    [_manager setLocationLatitude:37.787582 Longitude:-122.396627 AndHeadingInDegrees:0.0];
    
    //    Set the power consumption mode to trade off accuracy of predictions for power saving.
    
    [_manager setPowerMode:PERFORMANCE];
    
    //    Connect to your own server and specify a room. Any other device connected to the same room
    //    and also under the same developer will receive any udp packets this device sends.
    
    [_manager startUDP];
    
    //    Allow our SDK to record data and use it to enhance our estimation system.
    //    Send this file to support@navisens.com if you have any issues with the estimation
    //    that you would like to have us analyze.
    
    [_manager setBinaryFileLoggingEnabled:YES];
    
    //    Tell our SDK how often to provide estimation results. Note that there is a limit on how
    //    fast our SDK can provide results, but usually setting a slower update rate improves results.
    //    Setting the rate to 0ms will output estimation results at our maximum rate.
    
    [_manager setCallbackUpdateRateInMs:500];
    
    //    When setLocationNavisens is enabled and setBackpropagationEnabled is called, once Navisens
    //    has initialized you will not only get the current position, but also a set of latitude
    //    longitude coordinates which lead back to the start position (where the SDK/App was started).
    //    This is useful to determine which building and even where inside a building the
    //    person started, or where the person exited a vehicle (e.g. the vehicle parking spot or the
    //    location of a drop-off).
    
    [_manager setBackpropagationEnabled:YES];
    
    //    If the user wants to see everything that happened before Navisens found an initial
    //    position, he can adjust the amount of the trajectory to see before the initial
    //    position was set automatically.
    
    [_manager setBackpropagationBufferSize:2000];
    
    //    Enables AR mode. AR mode publishes orientation quaternion at a higher rate.
    
//    [_manager setARModeEnabled:YES];
}


@end
