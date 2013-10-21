package com.sina.mobile.weixin.wxapi;

import org.apache.cordova.DroidGap;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.sina.mobile.weixin.Constants;
import com.sina.mobile.weixin.CordovaExample;
import com.sina.mobile.weixin.R;
import com.tencent.mm.sdk.openapi.BaseReq;
import com.tencent.mm.sdk.openapi.BaseResp;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.sdk.openapi.ShowMessageFromWX;
import com.tencent.mm.sdk.openapi.WXAPIFactory;
import com.tencent.mm.sdk.openapi.WXAppExtendObject;
import com.tencent.mm.sdk.openapi.WXMediaMessage;

public class WXEntryActivity extends DroidGap implements IWXAPIEventHandler {

	private static final String TAG = WXEntryActivity.class.getSimpleName();

	private IWXAPI api;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		Log.d(TAG, "onCreate");

		api = WXAPIFactory.createWXAPI(this, Constants.APP_ID, false);
		api.handleIntent(getIntent(), this);
	}

	@Override
	protected void onNewIntent(Intent intent) {
		super.onNewIntent(intent);

		setIntent(intent);
		api.handleIntent(intent, this);
	}

	@Override
	public void onReq(BaseReq req) {
		Log.d(TAG, "onReq");

		// 和ios返回type兼容
		int type = 4;
		if (req.getType() == 3) {
			type = 4;
		} else if (req.getType() == 4) {
			type = 0;
		}

		Intent intent = new Intent(this, CordovaExample.class);
		intent.putExtra("type", "onReq");
		intent.putExtra("reqType", type);
		intent.putExtra("transaction", req.transaction);
		if (type == 0) {
			ShowMessageFromWX.Req showReq = (ShowMessageFromWX.Req) req;
			WXMediaMessage wxMsg = showReq.message;
			WXAppExtendObject obj = (WXAppExtendObject) wxMsg.mediaObject;

			intent.putExtra("extInfo", obj.extInfo);
			intent.putExtra("fileData", obj.fileData);
			intent.putExtra("filePath", obj.filePath);

			intent.putExtra("thumbData", wxMsg.thumbData);
		}
		startActivity(intent);
		finish();
	}

	@Override
	public void onResp(BaseResp resp) {
		Log.d(TAG, "onResp");
		int result = 0;

		switch (resp.errCode) {
		case BaseResp.ErrCode.ERR_OK:
			result = R.string.errcode_success;
			break;
		case BaseResp.ErrCode.ERR_USER_CANCEL:
			result = R.string.errcode_cancel;
			break;
		case BaseResp.ErrCode.ERR_AUTH_DENIED:
			result = R.string.errcode_deny;
			break;
		default:
			result = R.string.errcode_unknown;
			break;
		}

		Intent intent = new Intent(this, CordovaExample.class);
		intent.putExtra("type", "onResp");
		intent.putExtra("errCode", resp.errCode);
		intent.putExtra("result", result);
		startActivity(intent);
		finish();
	}
}
