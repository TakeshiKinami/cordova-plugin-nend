/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#include <sys/types.h>
#include <sys/sysctl.h>
#include "TargetConditionals.h"

#import <Cordova/CDV.h>
#import "CDVNend.h"

#import "NADView.h"
#import "NADInterstitial.h"

@interface CDVNend()<NADViewDelegate,NADInterstitialDelegate>
@property (nonatomic) NSMutableDictionary* bannerDict;
@end

@interface CDVNend () {}
@end

@implementation CDVNend

#pragma mark - Banner

- (void)loadBanner:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        if (!self.bannerDict) {
            self.bannerDict = [NSMutableDictionary new];
        }
        
        NADView* nadView = self.bannerDict[command.arguments[1]];
        
        if (!nadView) {
            nadView = [[NADView alloc] initWithIsAdjustAdSize:command.arguments[2] != [NSNull null]];
            nadView.delegate = self;
            self.bannerDict[command.arguments[1]] = nadView;
            [nadView setNendID:command.arguments[0] spotID:command.arguments[1]];
        }
        
        [nadView load];
        
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)showBanner:(CDVInvokedUrlCommand*)command{
    if (!self.bannerDict) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }
    
    if ([NSNull null] != command.arguments[1]) {
        NADView* nadView = self.bannerDict[command.arguments[1]];
        if (nadView) {
            [self setBannerPosition:nadView position:command.arguments[0]];
        } else {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            return;
        }
    }
    else {
        for (NSString* spotID in [self.bannerDict keyEnumerator]) {
            NADView* nadView = self.bannerDict[spotID];
            [self setBannerPosition:nadView position:command.arguments[0]];
        }
    }
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setBannerPosition:(NADView *)adView position:(NSString *)position {
    adView.center = self.webView.superview.center;
    if ([position isEqualToString:@"Top"]) {
        adView.frame = CGRectMake(adView.frame.origin.x, 0, adView.frame.size.width, adView.frame.size.height);
        adView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    } else {
        adView.frame = CGRectMake(adView.frame.origin.x, self.webView.superview.frame.size.height - adView.frame.size.height, adView.frame.size.width, adView.frame.size.height);
        adView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    if (!adView.superview) {
        [self.webView.superview addSubview:adView];
    }
    adView.hidden = NO;
}

- (void)hideBanner:(CDVInvokedUrlCommand*)command {
    if (!self.bannerDict) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }
    
    if ([NSNull null] != command.arguments[0]) {
        NADView* nadView = self.bannerDict[command.arguments[0]];
        if (nadView) {
            nadView.hidden = YES;
        } else {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            return;
        }
    }
    else {
        for (NSString* spotID in [self.bannerDict keyEnumerator]) {
            NADView* nadView = self.bannerDict[spotID];
            nadView.hidden = YES;
        }
    }
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)pauseBanner:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        if (!self.bannerDict) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            return;
        }
        
        if ([NSNull null] != command.arguments[0]) {
            NADView* nadView = self.bannerDict[command.arguments[0]];
            if (nadView) {
                [nadView pause];
            } else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                return;
            }
        }
        else {
            for (NSString* spotID in [self.bannerDict keyEnumerator]) {
                NADView* nadView = self.bannerDict[spotID];
                [nadView pause];
            }
        }
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)resumeBanner:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        if (!self.bannerDict) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            return;
        }
        
        if ([NSNull null] != command.arguments[0]) {
            NADView* nadView = self.bannerDict[command.arguments[0]];
            if (nadView) {
                [nadView resume];
            } else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                return;
            }
        }
        else {
            for (NSString* spotID in [self.bannerDict keyEnumerator]) {
                NADView* nadView = self.bannerDict[spotID];
                [nadView resume];
            }
        }
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)releaseBanner:(CDVInvokedUrlCommand*)command {
    if (!self.bannerDict) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }
    
    if ([NSNull null] != command.arguments[0]) {
        NADView* nadView = self.bannerDict[command.arguments[0]];
        if (nadView) {
            nadView.hidden = YES;
            [nadView removeFromSuperview];
            [self.bannerDict removeObjectForKey:command.arguments[0]];
        } else {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            return;
        }
    }
    else {
        for (NSString* spotID in [self.bannerDict keyEnumerator]) {
            NADView* nadView = self.bannerDict[spotID];
            nadView.hidden = YES;
            [nadView removeFromSuperview];
        }
        [self.bannerDict removeAllObjects];
    }
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


#pragma mark - NADViewDelegate

- (void)nadViewDidFinishLoad:(NADView *)adView {
    NSLog(@"delegate nadViewDidFinishLoad:");
}

//- (void)nadViewDidReceiveAd:(NADView *)adView {
//    NSLog(@"delegate nadViewDidReceiveAd:");
//}

- (void)nadViewDidFailToReceiveAd:(NADView *)adView
{
    NSLog(@"delegate nadViewDidFailToLoad:");
    // エラーごとに分岐する
    NSError* error = adView.error;
    NSString* domain = error.domain;
    NADViewErrorCode errorCode = error.code;
    // isOutputLog = NO でも、domain を利用してアプリ側で任意出力が可能
    NSLog(@"log %d", adView.isOutputLog);
    NSLog(@"%@",[NSString stringWithFormat: @"code=%ld, message=%@", (long)errorCode, domain]);
    switch (errorCode) {
        case NADVIEW_AD_SIZE_TOO_LARGE:
        // 広告サイズがディスプレイサイズよりも大きい
        break;
        case NADVIEW_INVALID_RESPONSE_TYPE:
        // 不明な広告ビュータイプ
        break;
        case NADVIEW_FAILED_AD_REQUEST:
        // 広告取得失敗
        break;
        case NADVIEW_FAILED_AD_DOWNLOAD:
        // 広告画像の取得失敗
        break;
        case NADVIEW_AD_SIZE_DIFFERENCES:
        // リクエストしたサイズと取得したサイズが異なる
        break;
        default:
        break;
    }
}


#pragma mark - Interstitial

- (void)loadInterstitial:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        [NADInterstitial sharedInstance].delegate = self;
        [[NADInterstitial sharedInstance]loadAdWithApiKey:command.arguments[0] spotId:command.arguments[1]];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)showInterstitial:(CDVInvokedUrlCommand *)command {
    NADInterstitialShowResult result;
    
    if ([NSNull null] != command.arguments[0]) {
        result = [[NADInterstitial sharedInstance] showAdFromViewController:self.viewController spotId:command.arguments[0]];
    } else {
        result = [[NADInterstitial sharedInstance] showAdFromViewController:self.viewController];
    }
    
    if (AD_SHOW_SUCCESS != result) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt:result];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)dismissInterstitial:(CDVInvokedUrlCommand *)command {
    [[NADInterstitial sharedInstance] dismissAd];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
