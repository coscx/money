package com.coscx.flutter_ad_plugin

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.HandlerThread
import android.util.Log
import androidx.annotation.NonNull
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import com.coscx.flutter_ad_plugin.MiitHelper.AppIdsUpdater
import com.duoyou.task.openapi.DyAdApi
import com.tradplus.ads.base.bean.TPAdError
import com.tradplus.ads.base.bean.TPAdInfo
import com.tradplus.ads.open.LoadAdEveryLayerListener
import com.tradplus.ads.open.TradPlusSdk
import com.tradplus.ads.open.reward.TPReward
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.lifecycle.HiddenLifecycleReference
import io.flutter.plugin.common.*
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener
import java.util.*


/** FlutterAdPlugin */
class FlutterAdPlugin: FlutterPlugin, MethodCallHandler ,DefaultLifecycleObserver, EventChannel.StreamHandler, ActivityAware, ActivityResultListener{
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private val eventSink: EventChannel.EventSink? = null
  private var context: Context? = null
  var registrar: PluginRegistry.Registrar? = null
  var activityPluginBinding: ActivityPluginBinding? = null
  var activity: Activity? = null
  private var imThread //处理im消息的线程
          : HandlerThread? = null
  private var lifecycle: Lifecycle? = null
  private val currentUID: Long = 0
  private val conversationID: Long = 0

  protected var groupID: Long = 0
  protected var groupName: String? = null
  private val TAG = FlutterAdPlugin::class.java.simpleName
  fun initInstance(messeger: BinaryMessenger?, context: Context?) {
    channel = MethodChannel(messeger, "flutter_ad_plugin")
    channel.setMethodCallHandler(this)
    val eventChannel = EventChannel(messeger, "flutter_ad_plugin_event")
    eventChannel.setStreamHandler(this)
    this.context = context
  }
  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    initInstance(flutterPluginBinding.binaryMessenger, flutterPluginBinding.applicationContext)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "init" -> {
        init(call.arguments, result)
      }
      "initTradePlus" -> {
        initTradePlus(call.arguments, result)
      }
      "getPlatformVersion" -> {
        getPlatformVersion(call.arguments, result);
      }
      "jumpAdList" -> {
        jumpAdList(call.arguments, result);
      }
      else -> result.notImplemented()
    }

  }

  private fun jumpAdList(arg: Any, result: Result) {
    DyAdApi.getDyAdApi().jumpAdList(activity, "11111", 0);
    result.success(resultSuccess("Android ${android.os.Build.VERSION.RELEASE}"))
  }
  private fun getPlatformVersion(arg: Any, result: Result) {

    result.success(resultSuccess("Android ${android.os.Build.VERSION.RELEASE}"))
  }
  private fun init(arg: Any, result: Result) {
    adInit()
    result.success(resultSuccess("init success"))
  }
  private fun initTradePlus(arg: Any, result: Result) {
    TradPlusSdk.initSdk(context,"APPID");
    val mTpReward = TPReward(context, "AdUnitId", true)
    //高级用法

    //高级用法
    mTpReward.setAllAdLoadListener(object : LoadAdEveryLayerListener {
      override fun onAdAllLoaded(b: Boolean) {
        Log.i(TAG, "onAdAllLoaded: 该广告位下所有广告加载结束，是否有广告加载成功 ：$b")
      }

      override fun oneLayerLoadFailed(tpAdError: TPAdError, tpAdInfo: TPAdInfo) {
        Log.i(TAG, "oneLayerLoadFailed:  广告" + tpAdInfo.adSourceName + " 加载失败，code :: " +
                tpAdError.errorCode + " , Msg :: " + tpAdError.errorMsg)
      }

      override fun oneLayerLoaded(tpAdInfo: TPAdInfo) {
        //每次调用load，TradPlus广告位下load成功的广告源都会被回调
        Log.i(TAG, "oneLayerLoaded:  广告" + tpAdInfo.adSourceName + " 加载成功")
      }
    })
    result.success(resultSuccess("init success"))
  }
  fun resultSuccess(data: Any?): Any? {
    return _buildResult(0, "成功", data)
  }

  fun resultError(error: String?, code: Int): Any? {
    return _buildResult(code, error, null)
  }

  fun _buildResult(code: Int, message: String?, data: Any?): Any? {
    val hashMap: MutableMap<String, Any?> = HashMap()
    hashMap["code"] = code
    hashMap["message"] = message
    hashMap["data"] = data
    return hashMap
  }
  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun disposeActivity() {
    this.activityPluginBinding?.removeActivityResultListener(this)
    this.activity = null
    this.activityPluginBinding = null
    lifecycle?.removeObserver(this)
  }

  private fun attachToActivity(activityPluginBinding: ActivityPluginBinding) {
    val reference = activityPluginBinding.lifecycle as HiddenLifecycleReference
    this.activityPluginBinding = activityPluginBinding
    activityPluginBinding.addActivityResultListener(this)
    this.activity = activityPluginBinding.activity
    this.lifecycle = reference.lifecycle
    lifecycle!!.addObserver(this)
  }



  /// ActivityAware
  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    attachToActivity(binding)
  }

  override fun onDetachedFromActivity() {
    disposeActivity()
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    attachToActivity(binding)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    disposeActivity()
  }

  /// ActivityResultListener
  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
    return false
  }

  /// DefaultLifecycleObserver
  override fun onCreate(owner: LifecycleOwner) {}

  override fun onStart(owner: LifecycleOwner) {}

  override fun onResume(owner: LifecycleOwner) {

  }

  override fun onPause(owner: LifecycleOwner) {}

  override fun onStop(owner: LifecycleOwner) {

  }

  override fun onDestroy(owner: LifecycleOwner) {}
  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    TODO("Not yet implemented")
  }

  override fun onCancel(arguments: Any?) {
    TODO("Not yet implemented")
  }
 private fun  adInit() {
   DyAdApi.getDyAdApi().init(context,"dy_59633678", "ee0a8ee5de2ce442c8b094410440ec8c", "channel");
   try {
     if (Build.VERSION.SDK_INT >= 29) {
       val miitHelper = MiitHelper(object : AppIdsUpdater {
         override fun OnIdsAvalid(ids: String?) {
             Log.i("json", "oaid = $ids")
             object : Thread() {
               override fun run() {
                 DyAdApi.getDyAdApi().putOAID(activity, ids)

               }
             }.start()
         }
       })
       Log.i("json", "oaid = 获取OAID")
       miitHelper.getDeviceIds(context)
     }
   } catch (e: Exception) {
     e.printStackTrace()
   }
 }



}
