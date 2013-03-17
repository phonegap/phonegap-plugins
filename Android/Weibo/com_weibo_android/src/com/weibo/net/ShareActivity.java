/*
 * Copyright 2011 Sina.
 *
 * Licensed under the Apache License and Weibo License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.open.weibo.com
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.weibo.net;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.weibo.android.R;
import com.weibo.net.AsyncWeiboRunner.RequestListener;

/**
 * A dialog activity for sharing any text or image message to weibo. Three
 * parameters , accessToken, tokenSecret, consumer_key, are needed, otherwise a
 * WeiboException will be throwed.
 * 
 * ShareActivity should implement an interface, RequestListener which will
 * return the request result.
 * 
 * @author ZhangJie (zhangjie2@staff.sina.com.cn)
 */

public class ShareActivity extends Activity implements OnClickListener, RequestListener {
    private TextView mTextNum;
    private Button mSend;
    private EditText mEdit;
    private FrameLayout mPiclayout;

    private String mPicPath = "";
    private String mContent = "";
    private String mAccessToken = "";
    private String mTokenSecret = "";

    public static final String EXTRA_WEIBO_CONTENT = "com.weibo.android.content";
    public static final String EXTRA_PIC_URI = "com.weibo.android.pic.uri";
    public static final String EXTRA_ACCESS_TOKEN = "com.weibo.android.accesstoken";
    public static final String EXTRA_TOKEN_SECRET = "com.weibo.android.token.secret";

    public static final int WEIBO_MAX_LENGTH = 140;

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setContentView(R.layout.share_mblog_view);

        Intent in = this.getIntent();
        mPicPath = in.getStringExtra(EXTRA_PIC_URI);
        mContent = in.getStringExtra(EXTRA_WEIBO_CONTENT);
        mAccessToken = in.getStringExtra(EXTRA_ACCESS_TOKEN);
        mTokenSecret = in.getStringExtra(EXTRA_TOKEN_SECRET);

        AccessToken accessToken = new AccessToken(mAccessToken, mTokenSecret);
        Weibo weibo = Weibo.getInstance();
        weibo.setAccessToken(accessToken);

        Button close = (Button) this.findViewById(R.id.btnClose);
        close.setOnClickListener(this);
        mSend = (Button) this.findViewById(R.id.btnSend);
        mSend.setOnClickListener(this);
        LinearLayout total = (LinearLayout) this.findViewById(R.id.ll_text_limit_unit);
        total.setOnClickListener(this);
        mTextNum = (TextView) this.findViewById(R.id.tv_text_limit);
        ImageView picture = (ImageView) this.findViewById(R.id.ivDelPic);
        picture.setOnClickListener(this);

        mEdit = (EditText) this.findViewById(R.id.etEdit);
        mEdit.addTextChangedListener(new TextWatcher() {
            public void afterTextChanged(Editable s) {
            }

            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            public void onTextChanged(CharSequence s, int start, int before, int count) {
                String mText = mEdit.getText().toString();
                String mStr;
                int len = mText.length();
                if (len <= WEIBO_MAX_LENGTH) {
                    len = WEIBO_MAX_LENGTH - len;
                    mTextNum.setTextColor(R.color.text_num_gray);
                    if (!mSend.isEnabled())
                        mSend.setEnabled(true);
                } else {
                    len = len - WEIBO_MAX_LENGTH;

                    mTextNum.setTextColor(Color.RED);
                    if (mSend.isEnabled())
                        mSend.setEnabled(false);
                }
                mTextNum.setText(String.valueOf(len));
            }
        });
        mEdit.setText(mContent);
        mPiclayout = (FrameLayout) ShareActivity.this.findViewById(R.id.flPic);
        if (TextUtils.isEmpty(this.mPicPath)) {
            mPiclayout.setVisibility(View.GONE);
        } else {
            mPiclayout.setVisibility(View.VISIBLE);
            File file = new File(mPicPath);
            if (file.exists()) {
                Bitmap pic = BitmapFactory.decodeFile(this.mPicPath);
                ImageView image = (ImageView) this.findViewById(R.id.ivImage);
                image.setImageBitmap(pic);
            } else {
                mPiclayout.setVisibility(View.GONE);
            }
        }
    }

    @Override
    public void onClick(View v) {
        int viewId = v.getId();

        if (viewId == R.id.btnClose) {
            finish();
        } else if (viewId == R.id.btnSend) {
            Weibo weibo = Weibo.getInstance();
            try {
                if (!TextUtils.isEmpty((String) (weibo.getAccessToken().getToken()))) {
                    this.mContent = mEdit.getText().toString();
                    if (!TextUtils.isEmpty(mPicPath)) {
                        upload(weibo, Weibo.getAppKey(), this.mPicPath, this.mContent, "", "");

                    } else {
                        // Just update a text weibo!
                        update(weibo, Weibo.getAppKey(), mContent, "", "");
                    }
                } else {
                    Toast.makeText(this, this.getString(R.string.please_login), Toast.LENGTH_LONG);
                }
            } catch (MalformedURLException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            } catch (WeiboException e) {
                e.printStackTrace();
            }
        } else if (viewId == R.id.ll_text_limit_unit) {
            Dialog dialog = new AlertDialog.Builder(this).setTitle(R.string.attention)
                    .setMessage(R.string.delete_all)
                    .setPositiveButton(R.string.ok, new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int which) {
                            mEdit.setText("");
                        }
                    }).setNegativeButton(R.string.cancel, null).create();
            dialog.show();
        } else if (viewId == R.id.ivDelPic) {
            Dialog dialog = new AlertDialog.Builder(this).setTitle(R.string.attention)
                    .setMessage(R.string.del_pic)
                    .setPositiveButton(R.string.ok, new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int which) {
                            mPiclayout.setVisibility(View.GONE);
                        }
                    }).setNegativeButton(R.string.cancel, null).create();
            dialog.show();
        }
    }

    private String upload(Weibo weibo, String source, String file, String status, String lon,
            String lat) throws WeiboException {
        WeiboParameters bundle = new WeiboParameters();
        bundle.add("source", source);
        bundle.add("pic", file);
        bundle.add("status", status);
        if (!TextUtils.isEmpty(lon)) {
            bundle.add("lon", lon);
        }
        if (!TextUtils.isEmpty(lat)) {
            bundle.add("lat", lat);
        }
        String rlt = "";
        String url = Weibo.SERVER + "statuses/upload.json";
        AsyncWeiboRunner weiboRunner = new AsyncWeiboRunner(weibo);
        weiboRunner.request(this, url, bundle, Utility.HTTPMETHOD_POST, this);

        return rlt;
    }

    private String update(Weibo weibo, String source, String status, String lon, String lat)
            throws MalformedURLException, IOException, WeiboException {
        WeiboParameters bundle = new WeiboParameters();
        bundle.add("source", source);
        bundle.add("status", status);
        if (!TextUtils.isEmpty(lon)) {
            bundle.add("lon", lon);
        }
        if (!TextUtils.isEmpty(lat)) {
            bundle.add("lat", lat);
        }
        String rlt = "";
        String url = Weibo.SERVER + "statuses/update.json";
        AsyncWeiboRunner weiboRunner = new AsyncWeiboRunner(weibo);
        weiboRunner.request(this, url, bundle, Utility.HTTPMETHOD_POST, this);
        return rlt;
    }

    @Override
    public void onComplete(String response) {
        runOnUiThread(new Runnable() {

            @Override
            public void run() {
                Toast.makeText(ShareActivity.this, R.string.send_sucess, Toast.LENGTH_LONG).show();
            }
        });

        this.finish();
    }

    @Override
    public void onIOException(IOException e) {
        // TODO Auto-generated method stub

    }

    @Override
    public void onError(final WeiboException e) {
        runOnUiThread(new Runnable() {

            @Override
            public void run() {
                Toast.makeText(
                        ShareActivity.this,
                        String.format(ShareActivity.this.getString(R.string.send_failed) + ":%s",
                                e.getMessage()), Toast.LENGTH_LONG).show();
            }
        });

    }

}
