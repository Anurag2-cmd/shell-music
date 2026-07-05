package com.shell.musicplayer

import android.content.Context
import com.chaquo.python.Python
import com.chaquo.python.android.AndroidPlatform
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import java.io.File

class PythonBridgePlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "com.shell.musicplayer/python")
        channel.setMethodCallHandler(this)

        if (!Python.isStarted()) {
            Python.start(AndroidPlatform(context))
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val py = Python.getInstance()
        val bridge = py.getModule("bridge")

        try {
            when (call.method) {
                "initialize" -> {
                    // Create the user extensions directory if it doesn't exist
                    val userExtDir = File(context.filesDir, "python_extensions")
                    if (!userExtDir.exists()) {
                        userExtDir.mkdirs()
                    }
                    bridge.callAttr("initialize", userExtDir.absolutePath)
                    result.success(userExtDir.absolutePath)
                }
                "get_installed_extensions" -> {
                    val json = bridge.callAttr("get_installed_extensions").toString()
                    result.success(parseJsonList(json))
                }
                "search" -> {
                    val args = call.arguments as Map<*, *>
                    val json = bridge.callAttr(
                        "search", args["source_id"]?.toString(), args["query"]?.toString(), args["page"]
                    ).toString()
                    result.success(parseJsonList(json))
                }
                "get_popular" -> {
                    val args = call.arguments as Map<*, *>
                    val json = bridge.callAttr(
                        "get_popular", args["source_id"]?.toString(), args["page"]
                    ).toString()
                    result.success(parseJsonList(json))
                }
                "get_latest" -> {
                    val args = call.arguments as Map<*, *>
                    val json = bridge.callAttr(
                        "get_latest", args["source_id"]?.toString(), args["page"]
                    ).toString()
                    result.success(parseJsonList(json))
                }
                "get_audio_details" -> {
                    val args = call.arguments as Map<*, *>
                    val json = bridge.callAttr(
                        "get_audio_details", args["source_id"]?.toString(), args["url"]?.toString()
                    ).toString()
                    result.success(parseJsonMap(json))
                }
                "get_download_urls" -> {
                    val args = call.arguments as Map<*, *>
                    val json = bridge.callAttr(
                        "get_download_urls", args["source_id"]?.toString(), args["url"]?.toString()
                    ).toString()
                    result.success(parseJsonList(json))
                }
                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            result.error("PYTHON_ERROR", e.message, null)
        }
    }

    @Suppress("UNCHECKED_CAST")
    private fun parseJsonList(json: String): List<Map<String, Any?>> {
        val gson = com.google.gson.Gson()
        val type = object : com.google.gson.reflect.TypeToken<List<Map<String, Any?>>>() {}.type
        return gson.fromJson(json, type) ?: emptyList()
    }

    @Suppress("UNCHECKED_CAST")
    private fun parseJsonMap(json: String): Map<String, Any?> {
        val gson = com.google.gson.Gson()
        val type = object : com.google.gson.reflect.TypeToken<Map<String, Any?>>() {}.type
        return gson.fromJson(json, type) ?: emptyMap()
    }
}
