plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services") // <- Adicionado aqui
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.final_project"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.final_project"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Importa o Firebase BoM pra gerenciar versões automaticamente
    implementation(platform("com.google.firebase:firebase-bom:33.1.0"))

    // Aqui você vai colocando os serviços que quiser (ex: Firestore, Auth etc)
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-firestore")
}
