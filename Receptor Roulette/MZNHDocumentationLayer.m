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
		self.webView.delegate = self;
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

// cocos2d stuff

- (void) onEnterTransitionDidFinish {
	[[[CCDirector sharedDirector] openGLView] addSubview: self.webView];
}

- (void) onExit {
	[self.webView removeFromSuperview];
}

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];	
	MZNHDocumentationLayer *layer = [MZNHDocumentationLayer node];
	[scene addChild: layer];
	return scene;
}

// UIWebViewDelegate stuff

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if ([request.URL.path isEqualToString: @"/exit!"]) {
		[[CCDirector sharedDirector] performSelector: @selector(popScene) withObject: nil afterDelay: 0.0];
		return NO;
	} else {
		return YES;
	}
}

- (void) dealloc {
	[self.webView release];
	[super dealloc];
}

@end
