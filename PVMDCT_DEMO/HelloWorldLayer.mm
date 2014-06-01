//
//  HelloWorldLayer.mm
//  PVMDCT_DEMO
//
//  Created by Roman Filippov on 10.12.13.
//  Copyright Roman Filippov 2013. All rights reserved.
//

// Import the interfaces
#import "HelloWorldLayer.h"

// Not included in "cocos2d.h"
#import "CCPhysicsSprite.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import <CoreMotion/CoreMotion.h>
#import <povemdct/PVManager.h>
#import <povemdct/PVCaptureManager.h>



enum {
	kTagParentNode = 1,
};


#pragma mark - HelloWorldLayer

@interface HelloWorldLayer()

@property (nonatomic, retain) CMMotionManager *motionManager;

@property (nonatomic, retain) PVManager *manager;


@property (nonatomic, retain) CCPhysicsSprite *sprite;
@property (nonatomic, retain) CCMenu *menu;

@property (nonatomic, retain) NSDictionary *gyroDevice;

-(void) initPhysics;
-(void) addNewSpriteAtPosition:(CGPoint)p;
-(void) createMenu;
@end

@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
		
		// enable events
		
		self.touchEnabled = YES;
		self.accelerometerEnabled = YES;
        self.gyroDevice = nil;
        
        self.motionManager = [[[CMMotionManager alloc] init] autorelease];
        
        
        self.manager = [PVManager sharedManager];
		
		// init physics
		[self initPhysics];
		
		// create reset button
		[self createMenu];
		
		//Set up sprite
		
#if 1
		// Use batch node. Faster
		CCSpriteBatchNode *parent = [CCSpriteBatchNode batchNodeWithFile:@"blocks.png" capacity:100];
		spriteTexture_ = [parent texture];
#else
		// doesn't use batch node. Slower
		spriteTexture_ = [[CCTextureCache sharedTextureCache] addImage:@"blocks.png"];
		CCNode *parent = [CCNode node];
#endif
		[self addChild:parent z:0 tag:kTagParentNode];
		
		
		/*CCLabelTTF *label = [CCLabelTTF labelWithString:@"Tap screen" fontName:@"Marker Felt" fontSize:32];
		[self addChild:label z:0];
		[label setColor:ccc3(0,0,255)];
		label.position = ccp( s.width/2, s.height-50);*/
        
		[self scheduleUpdate];
        
        [self addThing];
        
        //[self setupMotion];
        [[CCDirector sharedDirector] setDisplayFPS:NO];
	}
	return self;
}

- (void)onEnter
{
    [super onEnter];
    
    CGSize s = [CCDirector sharedDirector].winSize;
    
    [self addNewSpriteAtPosition:ccp(s.width/2, s.height/2)];
    [self addNewSpriteAtPosition:ccp(s.width/1.5, s.height/2)];
    [self addNewSpriteAtPosition:ccp(s.width/2.5, s.height/2)];
    [self addNewSpriteAtPosition:ccp(s.width/3, s.height/2)];
    [self addNewSpriteAtPosition:ccp(s.width/3.5, s.height/2)];
    [self addNewSpriteAtPosition:ccp(s.width/4, s.height/2)];
    [self addNewSpriteAtPosition:ccp(s.width/4.5, s.height/2)];
    [self addNewSpriteAtPosition:ccp(s.width/5, s.height/2)];
    
    NSLog(@"sizeeee %lu",sizeof(uint32_t));
}

- (void)addThing
{
    CGSize s = [[CCDirector sharedDirector] winSize];
    
    CGSize half = CGSizeMake(s.width/2, s.height/2);
    
    // Define the dynamic body.
	//Set up a 1m squared box in the physics world
	b2BodyDef bodyDef;
	bodyDef.type = b2_staticBody;
	bodyDef.position.Set(half.width/PTM_RATIO, half.height/PTM_RATIO);
	b2Body *body = world->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	dynamicBox.SetAsBox(.5f, .5f);//These are mid points for our 1m box
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.3f;
	body->CreateFixture(&fixtureDef);

    
    CCNode *parent = [self getChildByTag:kTagParentNode];
	
	//We have a 64x64 sprite sheet with 4 different 32x32 images.  The following code is
	//just randomly picking one of the images
	int idx = (CCRANDOM_0_1() > .5 ? 0:1);
	int idy = (CCRANDOM_0_1() > .5 ? 0:1);
    self.sprite = [CCPhysicsSprite spriteWithTexture:spriteTexture_ rect:CGRectMake(32 * idx,32 * idy,32,32)];
	[parent addChild:_sprite];
	
    //[_sprite setIgnoreBodyRotation:YES];
	[_sprite setPTMRatio:PTM_RATIO];
	[_sprite setB2Body:body];
	[_sprite setPosition: ccp( half.width, half.height)];
}


-(void) dealloc
{
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	m_debugDraw = NULL;
    
    self.motionManager = nil;
    self.menu = nil;
	
	[super dealloc];
}	

-(void) createMenu
{
	// Default font size will be 22 points.
	[CCMenuItemFont setFontSize:32];
	
	// Reset Button
	CCMenuItemLabel *reset = [CCMenuItemFont itemWithString:@"Reset" block:^(id sender){
		[[CCDirector sharedDirector] replaceScene: [HelloWorldLayer scene]];
	}];

	CCMenuItem *itemClient = [CCMenuItemFont itemWithString:@"Client" target:self selector:@selector(menuTapped:)];
    itemClient.tag = 1;
    
	CCMenuItem *itemServer = [CCMenuItemFont itemWithString:@"Server" target:self selector:@selector(menuTapped:)];
    itemServer.tag = 2;
	
	self.menu = [CCMenu menuWithItems:itemClient, itemServer, reset, nil];
	
	[self.menu alignItemsVertically];
	
	CGSize size = [[CCDirector sharedDirector] winSize];
	[self.menu setPosition:ccp( size.width/4, size.height/2)];
	
	
	[self addChild: self.menu z:-1];
}

- (void)menuTapped:(CCMenuItem*)sender
{
    if (sender.tag == 1)
    {
        [self.manager startClientSide:(id)self];
    } else {
        [self.manager startServerSize:(id)self];
    }
    
    [self.menu runAction:[CCFadeOut actionWithDuration:0.5f]];
}

- (void)PVManager:(PVManager*)manager didFoundDevice:(NSDictionary*)device withCapabilities:(NSString*)capabilities
{
    if ([capabilities rangeOfString:@"face_capture"].location != NSNotFound)
    {
        if (_gyroDevice == nil)
            self.gyroDevice = device;
        
        [manager connectWithDevice:device];
    }
}

- (void)PVManager:(PVManager*)manager didEstablishedConnectionWithDevice:(NSDictionary*)device withCapabilities:(NSString*)capabilities
{
    [[PVCaptureManager sharedManager] subscribeToCameraEvents:(id)self forDevice:device];
}

-(void) initPhysics
{
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	world = new b2World(gravity);
	
	
	// Do we want to let bodies sleep?
	world->SetAllowSleeping(false);
	
	world->SetContinuousPhysics(true);
	
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
	//		flags += b2Draw::e_jointBit;
	//		flags += b2Draw::e_aabbBit;
	//		flags += b2Draw::e_pairBit;
	//		flags += b2Draw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);		
	
	
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2EdgeShape groundBox;		
	
	// bottom
	
	groundBox.Set(b2Vec2(0,0), b2Vec2(s.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// top
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox,0);
	
	// left
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// right
	groundBox.Set(b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
    

}

/*-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	[super draw];
	
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	
	kmGLPushMatrix();
	
	//world->DrawDebugData();
	
	kmGLPopMatrix();
}*/

-(void) addNewSpriteAtPosition:(CGPoint)p
{
	CCLOG(@"Add sprite %0.2f x %02.f",p.x,p.y);
	// Define the dynamic body.
	//Set up a 1m squared box in the physics world
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	b2Body *body = world->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	dynamicBox.SetAsBox(.5f, .5f);//These are mid points for our 1m box
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;	
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.3f;
	body->CreateFixture(&fixtureDef);
	

	CCNode *parent = [self getChildByTag:kTagParentNode];
	
	//We have a 64x64 sprite sheet with 4 different 32x32 images.  The following code is
	//just randomly picking one of the images
	int idx = (CCRANDOM_0_1() > .5 ? 0:1);
	int idy = (CCRANDOM_0_1() > .5 ? 0:1);
	CCPhysicsSprite *sprite = [CCPhysicsSprite spriteWithTexture:spriteTexture_ rect:CGRectMake(32 * idx,32 * idy,32,32)];
	[parent addChild:sprite];
	
	[sprite setPTMRatio:PTM_RATIO];
	[sprite setB2Body:body];
	[sprite setPosition: ccp( p.x, p.y)];

}

-(void) update: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);	
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Add a new body/atlas sprite at the touched location
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
		
		[self addNewSpriteAtPosition: location];
	}
}

- (void)PVCaptureManager:(PVCaptureManager*)manager didRecievedGyroscopeData:(PVGyroData*)gdata fromDevice:(NSDictionary*)device
{
    NSLog(@"Gyro received!");
}

- (void)PVCaptureManager:(PVCaptureManager*)manager didRecievedAccelerometerData:(PVAccelerometerData*)accdata fromDevice:(NSDictionary*)device
{
    NSLog(@"Accl received!");
}

- (void)PVCaptureManager:(PVCaptureManager*)manager didRecievedMotionData:(PVMotionData*)mdata fromDevice:(NSDictionary*)device
{
    if ([[device objectForKey:@"host"] isEqualToString:[_gyroDevice objectForKey:@"host"]]) {
        
        NSLog(@"%.3f / %.3f", mdata.gravity.y, mdata.gravity.x);
        
        b2Vec2 gravity;
        gravity.Set(mdata.gravity.y*10, -mdata.gravity.x*10);
        world->SetGravity(gravity);
    
    } else {
        
        CGFloat yAngle = -mdata.gravity.y * 90.0f;
        
        NSLog(@"%.3f ", yAngle);
        
        [self.sprite setRotation:yAngle];
    }
}

- (void)PVCaptureManager:(PVCaptureManager*)manager didReceivedTouchAtPosition:(CGPoint)touchPosition fromDevice:(NSDictionary*)device
{
    NSLog(@"%.3f / %.3f", touchPosition.x, touchPosition.y);
    [self addNewSpriteAtPosition:touchPosition];
}

- (void)PVCaptureManager:(PVCaptureManager*)manager didRecievedFaceCaptureAtRect:(CGRect)captureRect fromDevice:(NSDictionary*)device
{
    NSLog(@"%@",NSStringFromCGRect(captureRect));
}

@end
