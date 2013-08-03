/*
 *   Licensed to the Apache Software Foundation (ASF) under one
 *   or more contributor license agreements.  See the NOTICE file
 *   distributed with this work for additional information
 *   regarding copyright ownership.  The ASF licenses this file
 *   to you under the Apache License, Version 2.0 (the
 *   "License"); you may not use this file except in compliance
 *   with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing,
 *   software distributed under the License is distributed on an
 *   "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *   KIND, either express or implied.  See the License for the
 *   specific language governing permissions and limitations
 *   under the License.
 *
 *      CDVSMSComposer
 *      CDVSMSComposer Template Created 8/2/13.
 *      Copyright 2013 @RandyMcMillan
 *
 *     Created by Randy McMillan on 8/2/13.
 *     Copyright __MyCompanyName__ 2013. All rights reserved.
 */

(function() {
 
 var cordovaRef = window.PhoneGap || window.Cordova || window.cordova; // old to new fallbacks
 
 function CDVSMSComposer(){
 
 this.resultCallback = null;
 
 }
 
 CDVSMSComposer.ComposeResultType = {
 
 Cancelled:0,
 Sent:1,
 Failed:2,
 NotSent:3
 
 }
 
 
 CDVSMSComposer.prototype.showSMSComposer = function(toRecipients, body) {
 
 var args = {};
 
 if(toRecipients)
 
 args.toRecipients = toRecipients;
 
 if(body)
 
 args.body = body;
 
 cordovaRef.exec("CDVSMSComposer.showSMSComposer",args);
 
 }
 
 CDVSMSComposer.prototype.showSMSComposerWithCB = function(cbFunction,toRecipients,body) {
 
 this.resultCallback = cbFunction;
 this.showSMSComposer.apply(this,[toRecipients,body]);
 
 }
 
 CDVSMSComposer.prototype._didFinishWithResult = function(res) {
 
 this.resultCallback(res);
 
 }
 
 CDVSMSComposer.install = function() {
 
 if ( !window.plugins ) {
 
 window.plugins = {};
 
 }
 
 if ( !window.plugins.CDVSMSComposer ) {
 
 window.plugins.CDVSMSComposer = new CDVSMSComposer();
 
 }
 
 }
 
 if (cordovaRef && cordovaRef.addConstructor) {
 
 cordovaRef.addConstructor(CDVSMSComposer.install);
 
 } else {
 
 console.log("CDVSMSComposer Cordova Plugin could not be installed.");
 
 return null;
 
 }
 
 
 })();