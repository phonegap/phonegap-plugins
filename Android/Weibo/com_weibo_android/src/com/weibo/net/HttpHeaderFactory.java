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

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.Random;

import android.os.Bundle;

/**
 * Encapsulation a abstract weibo http headers base class.
 * 
 * @author ZhangJie (zhangjie2@staff.sina.com.cn)
 */

public abstract class HttpHeaderFactory {
    public static final String CONST_HMAC_SHA1 = "HmacSHA1";
    public static final String CONST_SIGNATURE_METHOD = "HMAC-SHA1";
    public static final String CONST_OAUTH_VERSION = "1.0";

    public HttpHeaderFactory() {
    }

    public String getWeiboAuthHeader(String method, String url, WeiboParameters params,
            String app_key, String app_secret, Token token) throws WeiboException {
        // step 1: generate timestamp and nonce
        final long timestamp = System.currentTimeMillis() / 1000;
        final long nonce = timestamp + (new Random()).nextInt();
        // step 2: authParams有两个用处：1.加密串一部分 2.生成最后Authorization头域
        WeiboParameters authParams = this.generateAuthParameters(nonce, timestamp, token);
        // 生成用于计算signature的，参数串
        WeiboParameters signatureParams = this.generateSignatureParameters(authParams, params, url);
        // step 3: 生成用于签名的base String
        String oauthBaseString = this.generateAuthSignature(method, signatureParams, url, token);
        // step 4: 生成oauth_signature
        String signature = generateSignature(oauthBaseString, token);
        authParams.add("oauth_signature", signature);
        // step 5: for additional parameters
        this.addAdditionalParams(authParams, params);
        return "OAuth " + encodeParameters(authParams, ",", true);
    }

    private String generateAuthSignature(final String method, WeiboParameters signatureParams,
            final String url, Token token) {
        StringBuffer base = new StringBuffer(method).append("&")
                .append(encode(constructRequestURL(url))).append("&");
        base.append(encode(encodeParameters(signatureParams, "&", false)));
        String oauthBaseString = base.toString();
        return oauthBaseString;
    }

    private WeiboParameters generateSignatureParameters(WeiboParameters authParams,
            WeiboParameters params, String url) throws WeiboException {
        WeiboParameters signatureParams = new WeiboParameters();
        signatureParams.addAll(authParams);
        signatureParams.add("source", Weibo.getAppKey());
        signatureParams.addAll(params);
        this.parseUrlParameters(url, signatureParams);
        WeiboParameters lsp = generateSignatureList(signatureParams);
        return lsp;
    }

    private WeiboParameters generateAuthParameters(long nonce, long timestamp, Token token) {
        WeiboParameters authParams = new WeiboParameters();
        authParams.add("oauth_consumer_key", Weibo.getAppKey());
        authParams.add("oauth_nonce", String.valueOf(nonce));
        authParams.add("oauth_signature_method", HttpHeaderFactory.CONST_SIGNATURE_METHOD);
        authParams.add("oauth_timestamp", String.valueOf(timestamp));
        authParams.add("oauth_version", HttpHeaderFactory.CONST_OAUTH_VERSION);
        if (token != null) {
            authParams.add("oauth_token", token.getToken());
        } else {
            authParams.add("source", Weibo.getAppKey());
        }
        return authParams;
    }

    // 生成用于哈希的base string串，注意要按顺序，按需文档需求参数生成，否则40107错误
    public abstract WeiboParameters generateSignatureList(WeiboParameters bundle);

    // add additional parameters to des key-value pairs,support to expanding
    // params
    public abstract void addAdditionalParams(WeiboParameters des, WeiboParameters src);

    // 解析url中参数对,存储到signatureBaseParams
    public void parseUrlParameters(String url, WeiboParameters signatureBaseParams)
            throws WeiboException {
        int queryStart = url.indexOf("?");
        if (-1 != queryStart) {
            String[] queryStrs = url.substring(queryStart + 1).split("&");
            try {
                for (String query : queryStrs) {
                    String[] split = query.split("=");
                    if (split.length == 2) {
                        signatureBaseParams.add(URLDecoder.decode(split[0], "UTF-8"),
                                URLDecoder.decode(split[1], "UTF-8"));
                    } else {
                        signatureBaseParams.add(URLDecoder.decode(split[0], "UTF-8"), "");
                    }
                }
            } catch (UnsupportedEncodingException e) {
                throw new WeiboException(e);
            }

        }

    }

    public abstract String generateSignature(String data, Token token) throws WeiboException;

    public static String encodeParameters(WeiboParameters postParams, String splitter, boolean quot) {
        StringBuffer buf = new StringBuffer();
        for (int i = 0; i < postParams.size(); i++) {
            if (buf.length() != 0) {
                if (quot) {
                    buf.append("\"");
                }
                buf.append(splitter);
            }
            buf.append(encode(postParams.getKey(i))).append("=");
            if (quot) {
                buf.append("\"");
            }
            buf.append(encode(postParams.getValue(i)));
        }
        if (buf.length() != 0) {
            if (quot) {
                buf.append("\"");
            }
        }
        return buf.toString();
    }

    public static String encodeParameters(Bundle postParams, String split, boolean quot) {
        final String splitter = split;
        StringBuffer buf = new StringBuffer();
        for (String key : postParams.keySet()) {
            if (buf.length() != 0) {
                if (quot) {
                    buf.append("\"");
                }
                buf.append(splitter);
            }
            buf.append(encode(key)).append("=");
            if (quot) {
                buf.append("\"");
            }
            buf.append(encode(postParams.getString(key)));
        }
        if (buf.length() != 0) {
            if (quot) {
                buf.append("\"");
            }
        }
        return buf.toString();
    }

    //
    public static String constructRequestURL(String url) {
        int index = url.indexOf("?");
        if (-1 != index) {
            url = url.substring(0, index);
        }
        int slashIndex = url.indexOf("/", 8);
        String baseURL = url.substring(0, slashIndex).toLowerCase();
        int colonIndex = baseURL.indexOf(":", 8);
        if (-1 != colonIndex) {
            // url contains port number
            if (baseURL.startsWith("http://") && baseURL.endsWith(":80")) {
                // http default port 80 MUST be excluded
                baseURL = baseURL.substring(0, colonIndex);
            } else if (baseURL.startsWith("https://") && baseURL.endsWith(":443")) {
                // http default port 443 MUST be excluded
                baseURL = baseURL.substring(0, colonIndex);
            }
        }
        url = baseURL + url.substring(slashIndex);

        return url;
    }

    /**
     * @param value
     *            string to be encoded
     * @return encoded parameters string
     */
    public static String encode(String value) {
        String encoded = null;
        try {
            encoded = URLEncoder.encode(value, "UTF-8");
        } catch (UnsupportedEncodingException ignore) {
        }
        StringBuffer buf = new StringBuffer(encoded.length());
        char focus;
        for (int i = 0; i < encoded.length(); i++) {
            focus = encoded.charAt(i);
            if (focus == '*') {
                buf.append("%2A");
            } else if (focus == '+') {
                buf.append("%20");
            } else if (focus == '%' && (i + 1) < encoded.length() && encoded.charAt(i + 1) == '7'
                    && encoded.charAt(i + 2) == 'E') {
                buf.append('~');
                i += 2;
            } else {
                buf.append(focus);
            }
        }
        return buf.toString();
    }

}
