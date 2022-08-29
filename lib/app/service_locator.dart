import 'package:get_it/get_it.dart';
import 'package:todo_list/repositories/todo_firebase_repository.dart';
import 'package:todo_list/repositories/todo_repository.dart';
import 'package:todo_list/repositories/todolist_firebase_repository.dart';
import 'package:todo_list/repositories/todolist_repository.dart';
import 'package:todo_list/services/todo_service.dart';
import 'package:todo_list/services/todolist_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Repositories
  getIt.registerSingleton<TodoRepository>(TodoFirebaseRepository());
  getIt.registerSingleton<TodoListRepository>(TodoListFirebaseRepository());

  // Services
  getIt.registerSingleton<TodoListService>(TodoListService(
    todolistRepository: getIt<TodoListRepository>(),
  ));
  getIt.registerSingleton<TodoService>(TodoService(
    todoRepository: getIt<TodoRepository>(),
  ));
}
