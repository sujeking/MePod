function setupWebViewJavascriptBridge(callback) {
    if (window.WebViewJavascriptBridge) { return callback(WebViewJavascriptBridge); }
    if (window.WVJBCallbacks) { return window.WVJBCallbacks.push(callback); }
    window.WVJBCallbacks = [callback];
    var WVJBIframe = document.createElement('iframe');
    WVJBIframe.style.display = 'none';
    WVJBIframe.src = 'wvjbscheme://__BRIDGE_LOADED__';
    document.documentElement.appendChild(WVJBIframe);
    setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)
}

function setUpHXSJSBridge(callback) {
    window.HXSJSBridge = {
        pushViewWithUrlAndTitle : function pushViewWithUrlAndTitle(url, title, callback) {
            if (window.WebViewJavascriptBridge) {
                WebViewJavascriptBridge.callHandler('pushViewWithUrlAndTitle', {'url': url, 'title':title}, callback);
            }
        },
        setNavigationButton : function setNavigationButton(button) {
            if(window.WebViewJavascriptBridge) {
                WebViewJavascriptBridge.callHandler('setNavigationButton', button,
                                                    function(response) {
                                                    })
            }
        },
        
        needUserLogin : function needUserLogin(callback) {
            if (window.WebViewJavascriptBridge) {
                WebViewJavascriptBridge.callHandler('needUserLogin', {}, callback);
            }
        },
        
        closeCurrentView : function closeCurrentView(callback) {
            if (window.WebViewJavascriptBridge) {
                WebViewJavascriptBridge.callHandler('closeCurrentView', {}, callback);
            }
        },
        
        pushMyCouponView : function pushMyCouponView(callback) {
            if (window.WebViewJavascriptBridge) {
                WebViewJavascriptBridge.callHandler('pushMyCouponView', {}, callback);
            }
        },
        
        openOrderListView : function openOrderListView(type, callback) {
            if (window.WebViewJavascriptBridge) {
                WebViewJavascriptBridge.callHandler('openOrderListView', {'type': type}, callback);
            }
        },
        
        openCreditCardView : function openCreditCardView(callback) {
            if (window.WebViewJavascriptBridge) {
                WebViewJavascriptBridge.callHandler('openCreditCardView', {}, callback);
            }
        },
        
        openFindPayPasswordView : function openFindPayPasswordView(callback) {
            if (window.WebViewJavascriptBridge) {
                WebViewJavascriptBridge.callHandler('openFindPayPasswordView', {}, callback);
            }
        },
        
        openCreditPayView : function openCreditPayView(callback) {
            if (window.WebViewJavascriptBridge) {
                WebViewJavascriptBridge.callHandler('openCreditPayView', {}, callback);
            }
        },
        
        openRouter : function openRouter(url, callback) {
            if (window.WebViewJavascriptBridge) {
                WebViewJavascriptBridge.callHandler('openRouter', {'url':url}, callback);
            }
        },
        
        payWithTypeAndParam : function payWithTypeAndParam(type, param, callback) {
            if (window.WebViewJavascriptBridge) {
                WebViewJavascriptBridge.callHandler('payWithTypeAndParam', {'type':type, 'param':param}, callback);
            }
        },
        
        previewImages : function previewImages(param, callback) {
            if (window.WebViewJavascriptBridge) {
                WebViewJavascriptBridge.callHandler('previewImages', param, callback);
            }
        }
    }
    
    callback(HXSJSBridge);
}

setupWebViewJavascriptBridge(function(bridge) {
                             bridge.registerHandler('getShareInfo', function(data, responseCallback) {
                                                    responseCallback(window.shareInfo)
                                                    });
                             bridge.registerHandler('getJSBridge', function(data, responseCallback) {
                                                    
                                                    responseCallback(bridge)
                                                    
                                                    })
})
setUpHXSJSBridge(function(jsbridge){
                 jsbridge.setShareInfo = function setShareInfo(shareInfo) {
                    window.shareInfo = shareInfo;
                 }
                 })