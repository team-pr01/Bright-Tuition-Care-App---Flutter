package com.prtechsolutions.btc.btcclient

import android.content.ContentValues
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.prtechsolutions.btc.btcclient/pdf_download"

    override fun configureFlutterEngine(
        @NonNull flutterEngine: FlutterEngine
    ) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                "savePdfToDownloads" -> {

                    val fileName =
                        call.argument<String>("fileName")

                    val bytes =
                        call.argument<ByteArray>("bytes")

                    // Validate file name
                    if (fileName.isNullOrBlank()) {
                        result.error(
                            "INVALID_FILE_NAME",
                            "File name is required",
                            null
                        )
                        return@setMethodCallHandler
                    }

                    // Validate PDF bytes
                    if (bytes == null || bytes.isEmpty()) {
                        result.error(
                            "INVALID_PDF",
                            "PDF data is empty",
                            null
                        )
                        return@setMethodCallHandler
                    }

                    try {

                        val success = savePdfToDownloads(
                            fileName = fileName,
                            bytes = bytes
                        )

                        result.success(success)

                    } catch (e: Exception) {

                        result.error(
                            "SAVE_ERROR",
                            e.message ?: "Failed to save PDF",
                            null
                        )
                    }
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    // ============================================================
    // SAVE PDF
    // ============================================================

    private fun savePdfToDownloads(
        fileName: String,
        bytes: ByteArray
    ): Boolean {

        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {

            // Android 10+
            saveUsingMediaStore(
                fileName = fileName,
                bytes = bytes
            )

        } else {

            // Android 9 and below
            saveUsingLegacyStorage(
                fileName = fileName,
                bytes = bytes
            )
        }
    }

    // ============================================================
    // ANDROID 10+
    // MEDIASTORE
    // ============================================================

    private fun saveUsingMediaStore(
        fileName: String,
        bytes: ByteArray
    ): Boolean {

        val resolver = contentResolver

        val contentValues = ContentValues().apply {

            put(
                MediaStore.Downloads.DISPLAY_NAME,
                fileName
            )

            put(
                MediaStore.Downloads.MIME_TYPE,
                "application/pdf"
            )

            put(
                MediaStore.Downloads.RELATIVE_PATH,
                Environment.DIRECTORY_DOWNLOADS
            )

            put(
                MediaStore.Downloads.IS_PENDING,
                1
            )
        }

        val uri = resolver.insert(
            MediaStore.Downloads.EXTERNAL_CONTENT_URI,
            contentValues
        ) ?: throw Exception(
            "Could not create PDF in Downloads folder"
        )

        return try {

            resolver.openOutputStream(uri)?.use { outputStream ->

                outputStream.write(bytes)
                outputStream.flush()
            } ?: throw Exception(
                "Could not open PDF output stream"
            )

            // Mark file as completed
            val completedValues = ContentValues().apply {

                put(
                    MediaStore.Downloads.IS_PENDING,
                    0
                )
            }

            resolver.update(
                uri,
                completedValues,
                null,
                null
            )

            true

        } catch (e: Exception) {

            // Delete incomplete file
            resolver.delete(
                uri,
                null,
                null
            )

            throw e
        }
    }

    // ============================================================
    // ANDROID 9 AND BELOW
    // ============================================================

    private fun saveUsingLegacyStorage(
        fileName: String,
        bytes: ByteArray
    ): Boolean {

        val downloadsDirectory =
            Environment.getExternalStoragePublicDirectory(
                Environment.DIRECTORY_DOWNLOADS
            )

        if (!downloadsDirectory.exists()) {
            downloadsDirectory.mkdirs()
        }

        val file = File(
            downloadsDirectory,
            fileName
        )

        FileOutputStream(file).use { outputStream ->

            outputStream.write(bytes)
            outputStream.flush()
        }

        return true
    }
}