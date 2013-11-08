package com.devkato.mobilesdk;

import java.io.IOException;
import java.util.ArrayList;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.json.JSONObject;

import android.os.AsyncTask;
import android.util.Log;

public class AsyncHttpRequest extends AsyncTask<JSONObject, Void, String> {

	@Override
	protected String doInBackground(JSONObject ... params) {
		
		ArrayList<NameValuePair> parameters = new ArrayList<NameValuePair>();
		parameters.add(new BasicNameValuePair("data", params[0].toString()));
		parameters.add(new BasicNameValuePair("device", params[1].toString()));
		
		HttpPost httpPost = new HttpPost("http://192.168.56.1:9292/api/v1/beacon");
		
		DefaultHttpClient client = new DefaultHttpClient();
		
		try {
			httpPost.setEntity(new UrlEncodedFormEntity(parameters, "utf-8"));
			HttpResponse httpResponse = client.execute(httpPost);
			
			// status code
			int statusCode = httpResponse.getStatusLine().getStatusCode();
			
			Log.d("TestSDK", String.format("statusCode : %d", statusCode));
			
			// response body
			HttpEntity entity = httpResponse.getEntity();
			String response = EntityUtils.toString(entity);
			
			Log.d("TestSDK", String.format("response : %s", response));
			
			entity.consumeContent();
			
			client.getConnectionManager().shutdown();
		} catch (ClientProtocolException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

	@Override
	protected void onPostExecute(String result) {
		// TODO Auto-generated method stub
		super.onPostExecute(result);
	}
}
