import 'package:vania/vania.dart';

class CreateTasksTable extends Migration {

  @override
  Future<void> up() async{
   super.up();
   await createTableNotExists('tasks', () {
      id();
      integer('user_id');
      string('title'); 
      text('description'); 
      timeStamp('last_used_at', nullable: true);
      timeStamp('created_at', nullable: true);
      timeStamp('deleted_at', nullable: true);

    });
  }
  
  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('tasks');
  }
}
