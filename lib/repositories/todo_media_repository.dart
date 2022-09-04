import 'dart:io';

abstract class TodoMediaRepository {
  Future<String> uploadMedia(File image);
}
