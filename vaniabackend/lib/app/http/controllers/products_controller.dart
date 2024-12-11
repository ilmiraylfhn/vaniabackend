import 'package:vania/vania.dart';
import 'package:vaniabackend/app/models/products.dart';
import 'package:vania/src/exception/validation_exception.dart';

class ProductsController extends Controller {
  Future<Response> index() async {
    return Response.json({'message': 'Hello World'});
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'prod_id': 'required',
        'prod_name': 'required',
        'prod_price': 'required',
        'prod_desc': 'required',
        'vend_id': 'required',
      }, {
        'prod_id.required': 'ID produk wajib diisi.',
        'prod_name.required': 'Nama produk wajib diisi.',
        'prod_price.required': 'Harga produk wajib diisi.',
        'prod_desc.required': 'Deskripsi produk wajib diisi.',
        'vend_id.required': 'ID vendor wajib diisi.',
      });

      final productData = request.input();
      print("Received data: $productData");

      final existingProduct = await Products()
          .query()
          .where('prod_id', '=', productData['prod_id'])
          .first();

      if (existingProduct != null) {
        return Response.json({
          'message': 'Produk dengan ID ini sudah ada.',
        }, 409);
      }

      await Products().query().insert(productData);
      print("Attempting to insert product: $productData");

      return Response.json({
        'message': 'Produk berhasil ditambahkan.',
        'data': productData,
      }, 201);
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack Trace: $stackTrace');

      if (e is ValidationException) {
        return Response.json({
          'errors': e.message,
        }, 400);
      } else {
        return Response.json({
          'message': 'Terjadi kesalahan di sisi server. Harap coba lagi nanti.',
          'error': e.toString(),
        }, 500);
      }
    }
  }

  Future<Response> show() async {
    try {
      final products = await Products().query().get();
      return Response.json({
        'message': 'Daftar produk.',
        'data': products,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data produk.',
        'error': e.toString(),
      }, 500);
    }
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, String id) async {
    try {
      request.validate({
        'prod_name': 'required|string|max_length:50',
        'prod_price': 'required|numeric|min:0',
        'prod_desc': 'required|string',
        'vend_id': 'required|string|max_length:5',
      }, {
        'prod_name.required': 'Nama produk wajib diisi.',
        'prod_name.string': 'Nama produk harus berupa teks.',
        'prod_name.max_length': 'Nama produk maksimal 50 karakter.',
        'prod_price.required': 'Harga produk wajib diisi.',
        'prod_price.numeric': 'Harga produk harus berupa angka.',
        'prod_price.min': 'Harga produk tidak boleh kurang dari 0.',
        'prod_desc.required': 'Deskripsi produk wajib diisi.',
        'prod_desc.string': 'Deskripsi produk harus berupa teks.',
        'vend_id.required': 'ID vendor wajib diisi.',
        'vend_id.string': 'ID vendor harus berupa teks.',
        'vend_id.max_length': 'ID vendor maksimal 5 karakter.',
      });

      final productData = request.input();

      final product =
          await Products().query().where('prod_id', '=', id).first();

      if (product == null) {
        return Response.json({
          'message': 'Produk dengan ID $id tidak ditemukan.',
        }, 404);
      }

      productData.remove('id');

      await Products().query().where('prod_id', '=', id).update(productData);

      return Response.json({
        'message': 'Produk berhasil diperbarui.',
        'data': productData,
      }, 200);
    } catch (e) {
      if (e is ValidationException) {
        final errorMessages = e.message;
        return Response.json({
          'errors': errorMessages,
        }, 400);
      }

      return Response.json({
        'message': 'Terjadi kesalahan di sisi server. Harap coba lagi nanti.',
      }, 500);
    }
  }

  Future<Response> destroy(Request request, String id) async {
    try {
      final product =
          await Products().query().where('prod_id', '=', id).first();

      if (product == null) {
        return Response.json({
          'message': 'Produk dengan ID $id tidak ditemukan.',
        }, 404);
      }

      await Products().query().where('prod_id', '=', id).delete();

      return Response.json({
        'message': 'Produk berhasil dihapus.',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan di sisi server. Harap coba lagi nanti.',
      }, 500);
    }
  }
}

final ProductsController productsController = ProductsController();
