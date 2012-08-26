package com.ocrapiservice;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.impl.client.DefaultHttpClient;

public class OcrService {
	public final String SERVICE_URL = "http://api.ocrapiservice.com/1.0/rest/ocr";
	
	private final String PARAM_IMAGE = "image";
	private final String PARAM_LANGUAGE = "language";
	private final String PARAM_APIKEY = "apikey";
	
	private String apiKey;
	
	private int responseCode;
	private String responseText;
	
	public OcrService(final String apiKey) {
		this.apiKey = apiKey;
	}
	
	/*
	 * Convert image to text.
	 * 
	 * @param language The image text language.
	 * @param filePath The image absolute file path.
	 * 
	 * @return true if everything went okay and false if there is an error with sending and receiving data.
	 */
	public boolean convertToText(final String language, final String filePath) {
		try {
			sendImage(language, filePath);
			
			return true;
		} catch (ClientProtocolException e) {
			e.printStackTrace();
			
			return false;
		} catch (IOException e) {
			e.printStackTrace();
			
			return false;
		}
	}
	
	/*
	 * Send image to OCR service and read response.
	 * 
	 * @param language The image text language.
	 * @param filePath The image absolute file path.
	 *  
	 */
	private void sendImage(final String language, final String filePath) throws ClientProtocolException, IOException {
		final HttpClient httpclient = new DefaultHttpClient();
		final HttpPost httppost = new HttpPost(SERVICE_URL);

		final FileBody image = new FileBody(new File(filePath));

		final MultipartEntity reqEntity = new MultipartEntity();
		reqEntity.addPart(PARAM_IMAGE, image);
		reqEntity.addPart(PARAM_LANGUAGE, new StringBody(language));
		reqEntity.addPart(PARAM_APIKEY, new StringBody(getApiKey()));
		httppost.setEntity(reqEntity);

		final HttpResponse response = httpclient.execute(httppost);
		final HttpEntity resEntity = response.getEntity();
		final StringBuilder sb = new StringBuilder();
		if (resEntity != null) {
	    	final InputStream stream = resEntity.getContent();
	    	byte bytes[] = new byte[4096];
	    	int numBytes;
	    	while ((numBytes=stream.read(bytes))!=-1) {
	    		if (numBytes!=0) {
	    			sb.append(new String(bytes, 0, numBytes));
	    		}
	    	}
		}
		
		setResponseCode(response.getStatusLine().getStatusCode());
		
		setResponseText(sb.toString());
	}

	public int getResponseCode() {
		return responseCode;
	}

	public void setResponseCode(int responseCode) {
		this.responseCode = responseCode;
	}

	public String getResponseText() {
		return responseText;
	}

	public void setResponseText(String responseText) {
		this.responseText = responseText;
	}

	public String getApiKey() {
		return apiKey;
	}

	public void setApiKey(String apiKey) {
		this.apiKey = apiKey;
	}
}
