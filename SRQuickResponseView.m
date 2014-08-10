//
//  SRQuickResponseView.m
//  QuickResponse
//
//  Created by ycao on 8/9/14.
//  Copyright (c) 2014 schemetrical. All rights reserved.
//

#import "SRQuickResponseView.h"

@implementation SRQuickResponseView {
    AVCaptureSession *captureSession;
    AVCaptureVideoPreviewLayer *videoPreviewLayer;
    AVAudioPlayer *audioPlayer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.reading = YES;
    }
    return self;
}

// MARK: Capture

- (void)setReading:(BOOL)reading {
    if (_reading == reading) {
        return;
    }
    _reading = reading;
    if (reading) {
        NSError *error;
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
        
        if (!input) {
            // If no input, abort. Do check if there's permission to a camera before you load this.
            NSLog(@"%@", [error localizedDescription]);
            abort();
        }
        
        if (!captureSession) {
            captureSession = [[AVCaptureSession alloc] init];
            [captureSession addInput:input];
            
            AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
            [captureSession addOutput:captureMetadataOutput];
            
            dispatch_queue_t dispatchQueue;
            dispatchQueue = dispatch_queue_create("myQueue", NULL);
            [captureMetadataOutput setMetadataObjectsDelegate:self
                                                        queue:dispatchQueue];
            [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
        }
        
        if (!videoPreviewLayer) {
            videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
            [videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
            [videoPreviewLayer setFrame:self.layer.bounds];
            [self.layer addSublayer:videoPreviewLayer];
        }
        
        // Start video capture.
        [captureSession startRunning];
    } else {
        // Stop video capture.
        [captureSession stopRunning];
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if ([metadataObjects count]) {
        // Get the metadata object.
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.reading = NO;
                [self.delegate receivedResponse:[metadataObj stringValue]];
            });
        }
    }
}

@end
