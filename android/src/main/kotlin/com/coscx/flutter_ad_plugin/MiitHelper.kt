package com.coscx.flutter_ad_plugin

import android.content.Context
import android.util.Log
import com.bun.miitmdid.core.ErrorCode
import com.bun.miitmdid.core.MdidSdkHelper
import com.bun.miitmdid.interfaces.IIdentifierListener
import com.bun.miitmdid.interfaces.IdSupplier

/**
 * Created by zheng on 2019/8/22.
 */
class MiitHelper(private val _listener: AppIdsUpdater?) : IIdentifierListener {

    fun getDeviceIds(cxt: Context?) {
        val timeb = System.currentTimeMillis()
        val nres = CallFromReflect(cxt)
        //        int nres = DirectCall(cxt);
        val timee = System.currentTimeMillis()
        val offset = timee - timeb
        if (nres == ErrorCode.INIT_ERROR_DEVICE_NOSUPPORT) { //不支持的设备
        } else if (nres == ErrorCode.INIT_ERROR_LOAD_CONFIGFILE) { //加载配置文件出错
        } else if (nres == ErrorCode.INIT_ERROR_MANUFACTURER_NOSUPPORT) { //不支持的设备厂商
        } else if (nres == ErrorCode.INIT_ERROR_RESULT_DELAY) { //获取接口是异步的，结果会在回调中返回，回调执行的回调可能在工作线程
        } else if (nres == ErrorCode.INIT_HELPER_CALL_ERROR) { //反射调用出错
        }
        Log.d(javaClass.simpleName, "return value: $nres")
    }

    /*
     * 通过反射调用，解决android 9以后的类加载升级，导至找不到so中的方法
     *
     * */
    private fun CallFromReflect(cxt: Context?): Int {
        return MdidSdkHelper.InitSdk(cxt, true, this)
    }

    override fun OnSupport(isSupport: Boolean, _supplier: IdSupplier) {
        try {
            if (_supplier == null) {
                return
            }
            val oaid = _supplier.oaid
            val vaid = _supplier.vaid
            val aaid = _supplier.aaid
            val builder = StringBuilder()
            builder.append("support: ").append(if (isSupport) "true" else "false").append("\n")
            builder.append("OAID: ").append(oaid).append("\n")
            builder.append("VAID: ").append(vaid).append("\n")
            builder.append("AAID: ").append(aaid).append("\n")
            val idstext = builder.toString()
            Log.i("json", "idstext = $idstext")
            _listener?.OnIdsAvalid(oaid)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    interface AppIdsUpdater {
        fun OnIdsAvalid(ids: String?)
    }

}