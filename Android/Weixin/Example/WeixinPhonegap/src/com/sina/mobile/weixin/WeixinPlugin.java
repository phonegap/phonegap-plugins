package com.sina.mobile.weixin;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;

import org.apache.cordova.DroidGap;
import org.apache.cordova.api.CordovaInterface;
import org.apache.cordova.api.Plugin;
import org.apache.cordova.api.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.webkit.WebView;

import com.sina.mobile.weixin.CordovaExample.OnPageFinishedListener;
import com.tencent.mm.sdk.openapi.BaseResp;
import com.tencent.mm.sdk.openapi.GetMessageFromWX;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.SendMessageToWX;
import com.tencent.mm.sdk.openapi.WXAPIFactory;
import com.tencent.mm.sdk.openapi.WXAppExtendObject;
import com.tencent.mm.sdk.openapi.WXImageObject;
import com.tencent.mm.sdk.openapi.WXMediaMessage;
import com.tencent.mm.sdk.openapi.WXMusicObject;
import com.tencent.mm.sdk.openapi.WXTextObject;
import com.tencent.mm.sdk.openapi.WXVideoObject;
import com.tencent.mm.sdk.openapi.WXWebpageObject;

public class WeixinPlugin extends Plugin {

	private static final String TAG = WeixinPlugin.class.getSimpleName();
	private static final int THUMB_SIZE = 150;

	private IWXAPI api;
	private Bundle bundle;
	private String responser = "receiveResponse";
	private String callbackId;

	@Override
	public void onNewIntent(Intent intent) {
		super.onNewIntent(intent);

		DroidGap gap = ((DroidGap) (this.cordova));

		gap.setIntent(intent);
	}

	@Override
	public void setContext(CordovaInterface ctx) {
		super.setContext(ctx);

		DroidGap gap = ((DroidGap) (this.cordova.getActivity()));
		((CordovaExample) gap)
				.setOnPageFinishedListener(new OnPageFinishedListener() {
					@Override
					public void onPageFinished(WebView view, String url) {
						handleReq();
					}
				});
	}

	@Override
	public void onResume(boolean multitasking) {
		super.onResume(multitasking);

		Log.d(TAG, "onResume");

		handleReq();
	}

	private void handleReq() {
		final DroidGap gap = ((DroidGap) (this.cordova.getActivity()));
		try {
			Intent i = gap.getIntent();
			Log.d(TAG, "intent: " + i);
		} catch (Exception e) {
			Log.d(TAG, "e: ", e);
		}

		if (gap.getIntent() != null) {
			Bundle bundle = gap.getIntent().getExtras();
			if (bundle == null) {
				return;
			}

			Log.d(TAG, "bundle: " + bundle);

			String type = bundle.getString("type");
			if (type == null) {
				return;
			}
			Log.d(TAG, "type: " + type);
			if (type.equals("onReq")) {
				int reqType = bundle.getInt("reqType");
				JSONObject json = new JSONObject();
				try {
					json.put("type", reqType);
					if (reqType == 0) {
						String extInfo = bundle.getString("extInfo");
						byte[] fileData = bundle.getByteArray("fileData");
						String filePath = bundle.getString("filePath");
						json.put("extInfo", extInfo);
						if (fileData != null) {
							json.put("fileData", new String(fileData));
						} else {
							if (filePath != null) {
								json.put("filePath", filePath);
								Log.d(TAG, "filePath: " + filePath);
								json.put(
										"fileData",
										new String(Util.readFromFile(filePath,
												0, -1)));
							}
						}
						byte[] thumbData = bundle.getByteArray("thumbData");
						if (thumbData != null) {
							BASE64Encoder encoder = new BASE64Encoder();
							json.put("thumbData", encoder.encode(thumbData));
						}
					}
				} catch (JSONException e) {
					e.printStackTrace();
				}

				((CordovaExample) gap).loadJs(String.format(
						"javascript:%s(%s);", responser, json.toString()));
			} else {
				int errCode = bundle.getInt("errCode", BaseResp.ErrCode.ERR_OK);
				int result = bundle.getInt("result", R.string.errcode_success);

				if (errCode == BaseResp.ErrCode.ERR_OK) {
					WeixinPlugin.this.success("success", callbackId);
				} else {
					JSONObject json = new JSONObject();
					try {
						json.put("errCode", errCode);
						json.put("errStr", result);
					} catch (JSONException e) {
						e.printStackTrace();
					}
					WeixinPlugin.this.error(json, callbackId);
				}
			}
		}
	}

	private void handleTextContent(String action, final JSONArray args,
			final String callbackId) {
		try {
			String type = args.getString(0);
			String text = args.getString(1);
			api = WXAPIFactory.createWXAPI(
					(Context) this.cordova.getActivity(), Constants.APP_ID);

			// 初始化一个WXTextObject对象
			WXTextObject textObj = new WXTextObject();
			textObj.text = text;

			// 用WXTextObject对象初始化一个WXMediaMessage对象
			WXMediaMessage msg = new WXMediaMessage();
			msg.mediaObject = textObj;
			// 发送文本类型的消息时，title字段不起作用
			// msg.title = "Will be ignored";
			msg.description = text;

			Log.d(TAG, "type: " + type + ", message: " + text);

			handleSend(msg, type, "text");

		} catch (JSONException e) {
			e.printStackTrace();
			WeixinPlugin.this.error("没有足够的文本信息", callbackId);
		}
	}

	private void handleMessageTitleAndDescription(WXMediaMessage msg,
			JSONObject options) {
		String title = options.optString("title");
		if (!TextUtils.isEmpty(title)) {
			msg.title = title;
		}
		String description = options.optString("description");
		if (!TextUtils.isEmpty(description)) {
			msg.description = description;
		}
	}

	private void handleMessageThumbUrl(WXMediaMessage msg, JSONObject options) {
		String thumbUrl = options.optString("thumbUrl");
		if (!TextUtils.isEmpty(thumbUrl)) {
			if (thumbUrl.startsWith("http")) {
				try {
					Bitmap bmp = BitmapFactory.decodeStream(new URL(thumbUrl)
							.openStream());

					Bitmap thumbBmp = Bitmap.createScaledBitmap(bmp,
							THUMB_SIZE, THUMB_SIZE, true);
					bmp.recycle();
					msg.thumbData = Util.bmpToByteArray(thumbBmp, true);
				} catch (MalformedURLException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
			} else if (thumbUrl.startsWith("content")) {
				Uri imgUri = Uri.parse(thumbUrl);
				ContentResolver cr = this.cordova.getActivity()
						.getContentResolver();
				try {
					Bitmap bmp = BitmapFactory.decodeFileDescriptor(cr
							.openAssetFileDescriptor(imgUri, "r")
							.getFileDescriptor());
					msg.thumbData = Util.inputStreamToByte(cr
							.openInputStream(imgUri));
				} catch (FileNotFoundException e) {
					e.printStackTrace();
				}
			} else {
				Bitmap bmp = BitmapFactory.decodeFile(thumbUrl);
				Bitmap thumbBmp = Bitmap.createScaledBitmap(bmp, THUMB_SIZE,
						THUMB_SIZE, true);
				bmp.recycle();
				msg.thumbData = Util.bmpToByteArray(thumbBmp, true);
			}
		}
	}

	private void handleSend(WXMediaMessage msg, String type, String contentType) {
		if (type.equals("send")) {
			SendMessageToWX.Req req = new SendMessageToWX.Req();
			req.transaction = buildTransaction(contentType);
			req.message = msg;

			api.sendReq(req);
		} else if (type.equals("get")) {
			GetMessageFromWX.Resp resp = new GetMessageFromWX.Resp();
			resp.transaction = getTransaction();
			resp.message = msg;

			api.sendResp(resp);

			DroidGap gap = ((DroidGap) (this.cordova.getActivity()));
			gap.moveTaskToBack(true);
		}
	}

	private void handleImageContent(String action, final JSONArray args,
			final String callbackId) {
		try {
			WXMediaMessage msg = new WXMediaMessage();

			String type = args.getString(0);
			String imageUrl = args.getString(1);
			JSONObject options = args.optJSONObject(2);
			if (options != null) {
				handleMessageTitleAndDescription(msg, options);
			}

			WXImageObject imgObj = new WXImageObject();
			Bitmap bmp = null;
			if (imageUrl.startsWith("http")) {
				imgObj.imageUrl = imageUrl;
				try {
					bmp = BitmapFactory.decodeStream(new URL(imageUrl)
							.openStream());
				} catch (MalformedURLException e) {
				} catch (IOException e) {
				}
			} else if (imageUrl.startsWith("content")) {
				Uri imgUri = Uri.parse(imageUrl);
				ContentResolver cr = this.cordova.getActivity()
						.getContentResolver();
				imgObj.imageData = Util.inputStreamToByte(cr
						.openInputStream(imgUri));

				// bmp = BitmapFactory.decodeFileDescriptor(cr
				// .openAssetFileDescriptor(imgUri, "r")
				// .getFileDescriptor());
				bmp = BitmapFactory.decodeStream(cr.openInputStream(imgUri));
			} else {
				String path = imageUrl;
				File file = new File(path);
				if (!file.exists()) {
					WeixinPlugin.this.error("file not exists", callbackId);
				}
				imgObj.setImagePath(path);

				bmp = BitmapFactory.decodeFile(path);
			}
			Bitmap thumbBmp = Bitmap.createScaledBitmap(bmp, THUMB_SIZE,
					THUMB_SIZE, true);
			bmp.recycle();
			msg.thumbData = Util.bmpToByteArray(thumbBmp, true);

			msg.mediaObject = imgObj;

			handleSend(msg, type, "img");

		} catch (JSONException e) {
			e.printStackTrace();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
	}

	private void handleMessageThumbData(WXMediaMessage msg, JSONObject options) {
		String thumbData = options.optString("thumbData");
		if (!TextUtils.isEmpty(thumbData)) {
			msg.thumbData = BASE64Encoder.decode(thumbData);
		}
	}

	private void handleMusicContent(String action, final JSONArray args,
			final String callbackId) {
		WXMediaMessage msg = new WXMediaMessage();
		WXMusicObject music = new WXMusicObject();

		try {
			String type = args.getString(0);
			String musicUrl = args.getString(1);
			JSONObject options = args.optJSONObject(2);
			if (options != null) {
				handleMessageTitleAndDescription(msg, options);

				String lowBandUrl = options.optString("lowBandUrl");
				if (!TextUtils.isEmpty(lowBandUrl)) {
					music.musicLowBandUrl = lowBandUrl;
				}

				handleMessageThumbUrl(msg, options);

				handleMessageThumbData(msg, options);
			}

			music.musicUrl = musicUrl;

			msg.mediaObject = music;

			handleSend(msg, type, "music");

		} catch (JSONException e) {
			e.printStackTrace();
		}
	}

	private void handleVideoContent(String action, final JSONArray args,
			final String callbackId) {
		WXMediaMessage msg = new WXMediaMessage();
		WXVideoObject video = new WXVideoObject();

		try {
			String type = args.getString(0);
			String videoUrl = args.getString(1);
			JSONObject options = args.optJSONObject(2);
			if (options != null) {
				handleMessageTitleAndDescription(msg, options);

				String lowBandUrl = options.optString("lowBandUrl");
				if (!TextUtils.isEmpty(lowBandUrl)) {
					video.videoLowBandUrl = lowBandUrl;
				}

				handleMessageThumbUrl(msg, options);

				handleMessageThumbData(msg, options);
			}

			video.videoUrl = videoUrl;

			msg.mediaObject = video;

			handleSend(msg, type, "video");

		} catch (JSONException e) {
			e.printStackTrace();
		}
	}

	private void handleWebpageContent(String action, final JSONArray args,
			final String callbackId) {
		WXMediaMessage msg = new WXMediaMessage();
		WXWebpageObject webpage = new WXWebpageObject();

		try {
			String type = args.getString(0);
			String webpageUrl = args.getString(1);
			JSONObject options = args.optJSONObject(2);
			if (options != null) {
				handleMessageTitleAndDescription(msg, options);

				handleMessageThumbUrl(msg, options);

				handleMessageThumbData(msg, options);
			}

			webpage.webpageUrl = webpageUrl;

			msg.mediaObject = webpage;

			handleSend(msg, type, "webpage");

		} catch (JSONException e) {
			e.printStackTrace();
		}
	}

	private void handleAppContent(String action, final JSONArray args,
			final String callbackId) {
		WXMediaMessage msg = new WXMediaMessage();
		WXAppExtendObject appdata = new WXAppExtendObject();

		try {
			String type = args.getString(0);
			JSONObject options = args.optJSONObject(1);
			if (options != null) {
				handleMessageTitleAndDescription(msg, options);

				handleMessageThumbUrl(msg, options);

				handleMessageThumbData(msg, options);

				String filePath = options.optString("filePath");
				if (!TextUtils.isEmpty(filePath)) {
					appdata.filePath = filePath;
				}
				String fileData = options.optString("fileData");
				if (!TextUtils.isEmpty(fileData)) {
					appdata.fileData = fileData.getBytes();
				}
				String extInfo = options.optString("extInfo");
				if (!TextUtils.isEmpty(extInfo)) {
					appdata.extInfo = extInfo;
				}
			}

			msg.mediaObject = appdata;

			handleSend(msg, type, "appdata");

		} catch (JSONException e) {
		}
	}

	@Override
	public PluginResult execute(String action, final JSONArray args,
			final String callbackId) {
		final PluginResult pr = new PluginResult(PluginResult.Status.NO_RESULT);
		pr.setKeepCallback(true);
		this.callbackId = callbackId;

		bundle = ((DroidGap) (this.cordova.getActivity())).getIntent()
				.getExtras();

		if (action.equals("registerApp")) {
			String appId = args.optString(0);
			if (TextUtils.isEmpty(appId)) {
				WeixinPlugin.this.error("没得到有效的appId", callbackId);
				return pr;
			}

			api = WXAPIFactory.createWXAPI(
					(Context) this.cordova.getActivity(), null);
			if (api.registerApp(appId)) {
				WeixinPlugin.this.success("注册成功", callbackId);
				return pr;
			} else {
				WeixinPlugin.this.error("注册失败", callbackId);
				return pr;
			}

		} else if (action.equals("setResponser")) {

			responser = args.optString(0);

		} else if (action.equals("textContent")) {

			handleTextContent(action, args, callbackId);

		} else if (action.equals("imageContent")) {

			handleImageContent(action, args, callbackId);

		} else if (action.equals("musicContent")) {

			handleMusicContent(action, args, callbackId);

		} else if (action.equals("videoContent")) {

			handleVideoContent(action, args, callbackId);

		} else if (action.equals("webpageContent")) {

			handleWebpageContent(action, args, callbackId);

		} else if (action.equals("APPContent")) {

			handleAppContent(action, args, callbackId);

		} else if (action.equals("getWXAppInstallUrl")) {

			// Android没有这个方法，为了兼容iOS保留该方法。

		} else if (action.equals("openWXApp")) {

			boolean success = api.openWXApp();
			Log.d(TAG, "openWXApp: " + success);
			success = true;
			if (success) {
				WeixinPlugin.this.success("", callbackId);
			} else {
				WeixinPlugin.this.error("", callbackId);
			}

		} else if (action.equals("isWeixinInstalled")) {

			boolean success = api.isWXAppInstalled();
			if (success) {
				WeixinPlugin.this.success("", callbackId);
			} else {
				WeixinPlugin.this.error("", callbackId);
			}

		} else if (action.equals("isSupportApi")) {

			boolean success = api.isWXAppSupportAPI();
			if (success) {
				WeixinPlugin.this.success("", callbackId);
			} else {
				WeixinPlugin.this.error("", callbackId);
			}

		} else {

			return new PluginResult(PluginResult.Status.INVALID_ACTION);

		}

		return pr;
	}

	private String buildTransaction(final String type) {
		return (type == null) ? String.valueOf(System.currentTimeMillis())
				: type + System.currentTimeMillis();
	}

	private String getTransaction() {
		String transaction = bundle.getString("transaction");
		Log.d(TAG, "transaction: " + transaction);
		return transaction;
	}
}
