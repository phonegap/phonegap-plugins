/*
 	Author: Vishal Rajpal
 	Filename: ExtractZipFilePlugin.java
 	Date: 21-02-2012
*/

package com.phonegap.plugin.ExtractZipFile;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Enumeration;
import java.util.zip.ZipEntry;
import java.util.zip.ZipException;
import java.util.zip.ZipFile;

import org.json.JSONArray;
import org.json.JSONException;

import com.phonegap.api.Plugin;
import com.phonegap.api.PluginResult;

public class ExtractZipFilePlugin extends Plugin {

	@Override
	public PluginResult execute(String arg0, JSONArray args, String arg2) {
		PluginResult.Status status = PluginResult.Status.OK;
        JSONArray result = new JSONArray();
        try {
			String filename = args.getString(0);
			File file = new File(filename);
			String[] dirToSplit=filename.split("/");
			String dirToInsert="";
			for(int i=0;i<dirToSplit.length-1;i++)
			{
				dirToInsert+=dirToSplit[i]+"/";
			}
			BufferedOutputStream dest = null;
			BufferedInputStream is = null;
			ZipEntry entry;
			ZipFile zipfile;
			try {
				zipfile = new ZipFile(file);
				Enumeration e = zipfile.entries();
				while (e.hasMoreElements()) 
				  {
					  entry = (ZipEntry) e.nextElement();
					  is = new BufferedInputStream(zipfile.getInputStream(entry));
					  int count;
					  byte data[] = new byte[102222];
					  String fileName = dirToInsert + entry.getName();
					  File outFile = new File(fileName);
					  if (entry.isDirectory()) 
					  {
						  outFile.mkdirs();
					  } 
					  else 
					  {
						  FileOutputStream fos = new FileOutputStream(outFile);
						  dest = new BufferedOutputStream(fos, 102222);
						  while ((count = is.read(data, 0, 102222)) != -1)
						  {
							  dest.write(data, 0, count);
						  }
						  dest.flush();
						  dest.close();
						  is.close();
					  }
				  }
			} catch (ZipException e1) {
				// TODO Auto-generated catch block
				return new PluginResult(PluginResult.Status.MALFORMED_URL_EXCEPTION);
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				return new PluginResult(PluginResult.Status.IO_EXCEPTION);
			}
			
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			return new PluginResult(PluginResult.Status.JSON_EXCEPTION);
		}
        return new PluginResult(status);
	}
}
