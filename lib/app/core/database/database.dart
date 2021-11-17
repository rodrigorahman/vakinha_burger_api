import 'package:dotenv/dotenv.dart';
import 'package:mysql1/mysql1.dart';

class Database {
  Future<MySqlConnection> openConnection() async {
    return MySqlConnection.connect(
      ConnectionSettings(
        host: env['DATABASE_HOST'] ?? env['databaseHost'] ?? '',
        port: int.tryParse(env['DATABASE_PORT'] ?? env['databasePort'] ?? '') ??
            3306,
        user: env['DATABASE_USER'] ?? env['databaseUser'],
        password: env['DATABASE_PASSWORD'] ?? env['databasePassword'],
        db: env['DATABASE_NAME'] ?? env['databaseName'],
      ),
    );
  }
}
