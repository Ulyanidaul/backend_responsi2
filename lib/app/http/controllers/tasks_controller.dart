import 'dart:io';
import 'package:pert_1_1/app/models/tasks.dart';
import 'package:vania/vania.dart';

class TasksController extends Controller {
  Future<Response> create(Request request) async {
    request.validate({
      'title': 'required',
      'description': 'required',
    }, {
      'title.required': 'Judul tidak boleh kosong',
      'description.required': 'Konten tidak boleh kosong',
    });

    final title = request.input('title');
    final description = request.input('description');

    // Gunakan model Task untuk mengakses tabel
    await Tasks().query().insert({
      'title': title,
      'description': description,
      'created_at': DateTime.now().toIso8601String(),
    });

    return Response.json({"message": "Catatan berhasil dibuat"});
  }

  Future<Response> index(Request request) async {
    final tasks = await Tasks().query().get();

    return Response.json({
      'tasks': tasks.map((task) => {
        'id': task['id'],
        'title': task['title'],
        'description': task['description'],
        'created_at': task['created_at'],
      }).toList(),
    });
  }

  Future<Response> show(Request request) async {
    final id = request.input('id');
    if (id == null) {
      return Response.json({"message": "ID catatan diperlukan"}, HttpStatus.badRequest);
    }

    final task = await Tasks().query().where('id', id).first();
    if (task == null) {
      return Response.json({"message": "Catatan tidak ditemukan"}, HttpStatus.notFound);
    }

    return Response.json({
      'id': task['id'],
      'title': task['title'],
      'description': task['description'],
      'created_at': task['created_at'],
    });
  }

  Future<Response> update(Request request) async {
    final id = request.input('id');  // Mengambil ID dari URL, bukan dari body
    if (id == null) {
      return Response.json({"message": "ID catatan diperlukan"}, HttpStatus.badRequest);
    }

    // Validasi input
    request.validate({
      'title': 'required',
      'description': 'required',
    });

    final title = request.input('title');
    final description = request.input('description');

    final task = await Tasks().query().where('id', id).first();
    if (task == null) {
      return Response.json({"message": "Catatan tidak ditemukan"}, HttpStatus.notFound);
    }

    await Tasks().query().where('id', id).update({
      'title': title,
      'description': description,
      'updated_at': DateTime.now().toIso8601String(),
    });

    return Response.json({"message": "Catatan berhasil diperbarui"});
  }

  Future<Response> delete(Request request) async {
    final id = request.input('id');
    if (id == null) {
      return Response.json({"message": "ID catatan diperlukan"}, HttpStatus.badRequest);
    }

    try {
      await Tasks().query().where('id', id).delete();
      return Response.json({"message": "Catatan berhasil dihapus"});
    } catch (e) {
      return Response.json({"error": e.toString()}, HttpStatus.internalServerError);
    }
  }
}

final TasksController tasksController = TasksController();
