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

import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import android.text.TextUtils;

/**
 * Encapsulation Weibo http headers for authorizing by xauth. the order of
 * weiboParameters will not be changed. Otherwise the signature should be
 * calculated wrong.
 * 
 * @author ZhangJie (zhangjie2@staff.sina.com.cn)
 */
public class XAuthHeader extends HttpHeaderFactory {

    @Override
    public WeiboParameters generateSignatureList(WeiboParameters bundle) {
        if (bundle == null || (bundle.size() == 0)) {
            return null;
        }
        WeiboParameters pp = new WeiboParameters();
        String key = "oauth_consumer_key";
        pp.add(key, bundle.getValue(key));
        key = "oauth_nonce";
        pp.add(key, bundle.getValue(key));
        key = "oauth_signature_method";
        pp.add(key, bundle.getValue(key));
        key = "oauth_timestamp";
        pp.add(key, bundle.getValue(key));
        key = "oauth_version";
        pp.add(key, bundle.getValue(key));
        key = "source";
        pp.add(key, Weibo.getAppKey());
        key = "x_auth_mode";
        pp.add(key, "client_auth");
        key = "x_auth_password";
        pp.add(key, bundle.getValue(key));
        key = "x_auth_username";
        pp.add(key, bundle.getValue(key));
        return pp;
    }

    // 生成oauth_signature
    public String generateSignature(String data, Token token) throws WeiboException {
        byte[] byteHMAC = null;
        try {
            Mac mac = Mac.getInstance(HttpHeaderFactory.CONST_HMAC_SHA1);
            SecretKeySpec spec = null;
            String oauthSignature = encode(Weibo.getAppSecret()) + "&";
            spec = new SecretKeySpec(oauthSignature.getBytes(), HttpHeaderFactory.CONST_HMAC_SHA1);
            mac.init(spec);
            byteHMAC = mac.doFinal(data.getBytes());
        } catch (InvalidKeyException e) {
            throw new WeiboException(e);
        } catch (NoSuchAlgorithmException e) {
            throw new WeiboException(e);
        }
        return String.valueOf(Utility.base64Encode(byteHMAC));
    }

    @Override
    public void addAdditionalParams(WeiboParameters des, WeiboParameters src) {
        if (!TextUtils.isEmpty(src.getValue("x_auth_password"))
                && !TextUtils.isEmpty(src.getValue("x_auth_username"))) {
            des.add("x_auth_password", src.getValue("x_auth_password"));
            des.add("x_auth_username", src.getValue("x_auth_username"));
            des.add("x_auth_mode", "client_auth");
        }

    }

}
