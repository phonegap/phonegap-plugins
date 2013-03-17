//
//  WBSDKGlobal.h
//  SinaWeiBoSDK
//  Based on OAuth 2.0
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  Copyright 2011 Sina. All rights reserved.
//


#define kWBSDKErrorDomain           @"WeiBoSDKErrorDomain"
#define kWBSDKErrorCodeKey          @"WeiBoSDKErrorCodeKey"

#define kWBSDKAPIDomain             @"https://api.weibo.com/2/"

typedef enum
{
	kWBErrorCodeInterface	= 100,
	kWBErrorCodeSDK         = 101,
}WBErrorCode;

typedef enum
{
	kWBSDKErrorCodeParseError       = 200,
	kWBSDKErrorCodeRequestError     = 201,
	kWBSDKErrorCodeAccessError      = 202,
	kWBSDKErrorCodeAuthorizeError	= 203,
}WBSDKErrorCode;