package com.example.sampleproject;

import org.json.JSONException;
import org.json.JSONObject;

import com.devkato.mobilesdk.Installation;
import com.devkato.mobilesdk.TestSDK;

import android.os.Bundle;
import android.app.Activity;
import android.util.Log;
import android.view.Menu;

public class MainActivity extends Activity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);

		TestSDK sdk = new TestSDK(this);
		
		JSONObject json = new JSONObject();
		
		try {
			json.put("hello", "world");
			json.put("hige", "huga");
			JSONObject sub = new JSONObject();
			sub.put("sub1", "value1");
			sub.put("sub2", "value2");
			json.put("hige", sub);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		sdk.sendData(json);
		
		String uuid = Installation.id(this);

		Log.d("TestSDK", String.format("uuid -> %s", uuid));
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}
}
