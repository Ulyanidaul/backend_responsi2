import 'package:pert_1_1/app/http/controllers/auth_controller.dart';
import 'package:pert_1_1/app/http/controllers/tasks_controller.dart';
import 'package:pert_1_1/app/http/controllers/user_controller.dart';
import 'package:vania/vania.dart';

class ApiRoute implements Route {
  @override
  void register() {
    /// Base RoutePrefix
    Router.basePrefix('api');

    Router.group(() {
      Router.post('register', authController.register);
      Router.post('login', authController.login);
    }, prefix: 'auth');

    Router.group(() {
      Router.get('/notes', tasksController.index);
      Router.post('/notes', tasksController.create);
      Router.put('/notes/{id}', tasksController.update);
      Router.delete('/notes/{id}', tasksController.delete);
    });

    Router.group(() {
      Router.get('me', userController.index);
    }, prefix: 'user', middleware: [Authenticate()]);
  }
}
