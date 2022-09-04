import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:todo_list/repositories/todo_media_repository.dart';

class TodoMediaFirebaseRepository implements TodoMediaRepository {
  @override
  Future<String> uploadMedia(File image) async {
    final todoMediaRef =
        FirebaseStorage.instance.ref().child("todos/${image.path}");
    final uploadedMedia = await todoMediaRef
        .putFile(image)
        .then((media) => media.ref.getDownloadURL());
    return uploadedMedia;
  }
}
