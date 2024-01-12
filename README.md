# test-badges

This repo demonstrates how to use [Semantic Versioning](https://semver.org/) and [GitVersion](https://gitversion.net/) in GitHub Actions to create badges for your repos.

| Repository | Version |
| ------------- | ------------- |
| test-badges | [![GitHub Tag](https://img.shields.io/github/v/tag/bindsi/test-badges?logo=github&label=version)](https://github.com/bindsi/test-badges)
 |

## Prerequisites

1. Your repository has to be public.
2. You have to grant `read and write permissions` to your GITHUB_TOKEN by navigating to _Settings_ of your repo, then go to _Actions_ and _General_ and scroll down to _Workflow Persmissions_.

## Getting Started

### Configuration of GitVersion

GitVersion is a tool to help you achieve Semantic Versioning on your project. It uses the commit history to determine the version of your project. In our case it uses tags to determine the version and is configurated in the file [GitVersion.yml](GitVersion.yml).

Add this to the root of your repo and configure it to your needs. For more information on how to configure GitVersion, please refer to the [documentation](https://gitversion.net/docs/).

> **Note:** if you want to update the major or minor version, you can decorate your commit message with the following keywords: `+semver:major` or `+semver:minor`. `+semver:patch` is the default and can be omitted.

### GitHub Actions Workflow

Use the sample workflow [create-tag.yml](.github/workflows/create-tag.yml) in this repo as a template for your own repo. It includes the steps to install and execute GitVersion incrementing the version and create a new tag based on the incremented version using the patter Major.Minor.Patch, e.g. 0.1.0 which is the tag used for the first commit. From the second commit it increments the patch version, e.g. 0.1.1.

> **Note:** if you want to make use of different versioning format, you can use the one of the schemas outlined in the following [example](https://github.com/GitTools/actions/blob/main/docs/examples/github/gitversion/execute/usage-examples.md#example-5).

### Create Badges

There is a great service creating badges for several purposes called [Shields.io](https://shields.io/). Since the versioning in this sample targets the tags of the repo we can utilize the [GitHub tag based badge](https://shields.io/badges/git-hub-tag).
You can configure your badge by using the advanced properties like e.g. the color, the logo, the label and the message.

> **Note:** [GitHub anonymizes the URLs](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/about-anonymized-urls) of the badge and there might be a delay in the update of the badge because of the caching.

The Shields.io service creates the markdown for the badge as well which can be easily used in readme or documentation files like in the table above. This sample also adds a link to the badge image so that you end up on the tags page of the repo when clicking on the badge.
