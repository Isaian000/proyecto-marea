package com.example.flutter_proyecto__marea

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.RenderMode

class MainActivity : FlutterActivity() {
    // En este emulador el SurfaceView inicia con un tamaño de 0 x 0 y no
    // presenta el primer frame. TextureView evita ese problema de renderizado.
    override fun getRenderMode(): RenderMode = RenderMode.texture
}
