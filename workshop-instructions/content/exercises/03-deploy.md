# Deploying a Containerized App to Kubernetes

This lab will walk you through how to deploy a containerized app to
Kubernetes.

# Learning Outcomes

After completing the lab, you will be able to:

- Describe the steps to deploy a containerized web app to Kubernetes
- Use `kubectl` to create Kubernetes objects defined in yaml files
- Demonstrate the ability to use the Kubernetes documentation to create object definitions

# Getting started

Review the [Deploy](https://docs.google.com/presentation/d/184YWy6tmtSQ8-bXLw3wdZYcHQEkgW3-cZ3Y7Dqq3rMo/present?slide=id.gb50aa5c946_0_10)
slides or the accompanying *Deploy* lecture.

## Prep your terminals

Make sure you are in your `~/exercises/k8s` directory now in
both of your terminal windows,
and clear both:

```terminal:execute-all
command: cd ~/exercises/k8s
```

```terminal:clear-all
```

## Review the configuration repository

The `~/exercises/k8s` configuration repository will contain a
single `.gitignore` file as
well as the (hidden) git files.

You will be building up the k8s configuration in this directory, and
you are provided reference implementations at each stage identified
by tags in the Git repository.
Take some time to navigate through the tags and branches using the
following command:

```terminal:execute
command: git lola
session: 1
```

# Connect to your Kubernetes cluster

You are provided with a Kubernetes cluster in this course.

You already have a
[Kubernetes namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)
provisioned for you,
and access to it is already configured via your environment's
[kube config file](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/)
located at `$HOME/.kube/config`.

## The Kubernetes command line client

The `kubectl` CLI will be your primary method of interacting with
Kubernetes.
Throughout this class, you will gain a deep understanding of how to
use `kubectl` to create, read, update, delete and debug various
Kubernetes objects.

### Verify access and namespace

To verify that `kubectl` is correctly configured, run the following

```terminal:execute
command: kubectl get all
session: 1
```

This will return all of the Pods, Services, Deployments, and
ReplicaSets in your currently targeted Namespace.
Right now you will probably see an output similar to:

```no-highlight
No resources found in k8s-developer-practices-w01-s002 namespace.
```

-   You have not created any Kubernetes objects yet,
    describing the `No resources found` message.

-   Notice the `k8s-developer-practices-w01-s002` is the namespaces
    of this example -
    you will likely see a different value,
    this is your namespace.

## Namespaces

In this class you are provided a namespace,
and you are not permitted to create others.

In many kubernetes deployments you may have access to create namespaces.

The following are some considerations:

1.  It is common practice to organize your applications, and the
    associated Kubernetes objects, into namespaces other than the
    `default` namespace.
    This allows you to more easily see what Kubernets object are
    related.
    Namespaces also prevent overwriting Kubernetes objects that do not
    belong to your application.
    If you need to target a specific namespace you could do as follows
    (*Do not try this out in your environment, you will get an access*
    *error*):

    ```bash
    command: kubectl config set-context --current --namespace=development
    ```

    If you are running an environment where the namespace has not
    already been created for you and you have authorization to create
    spaces,
    you might do that as follows
    (*Do not try this out in your environment, you will get an access*
    *error*):

    ```bash
    command: kubectl create namespace development
    ```

## Kubernetes resources

You will deploy and configure various types of Kubernetes resources in
this workshop.

Here are some tips:

1.  If you ever forget what objects are available in your cluster, use
    `kubectl api-resources` to see a list.

    ```terminal:execute
    command: kubectl api-resources
    session: 1
    ```

    This list also shows the short names of those resources.
    For example, the short name for `configmaps` is `cm`.
    You can get a list of configmaps in your current namespace by typing
    either `kubectl get configmaps` or `kubectl get cm`.

1.  Ideally you should consider configuring an alias and bash or zsh
    auto-completion for the `kubectl` command.
    You will be running it frequently throughout the course.
    See the
    [Kubernetes cheatsheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/#kubectl-autocomplete)
    for how to set it up in your own environments.
    If you are running on an on-demand or instructor provided
    environment,
    the `kubectl` command is already aliased as `k`,
    with bash auto-completion enabled.

# Deploy your application

You will use a Kubernetes Deployment object to deploy your application
to the cluster.
Kubernetes Deployments define which container image(s) are needed to run
your application.

1.  Inside of the k8s config repo,
    checkout the solution template:

    ```terminal:execute
    command: git checkout deployment-solution deployment.yaml
    session: 2
    ```

1.  Replace the container registry `REGISTRY_HOST` placeholder in the
    `k8s/deployment.yaml` with your container registry:

    ```copy
    {{ registry_host }}
    ```

    Note that the `deployment.yaml` defines the Deployment Kubernetes
    object as well as the Pod object.

1.  Familiarize yourself with the
    [documentation for the Deployment object](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.19/#deployment-v1-apps).
    Make sure you understand each attribute in the Deployment definition.

1.  From the command line, apply your Kubernetes Deployment by running:

    ```terminal:execute
    command: kubectl apply -f deployment.yaml
    session: 1
    ```

1.  To watch your Deployment as the Kubernetes objects are created,
    run:

    ```terminal:execute
    command: kubectl rollout status deployment/pal-tracker --watch
    session: 1
    ```

    This will allow you to see when your `Deployment` is successfully
    deployed.

1.  To see a snapshot of the Kubernetes objects for your
    Deployment, run:

    ```terminal:execute
    command: kubectl get deployments
    session: 1
    ```

    You should see pal-tracker listed as a Deployment.
    Since this is a snapshot you may see that there is a 0 listed under
    the AVAILABLE column, if
    this is the case run `kubectl get deployments` again and wait for
    the Deployment to finish creating and you will see a 1 listed for
    AVAILABLE.

# Verify your Deployment

When applying the Kubernetes Deployment, behind the scenes it creates
a Kubernetes Pod object.
A Pod is a group of containers that are deployed together.
In your case, you are deploying a single container application.

1.  Check on the status of the Pod that was created by running:

    ```terminal:execute
    command: kubectl get pods
    session: 1
    ```

    Under the STATUS column you should see "Running".

1.  Take the Pod name from the previous command, and use it to run:

    ```workshop:copy-and-edit
    text: kubectl describe pod POD-NAME
    session: 1
    ```

    In the output of the above command, you should be able to verify
    that the Pod is running a container using the pal-tracker image you
    published to the container registry.
    If you need to debug any issues,
    take a look at the Events section of the `kubectl describe pod`
    output.

# Access your application

In the output of the `kubectl describe pod`, you might notice that there
is an IP address for the Pod.
Unfortunately this IP address is only accessible from within the
Kubernetes cluster.
In addition your application runs on port 8080 which is by default not
accessible to anyone inside or outside the cluster.
To fix this you will start by creating a Service to allow traffic on
port 8080 to access the Pod, then you will create an Ingress object to
route traffic from outside the cluster to your Pod.

## Create a Kubernetes Service

In Kubernetes, Service objects act as a single point of access for
Pods.
In your case, you want to provide the rest of the cluster access your
Pod via port 8080.

1.  Create a new file called `service.yaml` under the `k8s` directory
    with the following structure:

    ```yaml
    apiVersion:
    kind:
    metadata:
      name:
      labels:
    spec:
      type:
      selector:
      ports:
    ```

1.  Using the documentation for the
    [Service object](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.19/#service-v1-core)
    and the
    [Service reference document](https://kubernetes.io/docs/concepts/services-networking/service/)
    to fill in the values for `apiVersion` and `kind`.
    Note that if the "Group" for the Kubernetes object is `core`, then
    it does not need to be specified in front of the version in
    `apiVersion`.

1.  Provide values for the `metadata` section:

    -   Name the Service object `pal-tracker`.
    -   Set a single label with a key of `app` and a value of
        `pal-tracker`.

1.  Under the `spec` section:

    -   Set the `type` to `ClusterIP`.
    -   Copy the labels applied to your Pod in your `deployment.yaml`
        and paste them under `selector`.
    -   Set the service exposed (incoming) `port` value of `8080`.

        *Note:*

        *The service spec needs to deal with two types of ports:*

        -   *The incoming* `port`,
            *that the service exposes to consumers.*
        -   *The* `targetPort`,
            *the port that the application instances*
            *are set to listen on,*
            *and that the service must know where to connect.*

        *If the* `targetPort` *is not specified,*
        *it defaults to the* `port` *configuration.*
        *Given your app is already configured to run on port* `8080`,
        *and the service exposed `port` is configured to port* `8080`,
        `targetPort` *configuration is not required.*

1.  If you get stuck,
    review the solution:

    ```terminal:execute
    command: git show deployment-solution:service.yaml
    session: 2
    ```

1.  Before applying your `service.yaml`, make sure you understand what
    is happening in this file.

    Pay special attention to the `ports` and the `selector` fields in
    the `service.yaml`.
    Setting a port of 8080 means the Service will listen on port 8080,
    and route requests to the Pod on 8080.

    The `selector` field specifies which Pod(s) requests will be routed
    to.
    You will notice that you do not explicitly set the Pod's name here
    (try running `kubectl get pods` to see your Pod's name).
    Instead you use a selector which matches the labels applied to the
    Pod.
    View the labels applied to your Pod by running
    `kubectl get pods --show-labels`, `kubectl describe pod POD-NAME`, or by
    looking at the labels applied to the Pod under
    `spec.template.metadata.labels` in the `deployment.yaml` file.
    By using labels, your Pod can be destroyed, restarted or scaled and
    the Service will route traffic to whichever Pods match the given
    labels.

1.  Create the Service by applying the change:

    ```terminal:execute
    command: kubectl apply -f service.yaml
    session: 1
    ```

1.  You can verify that the service was created by running:

    ```terminal:execute
    command: kubectl get services
    session: 1
    ```

    In the output you will see the Service you applied.
    You will notice the Service is of TYPE `ClusterIP` and has a
    CLUSTER-IP set.
    Just like the Pod, this Cluster IP address is only accessible from
    within the cluster.
    The next step is to setup an Ingress object to route external
    traffic to your Service, which in turn will route traffic to the Pod
    running your application.

1.  Verify the endpoints, the IP addresses of the pods, by describing
    the `pal-tracker` service:

    ```terminal:execute
    command: kubectl describe service pal-tracker
    session: 1
    ```

### More about Services and Service Types

In this lab you see a Service type of `ClusterIP`.
It is the default way to expose a service,
but only internally to other containers within the cluster.
In the next section you will use an `Ingress` to externalize your
service,
but it is worth mentioning that Kubernetes supports various service
types to expose your services, dependent on specific needs.

You can read about them at the Kubernetes
[`ServiceTypes` reference](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types)
for more information.

## Create a Kubernetes Ingress object

You do this by creating an Kubernetes Ingress object.
Currently you only have one application running on the cluster, so you
can route all traffic to the same place.

1.  Create a new file called `ingress.yaml` under the `k8s` directory.

1.  Refer to the [API documentation](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.19/#ingress-v1-networking-k8s-io)
    and the [Ingress guide](https://kubernetes.io/docs/concepts/services-networking/ingress/)
    to determine what the structure of this file should be.

1.  Set the name of the Ingress object to `pal-tracker`.

1.  Add a single label to the Ingress:

    ```yaml
    app: pal-tracker
    ```

1.  The `defaultBackend` of the Ingress object needs to be tied into the
    ClusterIP Service object you already created.
    Do this by setting the Service name to `pal-tracker` and the Service
    port number to `8080`.

    You can verify that the Service name and the Service Port are
    correct by running `kubectl get services`, or by checking the
    `service.yaml` file for the values under `metadata.name` and
    `spec.ports.port[0]`.

1.  If you get stuck,
    review the solution:

    ```terminal:execute
    command: git show deployment-solution:ingress.yaml
    session: 2
    ```

1.  Create the Ingress object by applying the change using `kubectl`.
    Verify the creation was successful by running `kubectl get ingress`.

    ```terminal:execute
    command: kubectl apply -f ingress.yaml
    session: 1
    ```

    ```terminal:execute
    command: kubectl get ingress
    session: 1
    ```

    ```terminal:execute
    command: kubectl describe ingress/pal-tracker
    session: 1

### Verify access to your application

At this point you have all the parts deployed to access your application.
Access the default backend via both the K8s cluster IP address,
as well as the default domain.

1.  Visit the domain of your cluster using your web browser.
    You will see the `hello` message rendered by your pal-tracker
    application.

    ```dashboard:open-url
    url: http://{{ ingress_domain }}
    ```

    Notice that the default backend does not use host rule to route
    the request to the `pal-tracker` service.

1.  Commit your new Kubernetes manifest yaml files to
    git/GitHub.

    ```terminal:execute
    command: git add *.yaml
    session: 1
    ```

    ```terminal:execute
    command: git commit -m'add k8s deployment resource definitions'
    session: 1
    ```

## Octant

[Octant](https://octant.dev/) gives us a web interface to help inspect our
Kubernetes cluster.
Use __Octant__ to view your Kubernetes cluster.

1.  Navigate to the Console.
    You should see Octant UI.

    ```dashboard:open-dashboard
    name: Console
    ```

1.  Click on the `Namespace Overview` icon in the left vertibal bar.
    (It is the second icon from the top.)
    Here you see all of the objects you have created in the selected
    namespace.
    You can drill into specific objects from this page.

2.  Under `Deployments`, click on the `pal-tracker` deployment.
    This is the `Summary` view for this object.

3.  Select the `Resource Viewer` tab at the top of the page.
    This view shows the object graph associated with the currently
    selected object, the deployment.
    They should all be green.
    If there is a problem with your cluster, this is a good place to
    start troubleshooting.

4.  Drill into your `Pods`, `ReplicaSets`, `Ingresses`, and `Services`.

    - How many Pods are running?
    - What container image is it that is being used?
    - What node is the Pod running on?
    - How can you find this information using the `kubectl` command?

# Submit this assignment

Submit the assignment using the `cloudNativeDeveloperK8sDeployment`
gradle task from within the existing `assignment-submission` project
directory.
It requires you to provide the URL of your application running on
Kubernetes and the name of your Deployment.

1.  Navigate to the `~/exercises/assignment-submission` directory in
    terminal 2:

    ```terminal:execute
    command: cd ~/exercises/assignment-submission
    session: 2
    ```

1.  Run the assignment submission command in terminal 2:

    ```terminal:execute
    command: ./gradlew cloudNativeDeveloperK8sDeployment -PserverUrl=http://{{ ingress_domain }} -PdeploymentName=pal-tracker
    session: 2
    ```

    where `{{ ingress_domain }}` is your domain you visited in step 7 of
    [Create a Kubernetes Ingress object](#create-a-kubernetes-ingress-object)
    section.

# Wrap

Take a few minutes to review the resources you created in this lab
for the
[`pal-tracker` Kubernetes deployment]({{ ingress_protocol }}://{{ session_namespace }}.{{ ingress_domain }}/slides#/deploy-intro)

Notice the relationships between the various resources,
including the metadata and labels.

## Kubernetes clusters and nodes

Take a few minutes to read about
[Kubernetes Clusters and Nodes]({{ ingress_protocol }}://{{ session_namespace }}.{{ ingress_domain }}/slides#/cluster-nodes)

# Learning Outcomes

Now that you have completed the lab, you should be able to:
::learningOutcomes::

# Resources

- [Using Kubeconfig](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/)
- [Namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)
- [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Pod](https://kubernetes.io/docs/concepts/workloads/pods/)
- [Service](https://kubernetes.io/docs/concepts/services-networking/service/)
- [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
- [kubectl cheatsheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
