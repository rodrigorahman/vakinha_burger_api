import 'package:mysql1/mysql1.dart';
import 'package:vakinha_burger_api/app/core/database/database.dart';
import 'package:vakinha_burger_api/app/entities/product.dart';

class ProductRepository {
  Future<List<Product>> findAll() async {
    MySqlConnection? conn;

    try {
      conn = await Database().openConnection();
      final result = await conn.query('select * from produto');

      return result
          .map(
            (p) => Product(
              id: p['id'],
              name: p['nome'],
              description: (p['descricao'] as Blob?)?.toString() ?? '',
              price: p['preco'],
              image: (p['imagem'] as Blob?)?.toString() ?? '',
            ),
          )
          .toList();
    } on MySqlException catch (e, s) {
      print(e);
      print(s);
      throw Exception();
    } finally {
      await conn?.close();
    }
  }

  Future<Product> findById(int id) async {
    MySqlConnection? conn;
    try {
      conn = await Database().openConnection();
      final result =
          await conn.query('select * from produto where id = ?', [id]);

      final mysqlData = result.first;

      return Product(
        id: mysqlData['id'],
        name: mysqlData['nome'],
        description: (mysqlData['descricao'] as Blob?)?.toString() ?? '',
        price: mysqlData['preco'],
        image: (mysqlData['imagem'] as Blob?)?.toString() ?? '',
      );
    } on MySqlException catch (e, s) {
      print(e);
      print(s);
      throw Exception();
    } finally {
      await conn?.close();
    }
  }
}
