# Introduction

[![Build Status](https://dev.azure.com/ai-at-the-edge-flagship-accelerator/IaC%20for%20the%20Edge/_apis/build/status%2FIaC%20for%20the%20Edge?branchName=main)](https://dev.azure.com/ai-at-the-edge-flagship-accelerator/IaC%20for%20the%20Edge/_build/latest?definitionId=3&branchName=main)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE.md)
[![Board Status](https://dev.azure.com/ai-at-the-edge-flagship-accelerator/3bef5a01-44ac-4d6c-8c8d-f4b7d374def6/8567de21-1286-4352-a375-efb89ad55348/_apis/work/boardbadge/fd9375f1-e7c6-4439-b2c9-6969d853a2d4)](https://dev.azure.com/ai-at-the-edge-flagship-accelerator/3bef5a01-44ac-4d6c-8c8d-f4b7d374def6/_boards/board/t/8567de21-1286-4352-a375-efb89ad55348/Stories/)
[![Open in Dev Containers](https://img.shields.io/static/v1?label=Dev%20Containers&message=Open&color=blue&logo=visualstudiocode)](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://dev.azure.com/ai-at-the-edge-flagship-accelerator/_git/IaC%20for%20the%20Edge)

The IaC for Edge project, the first phase of ISE's "AI on Edge" Flagship Accelerator, will deliver a compiler
generator that outputs composable IaC. The IaC compiler/generator can grow with a customer's capabilities from
innovative POCs and onto production system deployments. This solution will generate all the foundational cloud
and edge solution components required to implement a “vision on edge” solution using Azure IoT Operations (AIO).

The IaC compiler/generator supports Terraform and Bicep outputs for base infrastructure and can interface with
a limited selection of GitOps toolchains for core AIO components and custom customer workload deployment.
Pre-built VM and cloud-hosted cluster setup scripts are also output from the generator, however the project
only supports a very narrow set of configurations (Ubuntu & K3s clusters).

Initial runs of the generator tool will generate a full Arc-enabled, cloud-hosted development cluster with a
basic AIO deployment [Phases 1 through 7 below](#composable-layers). After that, annotations and naming
conventions can be used to generate any set or sub-set of IaC for a target environment and reclassify elements
for inclusion in alternate layers of the output IaC.

Customers often approach with a wide variety of teams, roles and responsibilities to develop cloud-enabled edge
computing solutions. There are often physical plant IT teams responsible for hardware through OSes at the edge,
and enterprise IT responsible for cloud infrastructure deployment. There are teams managing cloud data estates,
and specialist teams managing physical plant data systems. There are Data Science teams that often span edge
and cloud and need to think of both edge and cloud environments in a unified (i.e. more uniform) way. This tool
is built to directly address these constraints, and is positioned to accelerate customers through the POC phase
with opinionated IaC, and the flexibility to grow and evolve IaC approaches to accommodate increasing solution
complexity.

In the future, this generator tool will provide extensible (though custom component integration) GitOps outputs
for AIO components and custom workloads, initially supporting Argo CD, Flux and Kalypso.

## Composable Layers

The IaC compiler/generator supports the following fine-grained output layers (though these layers can be
flattened into larger chucks to fit a customer's operational model):

1. (000) Run-once scripts for Arc & AIO resource provider enablement in subscriptions, if necessary
2. (005) Resource Groups, Site Management (optional), Role assignments/permissions for Arc onboarding
3. (010) VM/host provisioning, with configurable host operating system (initially limited to Ubuntu)
4. (020) Installation of a CNCF cluster that is AIO compatible (initially limited to K3s) and Arc enablement of target clusters, workload identity, and OTEL collector
5. (030) Cloud resource provisioning for Azure Key Vault, Storage Accounts, Container Registry, and User Assigned Managed Identity
6. (040) AIO deployment of core infrastructure components (MQ Broker, Edge Storage Accelerator, Data Flow, Secretes Sync Controller, Workload Identity Federation, and Schema Registry)
7. (050) Cloud resource provisioning for cloud communication (MQTT protocol head for Event Grid (topic spaces, topics and cert-based authentication), Event Hubs, Service Bus, Relay, etc.)
8. (060) Cloud resource provisioning for data/event storage (Fabric by means of RTI, Data Lakes, Warehouses, etc.)
9. (070) Cloud resource provisioning for Azure Monitor and Container Insights
10. (080) AIO deployment of additionally selected components (OTEL Collector (Phase 2), OPC UA, AKRI, Strato, FluxCD/Argo)
11. (090) Customer defined custom workloads, and pre-built solution accelerators such as TIG/TICK stacks, InfluxDB Data Historian, reference data backup from cloud to edge, etc.

## Target Environments

IaC compiler/generator output can be further tuned for the following environments:

* Local Dev
* Cloud-hosted development clusters (initial scope)
* On-premises physical lab clusters
* Cloud-hosted QA clusters
* Cloud-hosted integration clusters
* Cloud-hosted pre-production
* Edge-hosted production
* Cloud-hosted production

## Getting Started

While the IaC generator tool is under development, users can still use the IaC direction and get started quickly by:

1. Cloning this repository locally (this solution is not available via package distribution - please consider updating all dependencies after cloning and file issues if challenges are encountered)
2. Following our [README.md](src/README.md) files in `/src` directory to provision a cloud-hosted, simulated edge cluster.

### Supported Features

The Terraform, scripts, and documentation in this repository can provide you the following features and capabilities:

* Subscription resources to support all "in-the-box" components of an Azure IoT Operations (AIO) solution
* Deployment of a cloud-hosted VM, sized and provisioned specifically for developing AIO solutions
* Deployment of a development-ready K3s cluster with all the basic AIO components installed
* [Integrated support for Azure Managed Identities](./src/010_cluster_install/terraform/README.md)
* [Integrated support for "Bring-Your-Own" certificates](./src/020_aio_install/terraform/README.md#create_resources) (and intermediate certificates) for intra-cluster TLS
* [A robust, matrix'ed IaC build system](./azure-pipelines.yml) with integrated testing and validation, to ensure your IaC deploys as you expect it to
* Auto-validation and auto-generation of Terraform Plans to support expedited CISO/Security/DevOps team approvals
* [A library of common "Architectural Decision Records" (ARDs)](./Solution%20ADR%20Library/README.md), ready to be modified to document your solution's requirements and the decisions you've made along the way
* [A library of technology papers](./Solution%20Technology%20Paper%20Library/README.md) to upskill your peers
* [A well-stocked development container](./.devcontainer) for you to take the IaC for your "AI on the Edge Solutions" to production with confidence, repeatability, and reliability your organization deserves

Happy Developing!
ISE's AI on the Edge Accelerator Team

## Build and Test

Currently, this repository only supports linting and Terraform validation/plans for the included IaC. We
recommend using the project's [dev container](./.devcontainer/README.md) for all contribution work. Please
refer to the project's [Azure Pipeline](./azure-pipelines.yml) to see the PR and `main` branch build approaches.

## ADR Process

All design decisions for project direction, feature or capability implementation, and community decisions
happen through an Architecture Decision Record (ADR) process. ADRs can be drafted by any project community
member for consideration first by project leads, and secondarily by the project's community. Final ADR
acceptance is performed via sign-off from 3/5ths of the project's leads: Technical Lead (Bill Berry), Product
Owner (Larry Lieberman), Technical Program Manager (Mack Renard), Consulting cross-domain Architect (Paul
Bower), and Architect (Tim Park).

ARDs move through a process that includes the following states:

* Draft - for all ADRs under development and in a drafting phase. May be committed to the main branch directly by project leads, but must be done via branches for community members
* Proposed - for all ADRs that have been reviewed by the ADR sign-off team (project leads), this phase indicates the ADR is now open for discussion amongst the broad project community for feedback.
* Accepted - for all ADRs that have completed the community RFC process. ADRs in this state have been ratified/accepted by the project community and may move to implementation.
* Deprecated - for all ADRs that are no longer relevant to the solution or have been superseded by more comprehensive ADRs; this is inclusive of retired components or features, but will be retained in perpetuity for historical context.

Please see [ADR README](./Project%20ADRs/README.MD) for a more detailed explanation of the ADR process flow and how to author and progress your ideas for this project, through to implementation.

## Contribute

Before contributing, please review the project's [Code of Conduct](./CODE_OF_CONDUCT.md).

Users and project developers can contribute to make this solution better in several ways:

* [Review the project's Contributing doc](./CONTRIBUTING.md)
* [Contribute an ADR](./Solution%20ADR%20Library/README.md#contribute) from your engagement
* [Contribute a Security Plan](./Solution%20Security%20Plan%20Library//README.md#contribute) from your engagement
* [Find a user story or task from the backlog](https://dev.azure.com/ai-at-the-edge-flagship-accelerator/IaC%20for%20the%20Edge/_sprints/taskboard/IaC%20for%20the%20Edge%20Team/IaC%20for%20the%20Edge/IaC%20for%20Chevron/) and help move the accelerator forward
