package com.exchangily.wallet;
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.plugins.util.GeneratedPluginRegister
import android.os.Bundle
import androidx.annotation.NonNull

class MainActivity: FlutterActivity() {
    // override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    //     GeneratedPluginRegistrant.registerWith(flutterEngine)
    // }

    private val CHANNEL ="com.exchangily.wallet/walletconnectsign"
    private val TESTCHANNEL = "com.exchangily.wallet/connectiontest"
    
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, TESTCHANNEL).setMethodCallHandler {
            call, result -> 
            if(call.method == "test"){
                result.success("Test passed")
            }
            
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegister.registerGeneratedPlugins(FlutterEngine(this@MainActivity))

        val signChannel = MethodChannel(flutterEngine?.dartExecutor, CHANNEL)
        signChannel.setMethodCallHandler { call, result ->
            when (call.method){
                "sign" -> {
                    val a = call.argument<String>("data")
                    if(call.method == "sign"){
                        result.success("Test passed: " +a)
                    }
                }
              }
         }
    }

    
}