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
    project.evaluationDependsOn(":app")
}

subprojects {
    project.configurations.all {
        if (name == "implementation" || name == "debugImplementation") {
            dependencies.add(project.dependencies.create("androidx.concurrent:concurrent-futures:1.2.0"))
            dependencies.add(project.dependencies.create("androidx.concurrent:concurrent-futures-ktx:1.2.0"))
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
