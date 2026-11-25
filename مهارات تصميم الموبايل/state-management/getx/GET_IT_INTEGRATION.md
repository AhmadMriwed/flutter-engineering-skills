# GetIt and GetX integration

Register repository and data-source interfaces and shared services in [GetIt](../../dependency-injection/get_it/GET_IT.md). The GetPage binding calls locator for those dependencies and Get.lazyPut for the controller. The associated GetView and Obx read the controller and its observables. Keep constructor seams available for tests.

On route close, dispose timers, listeners, form resources and owned streams in onClose. Route disposal must not close shared services. A shell controller may coordinate shared state, with explicit session reset for identity-specific data. If a registered service exposes an Rx or stream, subscribe through the appropriate UI/controller mechanism and release the subscription with the consumer. See the [complete binding example](../../architecture/profiles/feature-first/examples/TASKS_FEATURE.md).
