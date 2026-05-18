package webkul.opencart_flutter.mobikul

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.content.FileProvider
import com.webkul.flutter_project_structure.arcore.activities.ArActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import webkul.opencart.mobikul.mlkit.CameraSearchActivity
import java.io.File

import android.content.pm.PackageManager
import android.content.ComponentName
import android.os.Build
import android.os.Bundle
import androidx.core.view.WindowCompat
import webkul.opencart_flutter.mobikul.launcherAlias.LauncherAliasDefault
import webkul.opencart_flutter.mobikul.launcherAlias.LauncherAliasFive
import webkul.opencart_flutter.mobikul.launcherAlias.LauncherAliasFour
import webkul.opencart_flutter.mobikul.launcherAlias.LauncherAliasOne
import webkul.opencart_flutter.mobikul.launcherAlias.LauncherAliasThree
import webkul.opencart_flutter.mobikul.launcherAlias.LauncherAliasTwo

class MainActivity : FlutterFragmentActivity() {
    private val EVENTS = "com.webkul.oc.methodchannel"
    var methodChannelResult: MethodChannel.Result? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        // Aligns the Flutter view vertically with the window.
        WindowCompat.setDecorFitsSystemWindows(getWindow(), false)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Disable the Android splash screen fade out animation to avoid
            // a flicker before the similar frame is drawn in Flutter.
            splashScreen.setOnExitAnimationListener { splashScreenView -> splashScreenView.remove() }
        }

        super.onCreate(savedInstanceState)
    }
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            EVENTS
        ).setMethodCallHandler { call, result ->
            methodChannelResult = result;
            /*
* Method to open pdf and respective app chooser after downloading file.
*
* */
            if (call.method.equals("fileviewer")) {
                var path: String = call.arguments()!!
                var file = File(path)
                // Avoid apache-commons dependency; Kotlin stdlib gives same file extension value.
                val extension = file.extension

                val photoURI: Uri = FileProvider.getUriForFile(
                    this,
                    this.applicationContext.packageName.toString(),
                    file
                )
                val intent = Intent(Intent.ACTION_VIEW)
                intent.setFlags(Intent.FLAG_ACTIVITY_NO_HISTORY)
                intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                intent.setDataAndType(photoURI, "application/" + extension)
                if (intent.resolveActivity(getPackageManager()) != null) {
                    //if device have requested extension app then respective app will open
                    println("File extension app found in the device")
                    startActivity(intent);
                } else {
                    //if device don't have requested extension app then all app option will be visible.
                    println("File extension app Not found in the device")

                    intent.setDataAndType(photoURI, "*/*")
                    startActivity(intent);
                }
                result.success(true)

            }else if (call.method == "initialLink") {
                val initialUrl = initialLink()
                if (initialUrl != null) {
                    result.success(initialLink())
                } else {
                    result.error("UNAVAILABLE", "No deep link found", null)
                }
            } else if (call.method == "imageSearch") {
                startImageFinding()
            } else if (call.method == "textSearch") {

                startTextFinding()
            } else if (call.method == "showAr") {
                if (call.hasArgument("url")) {
                    Log.d("qdaasdas", call.argument("url") ?: "No Name")
                }
                showArActivity(call.argument("name"), call.argument("url"))

            } else if (call.method == "dynamicLauncher") {
                val path: String? = call.arguments()
                checkLauncherType(path)
                result.success("Success")
            }
        }
    }


    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == 101 && resultCode == Activity.RESULT_OK) {
            methodChannelResult?.success(data?.getStringExtra(CameraSearchActivity.CAMERA_SEARCH_HELPER))
        }
    }

    fun initialLink(): String? {
        val uri = intent.data
        Log.d("adasdasda", uri.toString())
        return if (uri != null) {
            uri.toString();
        } else {
            null
        }
    }

    private fun startImageFinding() {
        val intent = Intent(this, CameraSearchActivity::class.java)
        intent.putExtra(
            CameraSearchActivity.CAMERA_SELECTED_MODEL,
            CameraSearchActivity.IMAGE_LABELING
        )
        startActivityForResult(intent, 101)
    }

    private fun startTextFinding() {
        val intent = Intent(this, CameraSearchActivity::class.java)
        intent.putExtra(
            CameraSearchActivity.CAMERA_SELECTED_MODEL,
            CameraSearchActivity.TEXT_RECOGNITION
        )
        startActivityForResult(intent, 101)
    }

    private fun showArActivity(name: String?, url: String?) {
        Log.d("sdaasdas", "${name}----${url}")
        val intent = Intent(this, ArActivity::class.java)
        intent.putExtra("name", name)
        intent.putExtra("link", url)
        startActivity(intent)
    }

    /* Start Dynamic Launcher Change Code */
    private fun checkLauncherType(launcherType: String?) {
        if (launcherType.equals("1")) {
            AppSharedPref.setLauncherIcon(this, "launcherAlias.LauncherAliasOne")
            AppSharedPref.setCount(this, 1)
        } else if (launcherType.equals("2")) {
            AppSharedPref.setLauncherIcon(this, "launcherAlias.LauncherAliasTwo")
            AppSharedPref.setCount(this, 2)
        } else if (launcherType.equals("3")) {
            AppSharedPref.setLauncherIcon(this, "launcherAlias.LauncherAliasThree")
            AppSharedPref.setCount(this, 3)
        } else {
            AppSharedPref.setLauncherIcon(this, "launcherAlias.LauncherAliasDefault")
            AppSharedPref.setCount(this, 0)
        }

        /* else if (launcherType.equals("4")) {
             AppSharedPref.setLauncherIcon(this, "launcherAlias.LauncherAliasFour")
             AppSharedPref.setCount(this, 0)
         } else if (launcherType.equals("5")) {
             AppSharedPref.setLauncherIcon(this, "launcherAlias.LauncherAliasFive")
             AppSharedPref.setCount(this, 0)
         } else {
             AppSharedPref.setLauncherIcon(this, "launcherAlias.LauncherAliasDefault")
             AppSharedPref.setCount(this, 0)
         }*/
    }


    private fun setIcon(targetIcon: String) {
        try {
            when(targetIcon){
                "0"->{
                    // default block
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasDefault::class.java), PackageManager.COMPONENT_ENABLED_STATE_ENABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasTwo::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasTwo::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasThree::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasFour::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasFive::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)

                }
                "1"->{
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasOne::class.java), PackageManager.COMPONENT_ENABLED_STATE_ENABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasTwo::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasThree::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasDefault::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasFour::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasFive::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)

                }
                "2"->{
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasTwo::class.java), PackageManager.COMPONENT_ENABLED_STATE_ENABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasOne::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasThree::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasDefault::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasFour::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasFive::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)

                }
                "3"->{
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasThree::class.java), PackageManager.COMPONENT_ENABLED_STATE_ENABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasOne::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasTwo::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasDefault::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasFour::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasFive::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)

                }
                "4"->{
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasOne::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasTwo::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasThree::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasDefault::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasFour::class.java), PackageManager.COMPONENT_ENABLED_STATE_ENABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasFive::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)

                }
                "5"->{
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasOne::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasTwo::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasThree::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasDefault::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasFour::class.java), PackageManager.COMPONENT_ENABLED_STATE_DISABLED,PackageManager.DONT_KILL_APP)
                    packageManager.setComponentEnabledSetting(ComponentName(this@MainActivity, LauncherAliasFive::class.java), PackageManager.COMPONENT_ENABLED_STATE_ENABLED,PackageManager.DONT_KILL_APP)

                }

            }
        } catch (e: Exception) {
            Log.e("Error setComponentName", e.message.toString())
        }
    }





    override fun onPause() {
        super.onPause()
        if (AppSharedPref.getCount(this) != AppSharedPref.getSavedCount(this)) {
            AppSharedPref.setSavedCount(this, AppSharedPref.getCount(this))
            Log.d("onPause test ", "Launcher screeen here")
            setIcon(AppSharedPref.getCount(this).toString())
//            setIcon("0")
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        // Launcher Changed when Activity Destroyed
        if (AppSharedPref.getCount(this) != AppSharedPref.getSavedCount(this)) {
            AppSharedPref.setSavedCount(this, AppSharedPref.getCount(this))
            Log.d("onDestroy test ", "Launcher screeen here")
            setIcon(AppSharedPref.getCount(this).toString())
//            setIcon("0")
        }
    }

    /* End Dynamic Launcher Change Code */
}
