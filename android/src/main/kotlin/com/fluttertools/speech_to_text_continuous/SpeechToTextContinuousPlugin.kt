// android/src/main/kotlin/com/fluttertools/speech_to_text_continuous/SpeechToTextContinuousPlugin.kt

package com.fluttertools.speech_to_text_continuous

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.speech.RecognitionListener
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** Plugin Android del paquete speech_to_text_continuous */
class SpeechToTextContinuousPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private var speechRecognizer: SpeechRecognizer? = null
    private lateinit var activity: Activity
    private lateinit var recognizerIntent: Intent
    private var isListening = false

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "speech_to_text_continuous")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "initialize" -> {
                initializeSpeechRecognizer()
                result.success(null)
            }
            "startListening" -> {
                startListening()
                result.success(null)
            }
            "stopListening" -> {
                stopListening()
                result.success(null)
            }
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            else -> result.notImplemented()
        }
    }

    /** Inicializa el SpeechRecognizer de Android y el Intent necesario */
    private fun initializeSpeechRecognizer() {
        if (SpeechRecognizer.isRecognitionAvailable(activity)) {
            speechRecognizer = SpeechRecognizer.createSpeechRecognizer(activity)
            speechRecognizer?.setRecognitionListener(object : RecognitionListener {
                override fun onReadyForSpeech(params: Bundle?) {
                    Log.d("Speech", "Listo para escuchar")
                }

                override fun onBeginningOfSpeech() {
                    Log.d("Speech", "Comenzando a escuchar")
                }

                override fun onRmsChanged(rmsdB: Float) {}

                override fun onBufferReceived(buffer: ByteArray?) {}

                override fun onEndOfSpeech() {
                    Log.d("Speech", "Fin de la frase")
                }

                override fun onError(error: Int) {
                    Log.e("Speech", "Error $error")
                    restartListeningWithDelay()
                }

                override fun onResults(results: Bundle?) {
                    val matches = results?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
                    matches?.let {
                        for (text in it) {
                            channel.invokeMethod("onText", text)
                        }
                    }
                    restartListeningWithDelay()
                }

                override fun onPartialResults(partialResults: Bundle?) {
                    val partial = partialResults?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
                    partial?.firstOrNull()?.let {
                        channel.invokeMethod("onText", it)
                    }
                }

                override fun onEvent(eventType: Int, params: Bundle?) {}
            })

            recognizerIntent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
                putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
                putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS, true)
                putExtra(RecognizerIntent.EXTRA_CALLING_PACKAGE, activity.packageName)
            }
        }
    }

    /** Comienza a escuchar de forma continua */
    private fun startListening() {
        if (!isListening) {
            isListening = true
            speechRecognizer?.startListening(recognizerIntent)
        }
    }

    /** Detiene el reconocimiento */
    private fun stopListening() {
        isListening = false
        speechRecognizer?.stopListening()
        speechRecognizer?.cancel()
    }

    /** Reinicia la escucha para mantener el reconocimiento continuo */
    private fun restartListeningWithDelay() {
        if (isListening) {
            Handler(Looper.getMainLooper()).postDelayed({
                speechRecognizer?.startListening(recognizerIntent)
            }, 500)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        speechRecognizer?.destroy()
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {}
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {}
}



// package com.fluttertools.speech_to_text_continuous

// import android.app.Activity
// import android.content.Intent
// import android.os.Handler
// import android.os.Looper
// import android.speech.RecognitionListener
// import android.speech.RecognizerIntent
// import android.speech.SpeechRecognizer
// import androidx.annotation.NonNull
// import android.content.Context
// import android.Manifest
// import android.content.pm.PackageManager
// import androidx.core.app.ActivityCompat
// import androidx.core.content.ContextCompat

// import io.flutter.embedding.engine.plugins.FlutterPlugin
// import io.flutter.embedding.engine.plugins.activity.ActivityAware
// import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
// import io.flutter.plugin.common.MethodCall
// import io.flutter.plugin.common.MethodChannel
// import io.flutter.plugin.common.MethodChannel.MethodCallHandler

// /** SpeechToTextContinuousPlugin */
// class SpeechToTextContinuousPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {

//   private lateinit var channel : MethodChannel
//   private lateinit var context: Context
//   private var activity: Activity? = null
//   private var speechRecognizer: SpeechRecognizer? = null
//   private lateinit var recognizerIntent: Intent
//   private var handler = Handler(Looper.getMainLooper())

//   private var isListening = false

//   override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
//     context = flutterPluginBinding.applicationContext
//     channel = MethodChannel(flutterPluginBinding.binaryMessenger, "speech_to_text_continuous")
//     channel.setMethodCallHandler(this)
//   }

//   override fun onAttachedToActivity(binding: ActivityPluginBinding) {
//     activity = binding.activity
//   }

//   override fun onDetachedFromActivity() {
//     activity = null
//   }

//   override fun onDetachedFromActivityForConfigChanges() {}
//   override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
//     activity = binding.activity
//   }

//   override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
//     when (call.method) {
//       "initialize" -> {
//         checkPermissions()
//         result.success(null)
//       }
//       "startListening" -> {
//         startListening()
//         result.success(null)
//       }
//       "stopListening" -> {
//         stopListening()
//         result.success(null)
//       }
//       else -> result.notImplemented()
//     }
//   }

//   private fun checkPermissions() {
//     val permissions = arrayOf(Manifest.permission.RECORD_AUDIO)
//     val missing = permissions.filter {
//       ContextCompat.checkSelfPermission(context, it) != PackageManager.PERMISSION_GRANTED
//     }
//     if (missing.isNotEmpty() && activity != null) {
//       ActivityCompat.requestPermissions(activity!!, missing.toTypedArray(), 1)
//     }
//   }

//   private fun startListening() {
//     if (SpeechRecognizer.isRecognitionAvailable(context)) {
//       if (speechRecognizer == null) {
//         speechRecognizer = SpeechRecognizer.createSpeechRecognizer(context)
//         speechRecognizer?.setRecognitionListener(object : RecognitionListener {
//           override fun onReadyForSpeech(params: Bundle?) {}
//           override fun onBeginningOfSpeech() {}
//           override fun onRmsChanged(rmsdB: Float) {}
//           override fun onBufferReceived(buffer: ByteArray?) {}
//           override fun onEndOfSpeech() {}

//           override fun onError(error: Int) {
//             // Reinicia después de un pequeño retraso
//             if (isListening) handler.postDelayed({ startListening() }, 500)
//           }

//           override fun onResults(results: Bundle) {
//             val matches = results.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
//             if (!matches.isNullOrEmpty()) {
//               channel.invokeMethod("onText", matches[0])
//             }
//             if (isListening) handler.postDelayed({ startListening() }, 500)
//           }

//           override fun onPartialResults(partialResults: Bundle) {
//             val partial = partialResults.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
//             if (!partial.isNullOrEmpty()) {
//               channel.invokeMethod("onText", partial[0])
//             }
//           }

//           override fun onEvent(eventType: Int, params: Bundle?) {}
//         })
//       }

//       recognizerIntent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
//         putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
//         putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS, true)
//         putExtra(RecognizerIntent.EXTRA_CALLING_PACKAGE, context.packageName)
//       }

//       isListening = true
//       speechRecognizer?.startListening(recognizerIntent)
//     }
//   }

//   private fun stopListening() {
//     isListening = false
//     speechRecognizer?.stopListening()
//     speechRecognizer?.cancel()
//     speechRecognizer?.destroy()
//     speechRecognizer = null
//   }

//   override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
//     stopListening()
//     channel.setMethodCallHandler(null)
//   }
// }
