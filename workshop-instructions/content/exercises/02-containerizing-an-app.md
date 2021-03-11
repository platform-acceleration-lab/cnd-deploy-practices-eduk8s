# Containerizing an App

This lab will walk you through how to containerize an application.
You will be using Gradle task provided by Spring Boot Plugin to
generate container image.
Behind the scene, the Gradle task uses [Buildpacks](https://buildpacks.io/).
Once you have built your container image, you will test it using Docker.

# Learning Outcomes

After completing the lab, you will be able to:

-   Describe how to generate a runnable
    container image for your application

-   Explain how to publish an image to a
    Container registry

# Getting started

Make sure you are in your `~/exercises/pal-tracker` directory now in
both of your terminal windows,
and clear both:

```terminal:execute-all
command: cd ~/exercises/pal-tracker
```

```terminal:clear-all
```

# Use Buildpacks to containerize your app

To generate container images, you will be using a Gradle task.

1.  From the root of your application, use the `bootBuildImage` task to
    generate a runnable container image for your application.
    (It might take about a minute or so for the task to finish.)

    ```terminal:execute
    command: ./gradlew bootBuildImage
    session: 1
    ```

1.  Once the `bootBuildImage` task finishes, verify that an image was
    generated and is listed in your locally available Docker images.
    Run the following command and look for an image named `pal-tracker`.

    ```terminal:execute
    command: docker images
    session: 1
    ```

1.  Run your image using `docker` and expose port 8080 where your
    application is listening.

    ```terminal:execute
    command: docker run --rm -p 8080:8080 pal-tracker
    session: 1
    ```

1.  In the console output, you should see Spring Boot starting up your
    application.
    Once it is running,
    from a separate terminal window execute a request:

    ```terminal:execute
    command: curl -v http://localhost:8080
    session: 2
    ```

    You should see your `hello` message.

1.  Terminate the application:

    ```terminal:execute
    command: <ctrl+c>
    session: 1
    ```

# Container registry

Next you will want to publish your images to a container registry where
other people and systems can pull them down to run locally.
For this lab, you will use a container registry provided to you,
but you could (in theory) use any container registry.

Examples of other container registries are
[Harbor](https://goharbor.io/),
[Github Container Registry](https://docs.github.com/en/packages/guides/about-github-container-registry),
[Amazon Elastic Container Registry](https://aws.amazon.com/ecr/),
[Google Container Registry](https://cloud.google.com/container-registry),
and
[Docker Hub](https://docker.io).
Ideally you should use a private registry unless you are building open
source projects.

You do not need to explicitly login to the container registry provided
to you.
Your docker client is already set to a private container registry
provided in your lab environment.

# Publish your image

You are now ready to publish your image to your container registry.

1.  Start by tagging your image with your container registry,
    and a version.

    ```terminal:execute
    command: docker tag pal-tracker {{ registry_host }}/pal-tracker:v0
    session: 1
    ```

1.  Push your image to your container registry:

    ```terminal:execute
    command: docker push {{ registry_host }}/pal-tracker:v0
    session: 1
    ```

# Submit this assignment

Submit the assignment using the
`cloudNativeDeveloperK8sContainerizingAnApp` gradle task from within the
existing `assignment-submission` project directory.
It requires you to provide the name of your container registry.

1.  Navigate to the `~/exercises/assignment-submission` directory in
    terminal 2:

    ```terminal:execute
    command: cd ~/exercises/assignment-submission
    session: 2
    ```

1.  Run the assignment submission command in terminal 2:

    ```terminal:execute
    command: ./gradlew cloudNativeDeveloperK8sContainerizingAnApp -Prepository={{ registry_host }}/pal-tracker
    session: 2
    ```

# Learning Outcomes

Now that you have completed the lab, you should be able to:

-   Describe how to generate a runnable
    container image for your application

-   Explain how to publish an image to a
    Container registry

# Resources

- [Containerizing Spring Boot Apps](https://docs.spring.io/spring-boot/docs/2.3.2.RELEASE/reference/html/spring-boot-features.html#boot-features-container-images)
- [Buildpack Author’s Guide](https://buildpacks.io/docs/buildpack-author-guide/)
- [Container Images](https://kubernetes.io/docs/concepts/containers/images/)
