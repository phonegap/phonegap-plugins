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


/**
 * Encapsulation a Weibo error, when weibo request can not be implemented successful.
 *
 * @author  ZhangJie (zhangjie2@staff.sina.com.cn)
 */
public class WeiboException extends Exception {

	private static final long serialVersionUID = 475022994858770424L;
	
	
	/*304 Not Modified: 没有数据返回.
	400 Bad Request: 请求数据不合法，或者超过请求频率限制. 详细的错误代码如下：
	40028:内部接口错误(如果有详细的错误信息，会给出更为详细的错误提示)
	40033:source_user或者target_user用户不存在
	40031:调用的微博不存在
	40036:调用的微博不是当前用户发布的微博
	40034:不能转发自己的微博
	40038:不合法的微博
	40037:不合法的评论
	40015:该条评论不是当前登录用户发布的评论
	40017:不能给不是你粉丝的人发私信
	40019:不合法的私信
	40021:不是属于你的私信
	40022:source参数(appkey)缺失
	40007:格式不支持，仅仅支持XML或JSON格式
	40009:图片错误，请确保使用multipart上传了图片
	40011:私信发布超过上限
	40012:内容为空
	40016:微博id为空
	40018:ids参数为空
	40020:评论ID为空
	40023:用户不存在
	40024:ids过多，请参考API文档
	40025:不能发布相同的微博
	40026:请传递正确的目标用户uid或者screen name
	40045:不支持的图片类型,支持的图片类型有JPG,GIF,PNG
	40008:图片大小错误，上传的图片大小上限为5M
	40001:参数错误，请参考API文档
	40002:不是对象所属者，没有操作权限
	40010:私信不存在
	40013:微博太长，请确认不超过140个字符
	40039:地理信息输入错误
	40040:IP限制，不能请求该资源
	40041:uid参数为空
	40042:token参数为空
	40043:domain参数错误
	40044:appkey参数缺失
	40029:verifier错误
	40027:标签参数为空
	40032:列表名太长，请确保输入的文本不超过10个字符
	40030:列表描述太长，请确保输入的文本不超过70个字符
	40035:列表不存在
	40053:权限不足，只有创建者有相关权限
	40054:参数错误，请参考API文档
	40059: 插入失败，记录已存在
	40060：数据库错误，请联系系统管理员
	40061：列表名冲突
	40062：id列表太长了
	40063：urls是空的
	40064：urls太多了
	40065：ip是空值
	40066：url是空值
	40067：trend_name是空值
	40068：trend_id是空值
	40069：userid是空值
	40070：第三方应用访问api接口权限受限制
	40071：关系错误，user_id必须是你关注的用户
	40072：授权关系已经被删除
	40073：目前不支持私有分组
	40074：创建list失败
	40075：需要系统管理员的权限
	40076：含有非法词
	40084：提醒失败，需要权限
	40082：无效分类!
	40083：无效状态码
	40084：目前只支持私有分组
	401 Not Authorized: 没有进行身份验证.
	40101 version_rejected Oauth版本号错误
	40102 parameter_absent Oauth缺少必要的参数
	40103 parameter_rejected Oauth参数被拒绝
	40104 timestamp_refused Oauth时间戳不正确
	40105 nonce_used Oauth nonce参数已经被使用
	40106 signature_method_rejected Oauth签名算法不支持
	40107 signature_invalid Oauth签名值不合法
	40108 consumer_key_unknown! Oauth consumer_key不存在
	40109 consumer_key_refused! Oauth consumer_key不合法
	40110 token_used! Oauth Token已经被使用
	40111 Oauth Error: token_expired! Oauth Token已经过期
	40112 token_revoked! Oauth Token不合法
	40113 token_rejected! Oauth Token不合法
	40114 verifier_fail! Oauth Pin码认证失败
	402 Not Start mblog: 没有开通微博
	403 Forbidden: 没有权限访问对应的资源.
	40301 too many lists, see doc for more info 已拥有列表上限
	40302 auth faild 认证失败
	40303 already followed 已经关注此用户
	40304 Social graph updates out of rate limit 发布微博超过上限
	40305 update comment out of rate 发布评论超过上限
	40306 Username and pwd auth out of rate limit 用户名密码认证超过请求限制
	40307 HTTP METHOD is not suported for this request 请求的HTTP METHOD不支持
	40308 Update weibo out of rate limit 发布微博超过上限
	40309 password error 密码不正确
	40314 permission denied! Need a high level appkey 该资源需要appkey拥有更高级的授权
	404 Not Found: 请求的资源不存在.
	500 Internal Server Error: 服务器内部错误.
	502 Bad Gateway: 微博接口API关闭或正在升级 .
	503 Service Unavailable: 服务端资源不可用.*/
	private int statusCode = -1;
	
	
	
    public WeiboException(String msg) {
        super(msg);
    }

    public WeiboException(Exception cause) {
        super(cause);
    }

    public WeiboException(String msg, int statusCode) {
        super(msg);
        this.statusCode = statusCode;
    }

    public WeiboException(String msg, Exception cause) {
        super(msg, cause);
    }

    public WeiboException(String msg, Exception cause, int statusCode) {
        super(msg, cause);
        this.statusCode = statusCode;
    }

    public int getStatusCode() {
        return this.statusCode;
    }
    
    
	public WeiboException() {
		super(); 
	}

	public WeiboException(String detailMessage, Throwable throwable) {
		super(detailMessage, throwable);
	}

	public WeiboException(Throwable throwable) {
		super(throwable);
	}

	public WeiboException(int statusCode) {
		super();
		this.statusCode = statusCode;
	}

	public void setStatusCode(int statusCode) {
		this.statusCode = statusCode;
	}
	
}
