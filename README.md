# 🐙 Octopod ![Octopod Docker Image](https://github.com/typeable/octopod/workflows/Octopod%20Docker%20Image/badge.svg?branch=master) ![octo CLI](https://github.com/typeable/octopod/workflows/octo%20CLI/badge.svg?branch=master) ![Documentation](https://github.com/typeable/octopod/workflows/Documentation/badge.svg?branch=master)

_Octopod_ is a fully open-source self-hosted solution for managing multiple deployments in a _Kubernetes_ cluster with a user-friendly web interface. Managing deployments does not require any technical expertise.

We created _Octopod_ because we believe that everything we release should be rigorously tested, however, such desires greatly [complicate the development workflow](docs/en/PM_case_study.md) leading to longer release cycles. We use _Octopod_ to mitigate the downsides of rigorously testing each feature by deploying every single change we make to a separate staging environment allowing QA to investigate each feature independently and in parallel.

## 🖥 Demo

<p align="center"><img src="img/demo.gif"></img></p>

## 📑 Documentation

### 🔭 High-level notes
- [🐙 Overview](docs/en/Overview.md)
- [🧑‍🔬 Project managment case study](docs/en/PM_case_study.md)
- [🧑‍💻 Technical case study](docs/en/Tech_case_study.md)

### 🛠️ Technical documentation
- [🏗 Technical architecture](docs/en/Technical_architecture.md) [[RU](docs/ru/Technical_architecture.md)]
- [⚙️ Control script guide](docs/en/Control_scripts.md) [[RU](docs/ru/Control_scripts.md)]
- [🔧🐙 Octopod deployment guide](docs/en/Octopod_deployment_guide.md) [[RU](docs/ru/Octopod_deployment_with_K8S.md)]
- [🔧🚀 Helm-based Octopod project setup](docs/en/Helm-based_deployment_guide.md) [[RU](docs/ru/Helm-based_deployment_guide.md)]
- [🐙🎛 octo CLI user guide](docs/en/Octo_user_guide.md)  [[RU](docs/ru/Octo_user_guide.md)]
- [🤖 CI integration](docs/en/Integration.md)
- [🔒 Octopod security model](docs/en/Security_model.md)  [[RU](docs/ru/Security_model.md)]

## ℹ️ FAQ

### How long does it take to set up _Octopod_?

The longest part of setting up _Octopod_ for your project will probably be writing [_Control Scripts_](docs/en/Control_scripts.md). In total you should be able to get things running in about a day.

### Will _Octopod_ work with my project if it uses X?

Yes. _Octopod_ is project-agnostic. If you can run your project in a Docker container, then you can use _Octopod_ with that project.

### What do I need to know to set up Octopod?

You need to understand the basics of _Kubernetes_ and be familiar with whatever hosting provider you will be using. There is no need to know any special language – you can write [_Control Scripts_](docs/en/Control_scripts.md) in whatever language you like.

### Does _Octopod_ work with my CI?

Yes. If you can run arbitrary executables in your CI, then you will be able to integrate it with _Octopod_. Integration basically consists of calling our _octo CLI_ tool to perform desired actions. You can find more detail in the [CI integration](docs/en/Integration.md) doc.

### How come I can't see the deployment logs in Octopod web app?

It's been excluded from the GUI because we don't have a good security story to accompany this feature yet. Some secret and credentials may leak to the project team using Octopod and, potentially, not everyone should have access to this data.

### Why Haskell and Rust?

We believe that there is a lot to be gained in programming in general by being able to statically ensure invariants in your code. One of the most practical ways of ensuring invariants is a good static type system. Haskell and Rust are both languages that have very strong type systems. This allows us to move fast without breaking things in the process.

<p align="center"><a href="https://typeable.io"><img src="img/typeable.png" width="177px"></img></a></p>
