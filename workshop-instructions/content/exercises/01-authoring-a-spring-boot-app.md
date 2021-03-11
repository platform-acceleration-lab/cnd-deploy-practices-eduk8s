# Building a Spring Boot App

This exercise will walk you through building and running a basic
blocking web application using
[Spring Boot](https://projects.spring.io/spring-boot/)
on your "local" development environment.

# Learning outcomes

- Describe how to create a controller that responds to HTTP requests
- Describe how dependencies are specifie *within* your web application.

# Getting started

Take a few minutes to review the Introduction:

- [Slides]({{ ingress_protocol }}://{{ session_namespace }}.{{ ingress_domain }}/slides#/intro)
- [Video](https://drive.google.com/file/d/1js7Pph8sx2G7w937PDhH_Js1ZZ93Ubp3/preview)

# Project structure

1.  At VMware Tanzu labs,
    developers practice [pair programming](https://en.wikipedia.org/wiki/Pair_programming)
    and rotate pairs quite frequently,
    usually two to three times per week.
    Because of this, a developer may be assigned to a different
    workstation on any given day.
    To reduce friction, Tanzu Labs adopted a standard directory
    structure for where all project code is located.

    While the precise name may be arbitrary
    (your team might pick a different name or structure),
    the important consideration is *it is a standard* across your team.

    These lab instructions will assume from now on that your code is in
    the `~/exercises` directory.

1.  The `~/exercises/pal-tracker` directory contains the code you will
    review and exercise.

1.  Set current directory to the `~/exercises/pal-tracker` now in both of
    your terminal windows:

    ```terminal:execute-all
    command: cd ~/exercises/pal-tracker
    ```

1.  Read about the [gradle wrapper](https://docs.gradle.org/current/userguide/gradle_wrapper.html#sec:adding_wrapper).
    It is used in this project to execute various tasks to build or
    run your web application locally.

1.  Open the `gradle/wrapper/gradle-wrapper.properties` file in your
    code editor and review the `DISTRIBUTION_URL` value.
    This is specific version of gradle that is pinned to this project
    which guarantees
    [Environment parity](https://12factor.net/dev-prod-parity)
    of the build tool between the developer and various build and
    pipeline environments.

    ```editor:open-file
    file: ~/exercises/gradle/wrapper/gradle-wrapper.properties
    ```

# Review the gradle project

Now that once the plumbing of our application is set up,
you can begin building a Spring Boot _Hello World_ application.

The Spring community provides [Spring Initializr](http://start.spring.io)
to help you generate your project,
but you very well could generate your own project from scratch.

You are provided the project in this exercise.

Review the various sections of the gradle build to become familiar with
it:

1.  Open your project in your code editor:

    ```editor:open-file
    file: ~/exercises/pal-tracker/build.gradle
    ```

1.  Review the `plugins` "closure"
    (a groovy specific term for a *code block*):

    ```groovy
    plugins {
        id 'org.springframework.boot' version '2.3.1.RELEASE'
        id 'io.spring.dependency-management' version '1.0.8.RELEASE'
        id 'java'
    }
    ```

    -   Apply the `2.3.1.RELEASE` version of the
        [spring boot gradle plugin](https://docs.spring.io/spring-boot/docs/current/reference/html/build-tool-plugins-gradle-plugin.html).

    -   Apply the `1.0.8.RELEASE` version of the
        [Spring Dependency Management plugin](https://plugins.gradle.org/plugin/io.spring.dependency-management)

    -   Apply the
        [Java plugin](https://docs.gradle.org/current/userguide/java_plugin.html).

1.  Create a `repositories` closure adding Maven Central to your
    `build.gradle` file.

1.  Add a `dependencies` closure to your `build.gradle` file,
    and add a Java implementation dependency on the
    `org.springframework.boot:spring-boot-starter-web` package.

    The resulting Gradle file should look like the solution:

    ```terminal:execute
    command: git show spring-boot-app-solution:build.gradle
    session: 2
    ```

1.  Add a `settings.gradle` file with `rootProject.name` value of
    `"pal-tracker"`.

    This will configure the name of your Gradle project which ensures
    that your jarfile has the correct filename.

    Your solution should look like the following:

    ```terminal:execute
    command: git show spring-boot-app-solution:settings.gradle
    session: 2
    ```

1.  Verify the gradle wrapper is properly installed:

    ```terminal:execute
    command: ./gradlew clean
    session: 1
    ```

1.  Create a standard [maven directory layout](https://maven.apache.org/guides/introduction/introduction-to-the-standard-directory-layout.html).

    Specifically, create a `src/main/java` directory structure within
    the `pal-tracker` directory:

    ```terminal:execute
    command: mkdir -p src/main/java
    session: 1
    ```

# Set up your code editor

Up to this point,
your editor does not know you have bootstrapped a Java project.

You will set up your editor now to activate the
*Java Project Manager* extension:

1.  Open your editor:

    ```editor:open-file
    file: ~/exercises/pal-tracker/build.gradle
    ```

1.  Execute the `>Java: Create Project` command.
    (Bring up the Command Palette (Cmd+Shift+P for Mac and
    Ctrl+Shift+P for Windows) and then type `Java`
    to search for this command.)

1.  Watch the bottom status bar as the Java project management
    extensions are loaded,
    this may take a minute.
    At the end of the process you will see a prompt for a project
    creation archetype.
    Dismiss it by hitting the ESC key.

    You should now see a "JAVA PROJECTS" view near the bottom of the
    Explorer pane,
    the Java Project Manager will detect your Gradle built Java
    project.

1.  Switch to the "JAVA PROJECTS" view in the editor Explorer.

# Create the application package

1.  Inside of the source directory `src/main/java`,
    all of your code will go into the `io.pivotal.pal.tracker` package.
    Create this package now,
    making sure to either use the JAVA PROJECTS view `New Package`
    feature (by right-click'ing `src/main/java` under the JAVA PROJECTS view),
    or manually create the associated directory structure.

    ```terminal:execute
    command: mkdir -p src/main/java/io/pivotal/pal/tracker
    session: 1
    ```

# Create the Spring Boot application

1.  Create a class in the `tracker` package called
    `PalTrackerApplication` and annotate it with
    [`@SpringBootApplication`](https://docs.spring.io/autorepo/docs/spring-boot/current/api/org/springframework/boot/autoconfigure/SpringBootApplication.html).

    This annotation enables component scanning, auto configuration, and
    declares that the class is a configuration class.

1.  Add a `main` method to the `PalTrackerApplication` class and tell
    Spring to run.

    This `main` method executes the Spring Boot
    [`SpringApplication.run`](https://docs.spring.io/spring-boot/docs/current/api/org/springframework/boot/SpringApplication.html)
    method which bootstraps the _Dependency Injection_ container, scans
    the classpath for beans, and starts the application.

    The class will look like this:

    ```terminal:execute
    command: git show spring-boot-app-solution:src/main/java/io/pivotal/pal/tracker/PalTrackerApplication.java
    session: 2
    ```

1.  Verify the application is set up correctly by running your
    application.

    Using your Gradle wrapper `gradlew` in the root of the `pal-tracker`
    project,
    run the `tasks` command to find which task to use to run your
    application locally.

    ```terminal:execute
    command: ./gradlew tasks
    session: 1
    ```

    Once you find the task, use it to run your application.

    If all is well, you will see log output from Spring Boot and a
    line that says it is listening on port 8080.
    Navigate to [localhost:8080](http://localhost:8080) and see that the
    application responds.

    ```terminal:execute
    command: curl -v localhost:8080
    session: 2
    ```

    You will see a white label error page with a status code of 404.
    The application is running but it does not have any controllers.
    Stop the application with _CTRL + C_.

    ```terminal:execute
    command: <ctrl+c>
    session: 1
    ```

# Create a controller

In the same package create a controller class that returns
`hello` when the app receives a __GET__ request at `/`.

Following labs will go in to more detail about what is happening here,
but for now, just follow along.

1.  Create a class called `WelcomeController` in the `tracker` package,
    alongside the main application class .

1.  Annotate `WelcomeController` with `@RestController` and write a
    method that returns the string `hello`.

    The name of the method is not important to Spring, but call it
    `sayHello`.
    Finally, annotate the method with `@GetMapping("/")`.

    The controller will look like this:

    ```terminal:execute
    command: git show spring-boot-app-solution:src/main/java/io/pivotal/pal/tracker/WelcomeController.java
    session: 2
    ```

1.  Verify the controller is working correctly by starting the
    application in terminal window 1.

1.  Now visit [localhost:8080](http://localhost:8080) to see the `hello`
    message.

    ```terminal:execute
    command: curl -v localhost:8080
    session: 2
    ```

# Commit your changes

1.  Stage and commit your new changes.

    ```terminal:execute
    command: git add *.gradle gradle* src
    session: 2
    ```

    ```terminal:execute
    command: git commit -m'Simple Spring Boot app'
    session: 2
    ```

# Submit this assignment

Submit the assignment using the
`cloudNativeDeveloperK8sBootApp` gradle task from within the
existing `assignment-submission` project directory.
It requires you to provide the URL of your application running locally.

1.  Navigate to the `~/exercises/assignment-submission` directory in
    terminal 2:

    ```terminal:execute
    command: cd ~/exercises/assignment-submission
    session: 2
    ```

1.  Run the assignment submission command in terminal 2:

    ```terminal:execute
    command: ./gradlew cloudNativeDeveloperK8sBootApp -PserverUrl=http://localhost:8080
    session: 2
    ```

1.  After your assignment submission is complete,
    terminate your spring boot app:

    ```terminal:execute
    command: <ctrl+c>
    session: 1
    ```

# Extra

If you have additional time, explore the dependencies included in the
`spring-boot-starter-web` library.
Go to the main Maven repository for [Spring Boot web starter](https://mvnrepository.com/artifact/org.springframework.boot/spring-boot-starter-web),
find the version you are using, and navigate to its page.
Its immediate dependencies are listed in the _Compile Dependencies_
section.
Try to write the dependencies closure in the `build.gradle` file so that
your application runs without using any starters.

# Resources

- [Spring Initializr](https://start.spring.io)
- [12 factor applications](https://12factor.net)
