//
//  SRQuickResponseView.h
//  QuickResponse
//
//  Created by ycao on 8/9/14.
//  Copyright (c) 2014 schemetrical. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

/*!
 @protocol SRQuickResponseViewDelegate
 @abstract
 Defines an interface for delegates of SRQuickResponseViewDelegate to receive scanned data.
*/
@protocol SRQuickResponseViewDelegate <NSObject>

@optional

/*!
 @method receivedResponse:
 @abstract
 Called whenever an AVCaptureMetadataOutput instance emits a QR object.
*/
- (void)receivedResponse:(NSString *)response;

@end

/*!
 @class SRQuickResponseView
 @abstract
 SRQuickResponseView is a subclass of UIView that loads the camera when initialized and detects QR codes and forwards them to the delegate.
 
 @discussion
 You must check if the app has permission to use the camera before initializing to prevent crashes.
*/

@interface SRQuickResponseView : UIView <AVCaptureMetadataOutputObjectsDelegate>

/*!
 @property reading
 @abstract
 BOOL value to start or stop the camera reading QR codes.
 
 @discussion
 If no input, abort. Do check if there's permission to a camera before you load this.
*/
@property (nonatomic) BOOL reading;

/*!
 @property delegate
 @abstract
 The receiver’s delegate or nil if it doesn’t have a delegate.
*/
@property (nonatomic, strong) id <SRQuickResponseViewDelegate> delegate;

@end
