/*
 * Copyright 2009 Facebook
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "FBDialog.h"

@interface FBStreamDialog : FBDialog {
	NSString* _attachment;
	NSString* _actionLinks;
	NSString* _targetId;
	NSString* _userMessagePrompt;
}

/**
 * A JSON-encoded object containing the text of the post, relevant links, a
 * media type (image, video, mp3, flash), as well as any other key/value pairs
 * you may want to add.
 *
 * Note: If you want to use this call to update a user's status, don't pass an
 * attachment; the content of the userMessage parameter will become the user's
 * new status and will appear at the top of the user's profile.
 *
 * For more info, see http://wiki.developers.facebook.com/index.php/Attachment_(Streams)
 */
@property(nonatomic,copy) NSString* attachment;

/**
 * A JSON-encoded array of action link objects, containing the link text and a
 * hyperlink.
 */
@property(nonatomic,copy) NSString* actionLinks;

/**
 * The ID of the user or the Page where you are publishing the content. If this
 * is specified, the post appears on the Wall of the target user, not on the
 * Wall of the user who published the post. This mimics the action of posting
 * on a friend's Wall on Facebook itself.
 *
 * Note: To post on the user's own wall, leave this blank.
 */
@property(nonatomic,copy) NSString* targetId;

/**
 * Text you provide the user as a prompt to specify a userMessage. This appears
 * above the box where the user enters a custom message.
 * For example, "What's on your mind?"
 */
@property(nonatomic,copy) NSString* userMessagePrompt;

@end
