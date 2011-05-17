//
//  HelloWorldLayer.m
//  Receptor Roulette
//
//  Created by Naren Hazareesingh on 5/10/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "MZNHRouletteLayer.h"

// HelloWorldLayer implementation
@implementation MZNHRouletteLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MZNHRouletteLayer *layer = [MZNHRouletteLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super initWithColor:ccc4(120, 225, 255, 255)])) {
		[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
		CGSize size = [[CCDirector sharedDirector] winSize];
        receptor = [CCSprite spriteWithFile:@"APC.png"];
        receptor.scale = .40;
        receptor.position = ccp(590, size.height/2);
        //receptor.position = ccp(240, size.height/2);
        CCLabelTTF *score = [CCLabelTTF labelWithString:@"Score: 143" fontName:@"Helvetica" fontSize:15];
        score.position = ccp(50, 300);
        [self addChild:score];
        
        
        
        NSArray *images = [NSArray arrayWithObjects:@"APC_SP.png",
                           @"APC_TG.png",
                           @"APC_TP.png",
                           @"APC_SP.png",
                           @"APC_TP.png",
                           @"APC_TG.png", nil];       
        for(int i = 0; i < images.count; ++i) {
            NSString *image = [images objectAtIndex:i];
            CCSprite *sprite = [CCSprite spriteWithFile:image];
            //float offsetFraction = ((float)(i+1))/(images.count+1);
            
            sprite.scale = 2;
            
            //sprite.rotation = [self angleAtPosition:sprite.position];
            [receptor addChild:sprite];
            sprite.position = ccp(100, 100);
            //[movableSprites addObject:sprite];
        }
        
        
        
        
        
        
        
        
        [self addChild:receptor];
        NSLog(@"AP: (%f,%f)", receptor.anchorPoint.x,receptor.anchorPoint.y);
        
        movableSprites = [[NSMutableArray alloc] init];
        images = [NSArray arrayWithObjects:@"Tc_TG.png",
                           @"Tc_TG.png",
                           @"Tc_TG.png",
                           @"Tc_TG.png",
                           @"Tc_TG.png",
                           @"Tc_TG.png", nil];       
        for(int i = 0; i < images.count; ++i) {
            NSString *image = [images objectAtIndex:i];
            CCSprite *sprite = [CCSprite spriteWithFile:image];
            float offsetFraction = ((float)(i+1))/(images.count+1);
            sprite.position = ccp(size.width*offsetFraction, random()%310);
            sprite.scale = .7;
            sprite.rotation = [self angleAtPosition:sprite.position];
            [self addChild:sprite];
            [movableSprites addObject:sprite];
        }

	}
	return self;
}


// Finds sprite that has been touched
- (void)selectSpriteForTouch:(CGPoint)touchLocation {
    CCSprite * newSprite = nil;
    for (CCSprite *sprite in movableSprites) {
        if (CGRectContainsPoint(sprite.boundingBox, touchLocation)) {            
            newSprite = sprite;
            break;
        }
    }    
    if (newSprite != selSprite) {            
        selSprite = newSprite;
    }
}

//On touchDownInside, 'selects' sprite
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {    
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self selectSpriteForTouch:touchLocation];      
    return TRUE;    
}

-(CGFloat)angleAtPosition:(CGPoint)position {
	return -35*cos(position.y*M_PI/320)+350*pow(M_E, position.x*-.014);
}

// handles movement
- (void)panForTranslation:(CGPoint)translation {    
    if (selSprite) {
        CGPoint newPos = ccpAdd(selSprite.position, translation);
        selSprite.position = newPos;
        selSprite.rotation = [self angleAtPosition:newPos];
    }  
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {       
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);    
    [self panForTranslation:translation];    
}

/*- (void)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch* touch = [touches anyObject];
    CGPoint location = [self convertTouchToNodeSpace:touch];
    CGRect spriteRect = planet1.boundingBox;
    if(CGRectContainsPoint(spriteRect, location)) {
        // particularSprite touched
        NSLog(@"touched planet1");
    }
}*/

- (void) update: (ccTime) dt
{
	CGSize size = [[CCDirector sharedDirector] winSize];
    receptor.rotation -= .3;
    //receptor.position = ccp(receptor.position.x+.2, receptor.position.y);
	for (CCSprite * cell in movableSprites) {
		cell.position = ccpAdd(cell.position, ccp(dt * 40.0, 0));
		cell.rotation = [self angleAtPosition: cell.position];
		
		if (cell.position.x >= (size.width + cell.contentSize.width)) {
			[movableSprites removeObject: cell];
			[self removeChild: cell cleanup:YES];
		}
	}
}

- (void) spawnTCell: (ccTime) dt
{
	// FIXME: Add increasing probabilities based on total time passed
	if (arc4random() & 1) {
		CCSprite * cell = [CCSprite spriteWithFile: @"Tc_TG.png"];
		CGSize size = [[CCDirector sharedDirector] winSize];
		cell.position = ccp(0.0, ((float)arc4random()/(2.0*RAND_MAX)) *
							(size.height - cell.contentSize.height * 2)
							+ cell.contentSize.height );
		cell.scale = 0.0;
		CCAction * scaleAction = [CCScaleTo actionWithDuration: 0.2 scale: 0.7 ];
		[cell runAction: scaleAction];
		[movableSprites addObject: cell];
		[self addChild: cell];
	}
}

- (void) onEnter
{
	[super onEnter];
	[self scheduleUpdate];
	[self schedule: @selector(spawnTCell:) interval: 1.0];
}

- (void) onExit
{
	[self unscheduleUpdate];
	[self unschedule: @selector(spawnTCell:)];
	[super onExit];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    [movableSprites release];
    movableSprites = nil;
	[super dealloc];
}
@end
