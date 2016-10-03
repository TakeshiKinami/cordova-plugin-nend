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
package net.nend;

import android.app.Activity;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import net.nend.android.NendAdInterstitial;
import net.nend.android.NendAdInterstitial.NendAdInterstitialShowResult;
import net.nend.android.NendAdView;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;

import java.util.HashMap;

public class Nend extends CordovaPlugin {
    private static HashMap<String, NendAdView> mNendAdHashMap = new HashMap<String, NendAdView>();
    private static ViewGroup sRootView = null;
    
    /**
     * Constructor.
     */
    public Nend() {
    }
    
    /**
     * Sets the context of the Command. This can then be used to do things like
     * get file paths associated with the Activity.
     *
     * @param cordova The context of the main Activity.
     * @param webView The CordovaWebView Cordova is running in.
     */
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
    }
    
    /**
     * Executes the request and returns PluginResult.
     *
     * @param action          The action to execute.
     * @param args            JSONArry of arguments for the plugin.
     * @param callbackContext The callback id used when calling back into JavaScript.
     * @return True if the action was valid, false if not.
     */
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if ("loadBanner".equals(action)) {
            this.loadBanner(args.getString(0), args.getString(1), args.getString(2));
        } else if ("showBanner".equals(action)) {
            this.showBanner(args.getString(0), args.getString(1));
        } else if ("hideBanner".equals(action)) {
            this.hideBanner(args.getString(0));
        } else if ("pauseBanner".equals(action)) {
            this.pauseBanner(args.getString(0));
        } else if ("resumeBanner".equals(action)) {
            this.resumeBanner(args.getString(0));
        } else if ("releaseBanner".equals(action)) {
            this.releaseBanner(args.getString(0));
        } else if ("loadInterstitial".equals(action)) {
            this.loadInterstitial(args.getString(0), args.getString(1));
        } else if ("showInterstitial".equals(action)) {
            this.showInterstitial(callbackContext, args.getString(0));
        } else if ("dismissInterstitial".equals(action)) {
            this.dismissInterstitial();
        } else {
            return false;
        }
        return true;
    }

    public void loadBanner(final String apiKey, final String spotID, final String isAdjust) {
        final Activity activity = this.cordova.getActivity();
        activity.runOnUiThread(new Runnable() {
            public void run() {

                if (null == sRootView) {
                    sRootView = new FrameLayout(activity);
                }
                if (null == sRootView.getParent()) {
                    activity.addContentView(sRootView, new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
                }

                if (!mNendAdHashMap.containsKey(spotID)) {
                    int intSpotID = Integer.parseInt(spotID);
                    NendAdView nendAdView = new NendAdView(activity, intSpotID, apiKey, !isAdjust.equals("null"));
                    nendAdView.loadAd();
                    mNendAdHashMap.put(spotID, nendAdView);
                }

            }
        });
    }

    public void showBanner(final String position, final String spotID) {
        final Activity activity = this.cordova.getActivity();
        activity.runOnUiThread(new Runnable() {
            public void run() {
                if (!spotID.equals("null")) {
                    if (mNendAdHashMap.containsKey(spotID)) {
                        addBanner(mNendAdHashMap.get(spotID), position);
                    }
                } else {
                    for (NendAdView nendAdView : mNendAdHashMap.values()) {
                        addBanner(nendAdView, position);
                    }
                }
            }
        });
    }

    private  void  addBanner(NendAdView nendAdView, String position) {
        sRootView.removeView(nendAdView);
        FrameLayout.LayoutParams lp = new FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT, Gravity.CENTER_HORIZONTAL | ("Top".equals(position) ? Gravity.TOP : Gravity.BOTTOM));
        nendAdView.setLayoutParams(lp);
        nendAdView.setVisibility(View.VISIBLE);
        sRootView.addView(nendAdView);

    }

    public void hideBanner(final String spotID) {
        final Activity activity = this.cordova.getActivity();
        activity.runOnUiThread(new Runnable() {
            public void run() {
                if (!spotID.equals("null")) {
                    if (mNendAdHashMap.containsKey(spotID)) {
                        mNendAdHashMap.get(spotID).setVisibility(View.GONE);
                    }
                } else {
                    for (NendAdView nendAdView : mNendAdHashMap.values()) {
                        nendAdView.setVisibility(View.GONE);
                    }
                }
            }
        });
    }

    public void pauseBanner(final String spotID) {
        if (!spotID.equals("null")) {
            if (mNendAdHashMap.containsKey(spotID)) {
                mNendAdHashMap.get(spotID).pause();
            }
        } else {
            for (NendAdView nendAdView : mNendAdHashMap.values()) {
                nendAdView.pause();
            }
        }
    }

    public void resumeBanner(final String spotID) {
        if (!spotID.equals("null")) {
            if (mNendAdHashMap.containsKey(spotID)) {
                mNendAdHashMap.get(spotID).resume();
            }
        } else {
            for (NendAdView nendAdView : mNendAdHashMap.values()) {
                nendAdView.resume();
            }
        }
    }

    public void releaseBanner(final String spotID) {
        final Activity activity = this.cordova.getActivity();
        activity.runOnUiThread(new Runnable() {
            public void run() {
                if (!spotID.equals("null")) {
                    if (mNendAdHashMap.containsKey(spotID)) {
                        sRootView.removeView(mNendAdHashMap.get(spotID));
                        mNendAdHashMap.remove(spotID);
                    }
                } else {
                    for (NendAdView nendAdView : mNendAdHashMap.values()) {
                        sRootView.removeView(nendAdView);
                    }
                    mNendAdHashMap.clear();
                }
            }
        });
    }

    public void loadInterstitial(final String apiKey, final String spotID) {
        final Activity activity = this.cordova.getActivity();
        int intSpotID = Integer.parseInt(spotID);
        NendAdInterstitial.loadAd(activity, apiKey, intSpotID);
    }

    public void showInterstitial(final CallbackContext callbackContext,final String spotID) {
        final Activity activity = this.cordova.getActivity();
        activity.runOnUiThread(new Runnable() {
            public void run() {
                NendAdInterstitialShowResult result;
                if (spotID.equals("null")) {
                    result = NendAdInterstitial.showAd(activity);
                } else {
                    int intSpotID = Integer.parseInt(spotID);
                    result = NendAdInterstitial.showAd(activity, intSpotID);
                }
                if (NendAdInterstitialShowResult.AD_SHOW_SUCCESS == result) {
                    callbackContext.success();
                } else {
                    callbackContext.error(result.ordinal());
                }
            }
        });
    }

    public void dismissInterstitial() {
        final Activity activity = this.cordova.getActivity();
        activity.runOnUiThread(new Runnable() {
            public void run() {
                NendAdInterstitial.dismissAd();
            }
        });
    }
}
