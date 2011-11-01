package com.karq.gbackup;

import android.content.ContentResolver;
import android.database.Cursor;
import android.net.Uri;
import android.provider.ContactsContract;
import android.util.Log;
import com.phonegap.api.Plugin;
import com.phonegap.api.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by IntelliJ IDEA.
 * Author: kaarel Kargu(karq)
 * Date: 8/24/11
 * PhoneGAP sms inbox/sent reading plugin
 */

public class SMSReader extends Plugin {



    @Override
    public PluginResult execute(String action, JSONArray data, String callbackId) {
        Log.d("SMSReadPlugin", "Plugin Called");
        PluginResult result = null;
        JSONObject messages = new JSONObject();
        if (action.equals("inbox")) {
            try {
                messages = readSMS("inbox");
                Log.d("SMSReadPlugin", "Returning " + messages.toString());
                result = new PluginResult(PluginResult.Status.OK, messages);
            } catch (JSONException jsonEx) {
                Log.d("SMSReadPlugin", "Got JSON Exception "+ jsonEx.getMessage());
                result = new PluginResult(PluginResult.Status.JSON_EXCEPTION);
            }
        }
        else if(action.equals("sent")){
             try {
                messages = readSMS("sent");
                Log.d("SMSReadPlugin", "Returning " + messages.toString());
                result = new PluginResult(PluginResult.Status.OK, messages);
            } catch (JSONException jsonEx) {
                Log.d("SMSReadPlugin", "Got JSON Exception "+ jsonEx.getMessage());
                result = new PluginResult(PluginResult.Status.JSON_EXCEPTION);
            }
        }
        else {
            result = new PluginResult(PluginResult.Status.INVALID_ACTION);
            Log.d("SMSReadPlugin", "Invalid action : "+action+" passed");
        }
        return result;
    }


    //Read messages from inbox/or sent box.
    private JSONObject readSMS(String folder) throws JSONException {
        JSONObject data = new JSONObject();
        Uri uriSMSURI = Uri.parse("");
        if(folder.equals("inbox")){
            uriSMSURI = Uri.parse("content://sms/inbox");
        }
        else if(folder.equals("sent")){
                uriSMSURI = Uri.parse("content://sms/sent");
        }
        Cursor cur = getContentResolver().query(uriSMSURI, null, null, null,null);
        JSONArray smsList = new JSONArray();
        data.put("messages", smsList);
        while (cur.moveToNext()) {
          JSONObject sms = new JSONObject();
            sms.put("number",cur.getString(2));
            sms.put("text",cur.getString(11));

            String name = getContact(cur.getString(2));
            if(!name.equals("")){
                sms.put("name",name);
            }
            smsList.put(sms);
        }
        return data;
    }

    private String getContact(String number){
        Cursor cur = getContentResolver().query(ContactsContract.Contacts.CONTENT_URI,null,null,null,null);
        String returnName= "";
        if(cur.getCount() > 0){
            while(cur.moveToNext()){
                  String id =  cur.getString(cur.getColumnIndex(ContactsContract.Contacts._ID));
                  Log.d("Contact","ID:" + id );
                  String name =  cur.getString(cur.getColumnIndex(ContactsContract.Contacts.DISPLAY_NAME));
                   Log.d("Contact","name:" + name);
                  if (Integer.parseInt(cur.getString(cur.getColumnIndex(ContactsContract.Contacts.HAS_PHONE_NUMBER))) > 0) {
                      Cursor pcur = getContentResolver().query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI,null,
                              ContactsContract.CommonDataKinds.Phone.NUMBER + "=?",new String[]{number},null);
                      int numindex = pcur.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DATA);
                      if(pcur.moveToFirst()){
                          String dbNum = pcur.getString(numindex);
                          if(dbNum.equals(number)){
                           returnName = name;
                          Log.d("number","number:" + dbNum);
                          }
                          else {
                              Log.d("number","numbers dont match!");
                          }
                      }
                      else {
                          Log.d("number", "no result");
                      }

                  }
                    else {
                       Log.d("number", "No Number");
                  }
            }
        }
        return returnName;
    }

    private ContentResolver getContentResolver(){
       return this.ctx.getContentResolver();
    }



}
