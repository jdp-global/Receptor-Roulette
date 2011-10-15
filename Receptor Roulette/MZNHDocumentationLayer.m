//
//  MZNHDocumentationLayer.m
//  Receptor Roulette
//
//  Created by Michael Victor Zink on 10/14/11.
//  Copyright 2011 Trustees of the University of Chicago. All rights reserved.
//

#import "MZNHDocumentationLayer.h"

@implementation MZNHDocumentationLayer

@synthesize webView;

- (id)init
{
    self = [super init];
    if (self) {
		CGRect webFrame = CGRectNull;
		webFrame.size = [[CCDirector sharedDirector] winSize];
		webFrame.origin = CGPointZero;
		self.webView = [[UIWebView alloc] initWithFrame: webFrame];
		self.webView.backgroundColor = [UIColor whiteColor];
		[self.webView setOpaque: NO];
		NSURL * url = [[NSBundle mainBundle]
					   URLForResource: @"test"
					   withExtension: @"html"];
		NSURLRequest * req = [NSURLRequest requestWithURL: url];
		[self.webView loadRequest: req];
	}

    return self;
}

- (void) onEnterTransitionDidFinish {
	[[[CCDirector sharedDirector] openGLView] addSubview: self.webView];
}

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];	
	MZNHDocumentationLayer *layer = [MZNHDocumentationLayer node];
	[scene addChild: layer];
	return scene;
}

- (void) dealloc {
	[self.webView release];
	[super dealloc];
}

@end
