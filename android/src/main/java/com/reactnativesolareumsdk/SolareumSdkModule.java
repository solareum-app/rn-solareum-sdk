package com.reactnativesolareumsdk;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;
import android.content.pm.PackageManager;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.facebook.react.bridge.ActivityEventListener;

import org.json.JSONObject;

public class SolareumSdkModule extends ReactContextBaseJavaModule implements ActivityEventListener{
    private static ReactApplicationContext reactContext;

    SolareumSdkModule(ReactApplicationContext context){
      super(context);
      reactContext = context;
      reactContext.addActivityEventListener(this);
  
    }
  
  //  @Override
    public String getName(){
      return "SolareumSdk";
    };
  
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
  
    }
  
  
  
    public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
      // TODO
    }


    public void onNewIntent(Intent intent) {
      Log.d("🚩 on new intent",intent.toString());
      Uri uri = intent.getData();
      sendEvent(uri.getQueryParameter("msg"));
    }
  
  
    @ReactMethod
    public void open(String jsonData){
      try{
        JSONObject data = new JSONObject(jsonData);
        String address = data.getString("address");
        String token = data.getString("token");
        String scheme = data.getString("scheme");
        String client_id = data.getString("client_id");
  
        Log.i("TAG",address + " - " + token + " - " + scheme);
        Log.d("open solareum","open solareum");
        String packageName = "com.solareum";
        PackageManager pm = reactContext.getPackageManager();
        Intent intent = pm.getLaunchIntentForPackage(packageName);
  
  
        if(intent != null) {
          String uri =String.format("solareum://app?address=%s&token=%s&client_id=%s&scheme=%s", address, token, client_id,scheme) ;
          Log.d("🚩 uri",uri);
  
          Uri mUri = Uri.parse(uri);
          Intent mIntent = new Intent(Intent.ACTION_VIEW, mUri);
          mIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
  
          reactContext.startActivity(mIntent);
        }else {
          Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse("https://solareum.page.link/rewards?address=D4aw7jPLJLEXqmKf9nQfMCbevtuVX4b1PkuKx5p2H1jx&token=XSB"));
          browserIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
          reactContext.startActivity(browserIntent);
        }
  
      }catch (Exception ex){
        Log.i("TAG","error : " + ex);
      }
    }
  
    private void sendEvent(String msg){
      getReactApplicationContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("showEvent", msg);  
    }
  
}
