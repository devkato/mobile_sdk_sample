package com.devkato.mobilesdk;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.graphics.Point;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Display;
import android.view.WindowManager;

public class TestSDK {

	private Context context;
	
	public TestSDK(Context context) {
		Log.d("TestSDK", "hello world!");
		this.context = context;
	}
	
	public void sendData(JSONObject data_object) {
		Log.d("TestSDK", "send data called");
		
		JSONObject device_object = new JSONObject();
		
		try {
			device_object.put("uuid", getUUID());
			
			// system info
			device_object.put("system_version", android.os.Build.VERSION.RELEASE);
			device_object.put("sdk_version", android.os.Build.VERSION.SDK_INT);
			device_object.put("system_codename", android.os.Build.VERSION.CODENAME);
			device_object.put("system_name", "Android OS");
			
			// screen size
			device_object.put("screen_width",
					String.format("%d", this.context.getResources().getDisplayMetrics().widthPixels));
			device_object.put("screen_height",
					String.format("%d", this.context.getResources().getDisplayMetrics().heightPixels));
		} catch (JSONException e) {
			e.printStackTrace();
		}
		
		AsyncHttpRequest request = new AsyncHttpRequest();
		request.execute(data_object, device_object);
	}

	private String getUUID() {
		return Installation.id(this.context);
	}
}
