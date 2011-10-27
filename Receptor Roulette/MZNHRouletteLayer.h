//
//  HelloWorldLayer.h
//  Receptor Roulette
//
//  Created by Naren Hazareesingh on 5/10/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "CGPointExtension.h"
#import "MZNHTCellSprite.h"
#import "MZNHAPCReceptorSprite.h"
#import <AudioToolbox/AudioServices.h>

// HelloWorldLayer
@interface MZNHRouletteLayer : CCLayerColor
{
    int score;
    CCLabelTTF *scoreLabel;
	CCLabelTTF *docsButtonLabel;
    CCSprite *apc; //
    MZNHTCellSprite *selSprite; // T-cell the user taps on
    NSMutableArray *tcellSprites; // Keeps track of t-cells on the screen
    NSMutableArray *receptorSprites; // Keeps track or receptors on the APC
    float apcRadius;
	SystemSoundID popSoundID;
	NSUInteger nextTcellZOrder;
	float totalTime;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(BOOL)tCellCollidesWithReceptor:(MZNHTCellSprite *)cell;
-(CGFloat)angleAtPosition:(CGPoint)position;
-(void)spawnTCell:(ccTime)dt;

@end
