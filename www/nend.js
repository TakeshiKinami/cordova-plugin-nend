/*
 *
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *
*/

var nendExport = {};

var argscheck = require('cordova/argscheck'),
    channel = require('cordova/channel'),
    utils = require('cordova/utils'),
    exec = require('cordova/exec'),
    cordova = require('cordova');

nendExport.loadBanner = function(apiKey, spotID, isAdjust) {
    var me = this;
    channel.onDeviceReady.subscribe(function() {
        me.loadBannerInternal(function(info) {
        },function(e) {
        },
        apiKey,
        spotID,
        isAdjust);
    });
}

nendExport.loadBannerInternal = function(successCallback, errorCallback, apiKey, spotID, isAdjust) {
    argscheck.checkArgs('fFSSS', 'Nend.loadBanner', arguments);
    exec(successCallback, errorCallback, "Nend", "loadBanner", [apiKey, spotID, isAdjust]);
};

nendExport.showBanner = function(spotID) {
    this.showBannerTop(spotID);
}

nendExport.showBannerTop = function(spotID) {
    var me = this;

    channel.onDeviceReady.subscribe(function() {
        me.showBannerInternal(function(info) {
        },function(e) {
        },
        "Top",
        spotID);
    });
}

nendExport.showBannerBottom = function(spotID) {
    var me = this;

    channel.onDeviceReady.subscribe(function() {
        me.showBannerInternal(function(info) {
        },function(e) {
        },
        "Bottom",
        spotID);
    });
}

nendExport.showBannerInternal = function(successCallback, errorCallback, bannerPosition, spotID) {
    argscheck.checkArgs('fFS*', 'Nend.showBanner', arguments);
    exec(successCallback, errorCallback, "Nend", "showBanner", [bannerPosition, spotID]);
};

nendExport.hideBanner = function(spotID) {
    var me = this;

    channel.onDeviceReady.subscribe(function() {
        me.hideBannerInternal(function(info) {
        },function(e) {
        },
        spotID);
    });
}

nendExport.hideBannerInternal = function(successCallback, errorCallback, spotID) {
    argscheck.checkArgs('fF*', 'Nend.showBanner', arguments);
    exec(successCallback, errorCallback, "Nend", "hideBanner", [spotID]);
};

nendExport.pauseBanner = function(spotID) {
    var me = this;

    channel.onDeviceReady.subscribe(function() {
        me.pauseBannerInternal(function(info) {
        },function(e) {
        },
        spotID);
    });
}

nendExport.pauseBannerInternal = function(successCallback, errorCallback, spotID) {
    argscheck.checkArgs('fF*', 'Nend.showBanner', arguments);
    exec(successCallback, errorCallback, "Nend", "pauseBanner", [spotID]);
};

nendExport.resumeBanner = function(spotID) {
    var me = this;

    channel.onDeviceReady.subscribe(function() {
        me.resumeBannerInternal(function(info) {
        },function(e) {
        },
        spotID);
    });
}

nendExport.resumeBannerInternal = function(successCallback, errorCallback, spotID) {
    argscheck.checkArgs('fF*', 'Nend.showBanner', arguments);
    exec(successCallback, errorCallback, "Nend", "resumeBanner", [spotID]);
};

nendExport.releaseBanner = function(spotID) {
    var me = this;

    channel.onDeviceReady.subscribe(function() {
        me.releaseBannerInternal(function(info) {
        },function(e) {
        },
        spotID);
    });
}

nendExport.releaseBannerInternal = function(successCallback, errorCallback, spotID) {
    argscheck.checkArgs('fF*', 'Nend.showBanner', arguments);
    exec(successCallback, errorCallback, "Nend", "releaseBanner", [spotID]);
};


nendExport.loadInterstitial = function(apiKey, spotID) {
    var me = this;

    channel.onDeviceReady.subscribe(function() {
        me.loadInterstitialInternal(function(info) {
        },function(e) {
        },
        apiKey,
        spotID);
    });
}

nendExport.loadInterstitialInternal = function(successCallback, errorCallback, apiKey, spotID) {
    argscheck.checkArgs('fFSS', 'Nend.loadInterstitial', arguments);
    exec(successCallback, errorCallback, "Nend", "loadInterstitial", [apiKey, spotID]);
};

nendExport.showInterstitial = function(callback, spotID) {
    var me = this;

    channel.onDeviceReady.subscribe(function() {
        me.showInterstitialInternal(function(info) {
            callback(0);
        },function(e) {
            callback(e);
        },
        spotID);
    });
}

nendExport.showInterstitialInternal = function(successCallback, errorCallback, spotID) {
    argscheck.checkArgs('fF*', 'Nend.showInterstitial', arguments);
    exec(successCallback, errorCallback, "Nend", "showInterstitial", [spotID]);
};

nendExport.dismissInterstitial = function(spotID) {
    var me = this;

    channel.onDeviceReady.subscribe(function() {
        me.dismissInterstitialInternal(function(info) {
        },function(e) {
        },
        spotID);
    });
}

nendExport.dismissInterstitialInternal = function(successCallback, errorCallback, spotID) {
    argscheck.checkArgs('fF*', 'Nend.dismissInterstitial', arguments);
    exec(successCallback, errorCallback, "Nend", "dismissInterstitial", [spotID]);
};


module.exports = nendExport;
