allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.plugins.withId("com.android.library") {
        val android = project.extensions.findByName("android")
        if (android != null) {
            try {
                val getNamespace = android.javaClass.getMethod("getNamespace")
                if (getNamespace.invoke(android) == null) {
                    val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                    val ns = if (project.name.contains("isar")) "dev.isar.isar_flutter_libs" else "com.stackup.${project.name.replace("-", "_")}"
                    setNamespace.invoke(android, ns)
                }
            } catch (_: Exception) {}
        }
    }

    if (project.name != "app") {
        afterEvaluate {
            val android = project.extensions.findByName("android")
            if (android != null) {
                for (m in android.javaClass.methods) {
                    if (m.name == "setCompileSdkVersion" || m.name == "compileSdkVersion" || m.name == "setCompileSdk") {
                        try {
                            m.invoke(android, 36)
                        } catch (_: Exception) {}
                    }
                }
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
