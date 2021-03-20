# README

Welcome to the Developer Cloud Native Deployment practices workshop.

This page is for maintainers,
not for students.

Before getting into the workshop series,
it is necessary to outline the structure of this project.

## Deploy

The `deploy` directory contains convenience scripts to help the
developer/maintainer with local development builds.


See the
[Authoring / Maintaining](#authoring--maintaining) section for
recommended maintainer workflows.

## Workshop

The workshop contains one or more lessons and associated lab exercises
the fit together,
and can be executed by a user within 2 hours.

Each workshop is built as a separate container,
and contains a "bootstrap" script that will set the state of the user's
development environment before starting the workshop session.

The workshop contains the instruction content for the user:

### Overview

The [Intro](./workshop/content/intro.md) file is the overview page -
it is the "home page" of the workshop.

### Exercises

The bulk of the workshop is to guide the user through 1 or more lab
exercises.

Each exercise will add, update or remove code or configuration
artifacts,
and result in one of the various configurations of a cloud native app
running in a Kubernetes cluster to demonstrate a development or
operator concept.

## Building

### Development environment

The development workflow is based on [https://github.com/vmware-tanzu-private/edu-educates-template].

See that repo for pre-requisites and description of commands.

### Running workshop

1. `make`

1. Navigate to the Training Portal URL displayed in the terminal.

## Authoring / Maintaining

Authoring is the process of updating the workshop content,
code,
or workshop configuration.

### Flow

There are a few scenarios common with authoring:

1. Lab code/configuration updates
1. Lab instruction updates
1. Slide narrative updates
1. Training portal or workshop configuraton changes
1. A combination of the 4

The first two can be accomplished by the following steps:

1.  Make the appropriate content changes,
    either in the markdown files,
    or code.

1.  Test locally by reloading the workshop:

    ```bash
    make reload
    ```

1. Re-navigate to the link from the terminal window.

### Lessons

The [workshop content](./workshop/content) contains all the meat of the
course,
lab instructions.

### Solution

The [exercises directory](./exercises) contains the following:

-   `smoke-tests` directory contains the exercise smoke test
    project.

-   `pal-tracker` directory contains the application source code
-   `k8s` directory contains the deployment resource configurations.

## Deployment steps to ESP staging educates cluster

1.  Acquire access to [VMware Cloud Services](https://console.cloud.vmware.com/)

    -   Check that you have access to the organization named `GTIX-VES`
    -   If not: email [Maria Blagoeva](mailto:mblagoeva@vmware.com) and
        request access to ESP staging educates clusters

1.  Download K8s configuration file

    -   Click the `VMware Tanzu Mission Control` (TMC) service
    -   In the TMC, in the list of clusters, select the cluster named `kube-test-a351ffe`
    -   In the upper left hand corner, under "actions", select "access this cluster"
    -   Download the kubeconfig file

1.  Configure K8s locally: Execute following commands in a terminal window

    -   export KUBECONFIG=<path-to-kubeconfig-file>
    -   kubectl config view

1.  Get TMC API Token

    -    Go to [VMware Cloud Services](https://console.cloud.vmware.com/)
    -    Click on "My Account" from the profile pulldown
    -    Select the tab "API Tokens" and generate yourself a token
    -    Give a Token name and select "All Roles" under "Define Scopes" pane
    -    Do "export TMC_API_TOKEN=<Your API Token>"

2.  Download and install Tanzu Mission Control CLI ("tmc")

    -   Follow the [instruction](https://docs.vmware.com/en/VMware-Tanzu-Mission-Control/services/tanzumc-using/GUID-7EEBDAEF-7868-49EC-8069-D278FD100FD9.html?hWord=N4IghgNiBcIC4FsDGIC+Q)

Now you should be able to deploy workshops, trainingportals, etc.. per the educates documentation.

## Known issues

### Kubernetes cannot pull from container registry (minikube)

Make sure you have configured the `--insecure-registry` flag to the
correct subnet associated with your minikube installation.

You can verify the minikube ip address:

```bash
minikube ip
```

If you misconfigured the flag,
delete your minikube cluster and recreate with the correct value.

### Workshop does not deploy, workhop namespace does not terminate

You are attempting to update a workspace configuration,
but it is not accessible through the training portal.

1.  Verify the workhop session pods can pull the image during the
    initialization of a workshop session:

    ```bash
    kubectl get po -A --field-selector metadata.namespace!=kube-system -w
    ```

    Watch for pod creation:

    ```no-highlight

    ```

1.  Verify you have no orphaned or dangling workshop sessions:

    ```bash
    kubectl get workshopsessions
    ```

    Delete orphaned workshop session(s):

    ```bash
    kubectl delete workshopsession/<workshopsession name>
    ```
