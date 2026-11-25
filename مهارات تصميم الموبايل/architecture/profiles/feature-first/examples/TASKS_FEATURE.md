# Portable Tasks feature

## Purpose and scope

A neutral GET/list, GET/detail, POST/create, PUT/edit example. It includes debounced search, status filter, page metadata, a Load more action, pull to refresh, typed errors, route bindings, independent controllers and English/Arabic UI. The example API is an illustrative contract. Use a matching mock server or adapt the data source to a confirmed API.

## Setup and contract

After approval of the reference profile combination, start with the [bootstrap guide](../GETX_BOOTSTRAP.md). Copy the labeled Dart files into a Flutter app, then add these packages to its pubspec. Configure Android Internet permission in the main manifest for release networking. Start with `flutter run --dart-define=API_ORIGIN=<trusted HTTPS origin>`. Locale follows the OS with an English fallback. Local storage, token auth and notifications are outside this example's contract.

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  dio: ^5.9.2
  flutter_screenutil: ^5.9.3
  get: ^4.7.3
  get_it: ^9.2.1
```

The example uses Dart ^3.11.1 as in the source. Keep the next-page value strictly increasing. The sample exposes public endpoints and receives a record directly on detail and save.

| Operation | Input | Success response |
| --- | --- | --- |
| GET /tasks | page starts at 1, optional q and completed | Object with items array and next_page integer or null |
| GET /tasks/{id} | non-empty record ID | A task |
| POST /tasks | title string and completed boolean | A task with an assigned ID |
| PUT /tasks/{id} | title string and completed boolean | The updated task |

```json
{"items":[{"id":"1","title":"Review the outline","completed":false}],"next_page":2}
```

## File layout

```text
lib/app.dart
lib/core/domain/error_handler/network_exceptions.dart
lib/core/domain/services/api_service.dart
lib/core/domain/services/api_services_impl.dart
lib/core/routes/app_pages.dart
lib/core/routes/app_routes.dart
lib/core/utils/app_url.dart
lib/data/datasource/configuration/locator.dart
lib/data/datasource/remote/api_response.dart
lib/features/tasks/binding/task_detail_binding.dart
lib/features/tasks/binding/task_editor_binding.dart
lib/features/tasks/binding/tasks_binding.dart
lib/features/tasks/controller/task_detail_controller.dart
lib/features/tasks/controller/task_editor_controller.dart
lib/features/tasks/controller/task_load_state.dart
lib/features/tasks/controller/tasks_controller.dart
lib/features/tasks/data/models/task.dart
lib/features/tasks/data/models/task_input.dart
lib/features/tasks/data/models/task_page.dart
lib/features/tasks/data/remote/tasks_remote_data_source.dart
lib/features/tasks/data/remote/tasks_remote_data_source_impl.dart
lib/features/tasks/data/repository/tasks_repository_impl.dart
lib/features/tasks/domain/repository/tasks_repository.dart
lib/features/tasks/pages/task_detail_page.dart
lib/features/tasks/pages/task_editor_page.dart
lib/features/tasks/pages/tasks_page.dart
lib/features/tasks/widgets/tasks_list.dart
lib/locale/task_translations.dart
lib/main.dart
```

The list owns search, filter, refresh and append. Detail receives an ID and fetches its own snapshot. The form receives that snapshot for edit, or starts empty for add. A successful save returns true through the navigation stack and reloads the list. This sample exits details after a successful edit to show the refreshed list.

## Copyable files

### `lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'app.dart';
import 'data/datasource/configuration/locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const TasksApp());
}
```

### `lib/app.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'locale/task_translations.dart';

class TasksApp extends StatelessWidget {
  const TasksApp({super.key});

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
    designSize: const Size(390, 844),
    minTextAdapt: true,
    builder: (_, _) => GetMaterialApp(
      translations: TaskTranslations(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      initialRoute: AppRoutes.tasks,
      getPages: AppPages.pages,
    ),
  );
}
```

### `lib/core/routes/app_routes.dart`

```dart
abstract final class AppRoutes {
  static const tasks = '/tasks';
  static const taskDetail = '/task-detail';
  static const taskEditor = '/task-editor';
}
```

### `lib/core/routes/app_pages.dart`

```dart
import 'package:get/get.dart';
import '../../features/tasks/binding/tasks_binding.dart';
import '../../features/tasks/binding/task_detail_binding.dart';
import '../../features/tasks/binding/task_editor_binding.dart';
import '../../features/tasks/pages/tasks_page.dart';
import '../../features/tasks/pages/task_detail_page.dart';
import '../../features/tasks/pages/task_editor_page.dart';
import 'app_routes.dart';

abstract final class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.tasks, page: TasksPage.new, binding: TasksBinding()),
    GetPage(name: AppRoutes.taskDetail, page: TaskDetailPage.new, binding: TaskDetailBinding()),
    GetPage(name: AppRoutes.taskEditor, page: TaskEditorPage.new, binding: TaskEditorBinding()),
  ];
}
```

### `lib/core/utils/app_url.dart`

```dart
abstract final class AppUrl {
  static const tasks = '/tasks';
  static String task(String id) => '$tasks/${Uri.encodeComponent(id)}';
}
```

### `lib/core/domain/services/api_service.dart`

```dart
abstract interface class ApiServices {
  Future<Object?> get(String path, {Map<String, Object?>? query});
  Future<Object?> post(String path, Map<String, Object?> body);
  Future<Object?> put(String path, Map<String, Object?> body);
}
```

### `lib/core/domain/services/api_services_impl.dart`

```dart
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'api_service.dart';

class ApiServicesImpl implements ApiServices {
  ApiServicesImpl(this._dio);
  final Dio _dio;

  Options get _options => Options(headers: {
    'Accept': 'application/json',
    'Accept-Language': Get.locale?.languageCode ?? 'en',
  });

  @override
  Future<Object?> get(String path, {Map<String, Object?>? query}) async =>
    (await _dio.get<Object?>(path, queryParameters: query, options: _options)).data;

  @override
  Future<Object?> post(String path, Map<String, Object?> body) async =>
    (await _dio.post<Object?>(path, data: body, options: _options)).data;

  @override
  Future<Object?> put(String path, Map<String, Object?> body) async =>
    (await _dio.put<Object?>(path, data: body, options: _options)).data;
}
```

### `lib/core/domain/error_handler/network_exceptions.dart`

```dart
import 'package:dio/dio.dart';

enum NetworkExceptions {
  connection, timeout, unauthorized, notFound, validation, unexpected;

  static NetworkExceptions getException(Object error) {
    if (error is NetworkExceptions) return error;
    if (error is! DioException) return unexpected;
    return switch (error.type) {
      DioExceptionType.connectionError => connection,
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => timeout,
      _ => switch (error.response?.statusCode) {
        401 || 403 => unauthorized,
        404 => notFound,
        422 => validation,
        _ => unexpected,
      },
    };
  }

  String get key => 'error.$name';
}
```

### `lib/data/datasource/remote/api_response.dart`

```dart
import '../../../core/domain/error_handler/network_exceptions.dart';

class ApiResponse<T> {
  const ApiResponse.success(T data) : _data = data, _error = null;
  const ApiResponse.failure(NetworkExceptions error) : _data = null, _error = error;
  final T? _data;
  final NetworkExceptions? _error;

  R when<R>({required R Function(T) success, required R Function(NetworkExceptions) failure}) {
    final error = _error;
    return error == null ? success(_data as T) : failure(error);
  }
}
```

### `lib/features/tasks/data/models/task.dart`

```dart
class Task {
  const Task({required this.id, required this.title, required this.completed});
  final String id;
  final String title;
  final bool completed;

  factory Task.fromJson(Map<String, Object?> json) => Task(
    id: json['id'] as String,
    title: json['title'] as String,
    completed: json['completed'] as bool,
  );
}
```

### `lib/features/tasks/data/models/task_page.dart`

```dart
import 'task.dart';

class TaskPage {
  const TaskPage(this.items, this.nextPage);
  final List<Task> items;
  final int? nextPage;

  factory TaskPage.fromJson(Map<String, Object?> json) {
    final rows = json['items'] as List;
    return TaskPage(
      List.unmodifiable(rows.map((row) => Task.fromJson(row as Map<String, Object?>))),
      json['next_page'] as int?,
    );
  }
}
```

### `lib/features/tasks/data/models/task_input.dart`

```dart
class TaskInput {
  const TaskInput(this.title, this.completed);
  final String title;
  final bool completed;

  Map<String, Object?> toJson() => {'title': title, 'completed': completed};
}
```

### `lib/features/tasks/data/remote/tasks_remote_data_source.dart`

```dart
import '../models/task.dart';
import '../models/task_input.dart';
import '../models/task_page.dart';

abstract interface class TasksRemoteDataSource {
  Future<TaskPage> list(String query, bool? completed, int page);
  Future<Task> detail(String id);
  Future<Task> save(TaskInput input, {String? id});
}
```

### `lib/features/tasks/data/remote/tasks_remote_data_source_impl.dart`

```dart
import '../../../../core/domain/services/api_service.dart';
import '../../../../core/utils/app_url.dart';
import '../models/task.dart';
import '../models/task_input.dart';
import '../models/task_page.dart';
import 'tasks_remote_data_source.dart';

class TasksRemoteDataSourceImpl implements TasksRemoteDataSource {
  TasksRemoteDataSourceImpl(this._api);
  final ApiServices _api;

  @override
  Future<TaskPage> list(String query, bool? completed, int page) async {
    final data = await _api.get(AppUrl.tasks, query: {
      'page': page,
      if (query.isNotEmpty) 'q': query,
      if (completed != null) 'completed': completed,
    });
    return TaskPage.fromJson(data as Map<String, Object?>);
  }

  @override
  Future<Task> detail(String id) async {
    final data = await _api.get(AppUrl.task(id));
    return Task.fromJson(data as Map<String, Object?>);
  }

  @override
  Future<Task> save(TaskInput input, {String? id}) async {
    final data = id == null
      ? await _api.post(AppUrl.tasks, input.toJson())
      : await _api.put(AppUrl.task(id), input.toJson());
    return Task.fromJson(data as Map<String, Object?>);
  }
}
```

### `lib/features/tasks/domain/repository/tasks_repository.dart`

```dart
import '../../../../data/datasource/remote/api_response.dart';
import '../../data/models/task.dart';
import '../../data/models/task_input.dart';
import '../../data/models/task_page.dart';

abstract interface class TasksRepository {
  Future<ApiResponse<TaskPage>> list(String query, bool? completed, int page);
  Future<ApiResponse<Task>> detail(String id);
  Future<ApiResponse<Task>> save(TaskInput input, {String? id});
}
```

### `lib/features/tasks/data/repository/tasks_repository_impl.dart`

```dart
import '../../../../core/domain/error_handler/network_exceptions.dart';
import '../../../../data/datasource/remote/api_response.dart';
import '../../domain/repository/tasks_repository.dart';
import '../models/task.dart';
import '../models/task_input.dart';
import '../models/task_page.dart';
import '../remote/tasks_remote_data_source.dart';

class TasksRepositoryImpl implements TasksRepository {
  TasksRepositoryImpl(this._remote);
  final TasksRemoteDataSource _remote;

  Future<ApiResponse<T>> _request<T>(Future<T> Function() call) async {
    try {
      return ApiResponse.success(await call());
    } catch (error) {
      return ApiResponse.failure(NetworkExceptions.getException(error));
    }
  }

  @override
  Future<ApiResponse<TaskPage>> list(String query, bool? completed, int page) =>
    _request(() => _remote.list(query, completed, page));

  @override
  Future<ApiResponse<Task>> detail(String id) => _request(() => _remote.detail(id));

  @override
  Future<ApiResponse<Task>> save(TaskInput input, {String? id}) =>
    _request(() => _remote.save(input, id: id));
}
```

### `lib/data/datasource/configuration/locator.dart`

```dart
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../core/domain/services/api_service.dart';
import '../../../core/domain/services/api_services_impl.dart';
import '../../../features/tasks/data/remote/tasks_remote_data_source.dart';
import '../../../features/tasks/data/remote/tasks_remote_data_source_impl.dart';
import '../../../features/tasks/data/repository/tasks_repository_impl.dart';
import '../../../features/tasks/domain/repository/tasks_repository.dart';

final locator = GetIt.instance;

void setupLocator() {
  const origin = String.fromEnvironment('API_ORIGIN');
  final uri = Uri.tryParse(origin);
  if (uri == null || uri.scheme != 'https' || uri.host.isEmpty ||
      uri.userInfo.isNotEmpty || uri.hasQuery || uri.hasFragment ||
      (uri.path.isNotEmpty && uri.path != '/')) {
    throw StateError('Provide a trusted HTTPS origin through API_ORIGIN.');
  }
  locator.registerLazySingleton<Dio>(() => Dio(BaseOptions(
    baseUrl: origin,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  )));
  locator.registerLazySingleton<ApiServices>(() => ApiServicesImpl(locator()));
  locator.registerLazySingleton<TasksRemoteDataSource>(() => TasksRemoteDataSourceImpl(locator()));
  locator.registerLazySingleton<TasksRepository>(() => TasksRepositoryImpl(locator()));
}
```

### `lib/features/tasks/controller/task_load_state.dart`

```dart
enum TaskLoadState { initial, loading, success, empty, failure }
```

### `lib/features/tasks/controller/tasks_controller.dart`

```dart
import 'dart:async';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../data/models/task.dart';
import '../domain/repository/tasks_repository.dart';
import 'task_load_state.dart';

class TasksController extends GetxController {
  TasksController(this._repository);
  final TasksRepository _repository;
  final tasks = <Task>[].obs;
  final state = TaskLoadState.initial.obs;
  final refreshing = false.obs;
  final appending = false.obs;
  final error = RxnString();
  final appendError = RxnString();
  final hasMore = false.obs;
  Timer? _debounce;
  String _query = '';
  bool? _completed;
  int _generation = 0;
  int? _next;

  @override
  void onReady() {
    super.onReady();
    unawaited(refresh());
  }

  void search(String text) {
    final query = text.trim();
    if (query == _query) return;
    _query = query;
    _debounce?.cancel();
    _generation++;
    _next = null;
    hasMore.value = false;
    appending.value = false;
    appendError.value = null;
    _debounce = Timer(const Duration(milliseconds: 300), refresh);
  }

  void filter(String value) {
    _completed = switch (value) { 'open' => false, 'done' => true, _ => null };
    unawaited(refresh());
  }

  Future<void> refresh() async {
    _debounce?.cancel();
    final generation = ++_generation;
    _next = null;
    hasMore.value = false;
    appending.value = false;
    appendError.value = null;
    error.value = null;
    refreshing.value = true;
    if (tasks.isEmpty) state.value = TaskLoadState.loading;
    try {
      final result = await _repository.list(_query, _completed, 1);
      if (isClosed || generation != _generation) return;
      result.when<void>(
        success: (page) {
          tasks.assignAll({for (final item in page.items) item.id: item}.values);
          _setNext(page.nextPage, 1);
          state.value = tasks.isEmpty ? TaskLoadState.empty : TaskLoadState.success;
        },
        failure: (failure) {
          error.value = failure.key;
          state.value = tasks.isEmpty ? TaskLoadState.failure : TaskLoadState.success;
        },
      );
    } finally {
      if (!isClosed && generation == _generation) refreshing.value = false;
    }
  }

  Future<void> loadMore() async {
    final pageNumber = _next;
    if (pageNumber == null || refreshing.value || appending.value) return;
    final generation = _generation;
    appending.value = true;
    appendError.value = null;
    try {
      final result = await _repository.list(_query, _completed, pageNumber);
      if (isClosed || generation != _generation) return;
      result.when<void>(
        success: (page) {
          tasks.assignAll({
            for (final item in tasks) item.id: item,
            for (final item in page.items) item.id: item,
          }.values);
          _setNext(page.nextPage, pageNumber);
          state.value = tasks.isEmpty ? TaskLoadState.empty : TaskLoadState.success;
        },
        failure: (failure) => appendError.value = failure.key,
      );
    } finally {
      if (!isClosed && generation == _generation) appending.value = false;
    }
  }

  void _setNext(int? next, int current) {
    _next = next != null && next > current ? next : null;
    hasMore.value = _next != null;
  }

  Future<void> open(Task task) async {
    final changed = await Get.toNamed<bool>(AppRoutes.taskDetail, arguments: task.id);
    if (changed == true && !isClosed) await refresh();
  }

  Future<void> create() async {
    final changed = await Get.toNamed<bool>(AppRoutes.taskEditor);
    if (changed == true && !isClosed) await refresh();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}
```

### `lib/features/tasks/controller/task_detail_controller.dart`

```dart
import 'dart:async';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../data/models/task.dart';
import '../domain/repository/tasks_repository.dart';

class TaskDetailController extends GetxController {
  TaskDetailController(this._repository, this.id);
  final TasksRepository _repository;
  final String? id;
  final task = Rxn<Task>();
  final error = RxnString();
  final loading = false.obs;

  @override
  void onReady() {
    super.onReady();
    unawaited(load());
  }

  Future<void> load() async {
    final taskId = id;
    if (taskId == null) {
      error.value = 'error.notFound';
      return;
    }
    if (loading.value) return;
    loading.value = true;
    error.value = null;
    try {
      final result = await _repository.detail(taskId);
      if (isClosed) return;
      result.when<void>(
        success: (value) => task.value = value,
        failure: (value) => error.value = value.key,
      );
    } finally {
      if (!isClosed) loading.value = false;
    }
  }

  Future<void> edit(Task task) async {
    final changed = await Get.toNamed<bool>(AppRoutes.taskEditor, arguments: task);
    if (changed == true && !isClosed) Get.back<bool>(result: true);
  }
}
```

### `lib/features/tasks/controller/task_editor_controller.dart`

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../data/models/task.dart';
import '../data/models/task_input.dart';
import '../domain/repository/tasks_repository.dart';

class TaskEditorController extends GetxController {
  TaskEditorController(this._repository, this.initial)
    : title = TextEditingController(text: initial?.title),
      completed = (initial?.completed ?? false).obs;

  final TasksRepository _repository;
  final Task? initial;
  final TextEditingController title;
  final RxBool completed;
  final form = GlobalKey<FormState>();
  final saving = false.obs;
  final error = RxnString();

  String? validateTitle(String? value) =>
    (value ?? '').trim().isEmpty ? 'tasks.titleRequired'.tr : null;

  Future<void> save() async {
    if (saving.value || form.currentState?.validate() != true) return;
    saving.value = true;
    error.value = null;
    try {
      final result = await _repository.save(
        TaskInput(title.text.trim(), completed.value), id: initial?.id,
      );
      if (isClosed) return;
      result.when<void>(
        success: (_) {
          if (Get.currentRoute == AppRoutes.taskEditor) Get.back<bool>(result: true);
        },
        failure: (value) => error.value = value.key,
      );
    } finally {
      if (!isClosed) saving.value = false;
    }
  }

  @override
  void onClose() {
    title.dispose();
    super.onClose();
  }
}
```

### `lib/features/tasks/binding/tasks_binding.dart`

```dart
import 'package:get/get.dart';
import '../../../data/datasource/configuration/locator.dart';
import '../controller/tasks_controller.dart';

class TasksBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(() => TasksController(locator()));
}
```

### `lib/features/tasks/binding/task_detail_binding.dart`

```dart
import 'package:get/get.dart';
import '../../../data/datasource/configuration/locator.dart';
import '../controller/task_detail_controller.dart';

class TaskDetailBinding extends Bindings {
  @override
  void dependencies() {
    final arguments = Get.arguments;
    Get.lazyPut(() => TaskDetailController(locator(), arguments is String ? arguments : null));
  }
}
```

### `lib/features/tasks/binding/task_editor_binding.dart`

```dart
import 'package:get/get.dart';
import '../../../data/datasource/configuration/locator.dart';
import '../controller/task_editor_controller.dart';
import '../data/models/task.dart';

class TaskEditorBinding extends Bindings {
  @override
  void dependencies() {
    final arguments = Get.arguments;
    Get.lazyPut(() => TaskEditorController(locator(), arguments is Task ? arguments : null));
  }
}
```

### `lib/features/tasks/pages/tasks_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/tasks_controller.dart';
import '../widgets/tasks_list.dart';

class TasksPage extends GetView<TasksController> {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('tasks.title'.tr)),
    floatingActionButton: FloatingActionButton(
      onPressed: controller.create,
      tooltip: 'tasks.add'.tr,
      child: const Icon(Icons.add),
    ),
    body: SafeArea(
      child: Column(
        children: [
          TextField(
            onChanged: controller.search,
            decoration: InputDecoration(labelText: 'tasks.search'.tr),
          ),
          DropdownButtonFormField<String>(
            initialValue: 'all',
            decoration: InputDecoration(labelText: 'tasks.filter'.tr),
            items: [
              for (final value in ['all', 'open', 'done'])
                DropdownMenuItem(value: value, child: Text('tasks.$value'.tr)),
            ],
            onChanged: (value) {
              if (value != null) controller.filter(value);
            },
          ),
          Expanded(child: TasksList(controller: controller)),
        ],
      ),
    ),
  );
}
```

### `lib/features/tasks/widgets/tasks_list.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/task_load_state.dart';
import '../controller/tasks_controller.dart';

class TasksList extends StatelessWidget {
  const TasksList({super.key, required this.controller});
  final TasksController controller;

  @override
  Widget build(BuildContext context) => Obx(() {
    final state = controller.state.value;
    final tasks = controller.tasks.toList(growable: false);
    final error = controller.error.value;
    final appendError = controller.appendError.value;
    final hasMore = controller.hasMore.value;
    final appending = controller.appending.value;
    if (state == TaskLoadState.initial || state == TaskLoadState.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: ListView.builder(
        padding: EdgeInsetsDirectional.only(bottom: 72.h),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: tasks.length + 2,
        itemBuilder: (_, index) {
          if (index == 0) {
            if (error != null) {
              return ListTile(
                title: Text(error.tr),
                trailing: TextButton(onPressed: controller.refresh, child: Text('tasks.retry'.tr)),
              );
            }
            if (state == TaskLoadState.empty) {
              return ListTile(title: Text('tasks.empty'.tr));
            }
            return const SizedBox.shrink();
          }
          if (index == tasks.length + 1) {
            if (appending) return const Center(child: CircularProgressIndicator());
            if (!hasMore) return const SizedBox.shrink();
            return ListTile(
              subtitle: appendError == null ? null : Text(appendError.tr),
              title: TextButton(
                onPressed: controller.loadMore,
                child: Text((appendError == null ? 'tasks.more' : 'tasks.retry').tr),
              ),
            );
          }
          final task = tasks[index - 1];
          return ListTile(
            key: ValueKey(task.id),
            title: Text(task.title),
            subtitle: Text((task.completed ? 'tasks.done' : 'tasks.open').tr),
            onTap: () => controller.open(task),
          );
        },
      ),
    );
  });
}
```

### `lib/features/tasks/pages/task_detail_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/task_detail_controller.dart';

class TaskDetailPage extends GetView<TaskDetailController> {
  const TaskDetailPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('tasks.details'.tr)),
    body: Obx(() {
      final task = controller.task.value;
      final error = controller.error.value;
      if (error != null) {
        return ListTile(
          title: Text(error.tr),
          trailing: controller.id == null
            ? null
            : TextButton(onPressed: controller.load, child: Text('tasks.retry'.tr)),
        );
      }
      if (task == null || controller.loading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return ListView(children: [
        ListTile(
          title: Text(task.title),
          subtitle: Text((task.completed ? 'tasks.done' : 'tasks.open').tr),
        ),
        TextButton(onPressed: () => controller.edit(task), child: Text('tasks.edit'.tr)),
      ]);
    }),
  );
}
```

### `lib/features/tasks/pages/task_editor_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/task_editor_controller.dart';

class TaskEditorPage extends GetView<TaskEditorController> {
  const TaskEditorPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text((controller.initial == null ? 'tasks.add' : 'tasks.edit').tr)),
    body: SafeArea(
      child: Obx(() {
        final saving = controller.saving.value;
        final error = controller.error.value;
        return PopScope(
          canPop: !saving,
          child: Form(
            key: controller.form,
            child: ListView(children: [
              TextFormField(
                controller: controller.title,
                enabled: !saving,
                decoration: InputDecoration(labelText: 'tasks.name'.tr),
                validator: controller.validateTitle,
              ),
              SwitchListTile(
                title: Text('tasks.done'.tr),
                value: controller.completed.value,
                onChanged: saving ? null : (value) => controller.completed.value = value,
              ),
              if (error != null) ListTile(title: Text(error.tr)),
              FilledButton(
                onPressed: saving ? null : controller.save,
                child: saving
                  ? const CircularProgressIndicator()
                  : Text('tasks.save'.tr),
              ),
            ]),
          ),
        );
      }),
    ),
  );
}
```

### `lib/locale/task_translations.dart`

```dart
import 'package:get/get.dart';

class TaskTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': {
      'tasks.title': 'Tasks',
      'tasks.add': 'Add task',
      'tasks.edit': 'Edit task',
      'tasks.details': 'Task details',
      'tasks.search': 'Search tasks',
      'tasks.filter': 'Status',
      'tasks.all': 'All',
      'tasks.open': 'Open',
      'tasks.done': 'Completed',
      'tasks.name': 'Title',
      'tasks.save': 'Save',
      'tasks.titleRequired': 'Enter a title',
      'tasks.empty': 'No matching tasks',
      'tasks.retry': 'Retry',
      'tasks.more': 'Load more',
      'error.connection': 'Check your connection',
      'error.timeout': 'The request timed out',
      'error.unauthorized': 'Access denied',
      'error.notFound': 'Task unavailable',
      'error.validation': 'Check the task details',
      'error.unexpected': 'Something went wrong',
    },
    'ar': {
      'tasks.title': 'المهام',
      'tasks.add': 'إضافة مهمة',
      'tasks.edit': 'تعديل المهمة',
      'tasks.details': 'تفاصيل المهمة',
      'tasks.search': 'البحث في المهام',
      'tasks.filter': 'الحالة',
      'tasks.all': 'الكل',
      'tasks.open': 'مفتوحة',
      'tasks.done': 'مكتملة',
      'tasks.name': 'العنوان',
      'tasks.save': 'حفظ',
      'tasks.titleRequired': 'أدخل عنوانًا',
      'tasks.empty': 'لا توجد مهام مطابقة',
      'tasks.retry': 'إعادة المحاولة',
      'tasks.more': 'عرض المزيد',
      'error.connection': 'تحقق من الاتصال',
      'error.timeout': 'انتهت مهلة الطلب',
      'error.unauthorized': 'الوصول مرفوض',
      'error.notFound': 'المهمة غير متاحة',
      'error.validation': 'تحقق من تفاصيل المهمة',
      'error.unexpected': 'حدث خطأ',
    },
  };
}
```

## Verification

Use a fake repository in controller tests and use the documented fixture in a mock server for API smoke tests. Exercise a blank form, a 422 with valid form fields, loading and retry, an empty filter, two out-of-order list responses, duplicate IDs across pages, failure to append, and a save followed by a refreshed list. Test both locale directions and confirm the keyboard leaves the form scrollable.

Source examples for the patterns include Search's query generation and bindings, Orders' incremental loads, and the separate address form controller. The API contract, names and code here are original to this example.
