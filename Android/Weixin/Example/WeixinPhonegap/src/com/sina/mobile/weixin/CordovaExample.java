package com.sina.mobile.weixin;

import org.apache.cordova.CordovaChromeClient;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.CordovaWebViewClient;
import org.apache.cordova.DroidGap;

import android.os.Bundle;
import android.webkit.WebView;

public class CordovaExample extends DroidGap {

	public interface OnPageFinishedListener {
		void onPageFinished(WebView view, String url);
	}

	private OnPageFinishedListener onPageFinishedListener;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		super.loadUrl("file:///android_asset/www/index.html");
	}

	public void init() {
		this.init(new CordovaWebView(this), new CordovaWebViewClient(this) {
			@Override
			public void onPageFinished(WebView view, String url) {
				super.onPageFinished(view, url);

				if (onPageFinishedListener != null) {
					onPageFinishedListener.onPageFinished(view, url);
				}
			}
		}, new CordovaChromeClient(this));
	}

	public void loadJs(String js) {
		this.appView.loadUrl(js);
	}

	public void setOnPageFinishedListener(
			OnPageFinishedListener onPageFinishedListener) {
		this.onPageFinishedListener = onPageFinishedListener;
	}
}
