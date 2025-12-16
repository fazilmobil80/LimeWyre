package com.mobil80.limewyre

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "limewyre/share"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleShareIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleShareIntent(intent)
    }

    private fun handleShareIntent(intent: Intent?) {
        if (intent == null) return

        val action = intent.action
        val type = intent.type
        val data = HashMap<String, Any?>()

        when (action) {
            Intent.ACTION_SEND -> {
                if (type?.startsWith("text/") == true) {
                    data["type"] = "text"
                    data["value"] = intent.getStringExtra(Intent.EXTRA_TEXT)
                } else {
                    val uri = intent.getParcelableExtra<Uri>(Intent.EXTRA_STREAM)
                    data["type"] = "file"
                    data["value"] = uri?.toString()
                }
            }

            Intent.ACTION_SEND_MULTIPLE -> {
                val uris = intent.getParcelableArrayListExtra<Uri>(Intent.EXTRA_STREAM)
                data["type"] = "files"
                data["value"] = uris?.map { it.toString() }
            }
        }

        MethodChannel(
            flutterEngine!!.dartExecutor.binaryMessenger,
            CHANNEL
        ).invokeMethod("sharedData", data)
    }
}
