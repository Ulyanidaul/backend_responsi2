import 'dart:io';

import 'package:pert_1_1/app/models/user.dart';
import 'package:vania/vania.dart';

class AuthController extends Controller {
  // Register method
  Future<Response> register(Request request) async {
    request.validate({
      'name': 'required',
      'email': 'required | email',
      'password': 'required|min_length:6|confirmed',
    }, {
      'name.required': 'nama tidak boleh kosong',
      'email.required': 'email tidak bole kosong',
      'email.email': 'email tidak valid',
      'password.required': 'password tidak boleh kosong',
      'password.min_length': 'password harus terdiri dari minimal 6 karakter',
      'password.confirmed': 'konfirmasi password tidak sesuai',
    });

    final name = request.input('name');
    final email = request.input('email');
    var password = request.input('password').toString();

    var user = await User().query().where('email', '=', email).first();
    if (user != null) {
      return Response.json({
        "message": "user sudah ada",
      }, 409);
    }

    password = Hash().make(password);
    await User().query().insert({
      "name": name,
      "email": email,
      "password": password,
      "created_at": DateTime.now().toIso8601String(),
    });

    return Response.json({"message": "berhasil mendaftarkan user"});
  }

  // Login method tanpa token
  Future<Response> login(Request request) async {
    request.validate({
      'email': 'required | email',
      'password': 'required|min_length:6',
    }, {
      'email.required': 'email tidak boleh kosong',
      'email.email': 'email tidak valid',
      'password.required': 'password tidak boleh kosong',
    });

    final email = request.input('email');
    var password = request.input('password').toString();

    var user = await User().query().where('email', '=', email).first();
    if (user == null) {
      return Response.json({
        "message": "user belum terdaftar",
      }, HttpStatus.unauthorized);
    }

    if (!Hash().verify(password, user['password'])) {
      return Response.json({
        "message": "kata sandi yang anda masukan salah",
      }, 401);
    }

    // Kembalikan respons login berhasil tanpa token
    return Response.json({
      "message": "berhasil login",
    });
  }
}

final AuthController authController = AuthController();
