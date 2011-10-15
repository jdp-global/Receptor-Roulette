//
//  MZNHDocumentationLayer.h
//  Receptor Roulette
//
//  Created by Michael Victor Zink on 10/14/11.
//  Copyright 2011 Trustees of the University of Chicago. All rights reserved.
//

#import "cocos2d.h"

@interface MZNHDocumentationLayer : CCLayer <UIWebViewDelegate> {
	UIWebView * webView;
}

@property(nonatomic, retain) UIWebView * webView;

+(CCScene *) scene;

@end
