//
//  MZNHTCell.m
//  Receptor Roulette
//
//  Created by Michael Victor Zink on 5/17/11.
//  Copyright 2011 Trustees of the University of Chicago. All rights reserved.
//

#import "MZNHTCellSprite.h"

#define ARC4RANDOM_MAX 0x100000000


/** The format of image files for each peptide:
 MZNH_Tc_[peptide][functional_flag].png
 [functional_flag] should be an underscore character (_) if
 the TCell is not functional */
static NSString * spriteFilenameFormat = @"MZNH_Tc%@_%@%@.png";

/** The peptideNames array is lazily populated in +peptideNames below */
static NSArray * peptideNames = nil;

@implementation MZNHTCellSprite

@synthesize peptide, isHelper, functional;

+ (MZNHTCellSprite *) randomTCellSprite {
	// Pick a random peptide name
	NSUInteger i = random() % ([[MZNHTCellSprite peptideNames] count]-1);
	NSString * peptideName = [[MZNHTCellSprite peptideNames] objectAtIndex: i];
	
	BOOL functional = YES;
	BOOL isHelper = NO;
	// There is an arbitrary 7-in-20 (35%) chance a TCell is CD4+
	// i.e. is a helper TCell instead of a killer TCell
	if (random() % 20 < 7) {
		functional = NO;
		isHelper = YES;
	// And an arbitrary 1-in-5 (20%) chance a TCell is nonfunctional
	} else if (random() % 5 < 1) {
		functional = NO;
	}

	// The sprite is initalized with the appropriate imagename.
	// cocos2d will handle caching sprites.
	MZNHTCellSprite * cell = [MZNHTCellSprite spriteWithFile:
							  [NSString stringWithFormat: spriteFilenameFormat,
							   (isHelper ? @"h" : @""), peptideName, (functional ? @"" : @"_")]];
	cell.peptide = peptideName;
	cell.functional = functional;
	cell.isHelper = isHelper;

	// Place the sprite randomly along the left edge of the screen
	CGSize size = [[CCDirector sharedDirector] winSize];
	cell.position = ccp(0.0, ((float)arc4random()/ARC4RANDOM_MAX) *
						(size.height - cell.contentSize.height * 2)
						+ cell.contentSize.height );

	return cell;
}

/** Returns the array of valid peptide names. If necessary, populates it first. */
+ (NSArray *) peptideNames
{
	if (! peptideNames)
		peptideNames = [[NSArray alloc] initWithObjects: @"SB", @"SG", @"SP", @"TB", @"TG", @"TP", nil];
	return peptideNames;
}

@end
