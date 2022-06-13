package com.reactnativesolareumsdk;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.util.Log;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import org.json.JSONObject;

import java.util.List;


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

      if (intent.getData() !=null) {
        Uri uri = intent.getData();
        String client_id = uri.getQueryParameter("client_id");
        String signature = uri.getQueryParameter("signature");
        String status = uri.getQueryParameter("status");
        String jsonRequestString = "{\"client_id\" : \"" + client_id + "\" , "
          + "\"signature\" : \""+signature+"\", \"status\" : \""+status+"\"}";
        sendEvent(jsonRequestString);
      }
    }



    @ReactMethod
    public void pay(String jsonData){
      try{
        JSONObject data = new JSONObject(jsonData);
        String address = data.getString("address");
        String token = data.getString("token");
        String scheme = data.getString("scheme");
        String client_id = data.getString("client_id");
        String quantity = data.getString("quantity");
        String e_usd = data.getString("e_usd");
        Log.i("TAG",address + " - " + token + " - " + scheme);
        Log.d("open solareum","open solareum");
      ;
        boolean solareumAppIsInstalled = isAppInstalled(reactContext);
        Log.d("🚩 ","app installed "+solareumAppIsInstalled);
        if(solareumAppIsInstalled) {
          String uri =String.format("solareum://app?address=%s&token=%s&client_id=%s&quantity=%s&e_usd=%s&scheme=%s", address, token, client_id,quantity,e_usd,scheme) ;
          Log.d("🚩 uri",uri);
          Uri mUri = Uri.parse(uri);
          Intent mIntent = new Intent(Intent.ACTION_VIEW, mUri);
          mIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

          reactContext.startActivity(mIntent);
        }else {
            String uri = String.format("https://solareum.page.link/rewards?address=%s&token=%s&client_id=%s&quantity=%s&e_usd=%s&scheme=%s", address, token, client_id,quantity,e_usd,scheme  ) ;
          Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(uri));
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


    public static boolean isAppInstalled(ReactApplicationContext context) {
      PackageManager packageManager = context.getPackageManager();
      Intent intent = new Intent(Intent.ACTION_VIEW);
      if (intent.resolveActivity(packageManager) != null) {
          try {
              packageManager.getPackageInfo("com.solareum", PackageManager.GET_ACTIVITIES);
              return true;
          } catch (PackageManager.NameNotFoundException ignore) {

          }
      }
      return false;
  }

}
