import 'package:vania/vania.dart';
import 'package:vaniabackend/app/models/orderitems.dart';
import 'package:vania/src/exception/validation_exception.dart';

class OrderItemsController extends Controller {
  Future<Response> index() async {
    return Response.json({'message': 'Hello World'});
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'order_item': 'required|integer|max_length:11',
        'order_num': 'required|integer|max_length:11',
        'prod_id': 'required|string|max_length:10',
        'quantity': 'required|integer|min:1',
        'size': 'required|integer|min:1',
      }, {
        'order_item.required': 'ID item pesanan wajib diisi.',
        'order_item.integer': 'ID item pesanan harus berupa angka.',
        'order_item.max_length': 'ID item pesanan maksimal 11 karakter.',
        'order_num.required': 'Nomor pesanan wajib diisi.',
        'order_num.integer': 'Nomor pesanan harus berupa angka.',
        'order_num.max_length': 'Nomor pesanan maksimal 11 karakter.',
        'prod_id.required': 'ID produk wajib diisi.',
        'prod_id.string': 'ID produk harus berupa teks.',
        'prod_id.max_length': 'ID produk maksimal 10 karakter.',
        'quantity.required': 'Jumlah produk wajib diisi.',
        'quantity.integer': 'Jumlah produk harus berupa angka.',
        'quantity.min': 'Jumlah produk harus lebih dari 0.',
        'size.required': 'Ukuran produk wajib diisi.',
        'size.integer': 'Ukuran produk harus berupa angka.',
        'size.min': 'Ukuran produk harus lebih dari 0.',
      });

      final orderItemData = request.input();

      final existingOrderItem = await Orderitems()
          .query()
          .where('order_item', '=', orderItemData['order_item'])
          .first();

      if (existingOrderItem != null) {
        return Response.json({
          'message': 'Item pesanan dengan ID ini sudah ada.',
        }, 409);
      }

      await Orderitems().query().insert(orderItemData);

      return Response.json({
        'message': 'Item pesanan berhasil ditambahkan.',
        'data': orderItemData,
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
      final orderitems = await Orderitems().query().get();
      return Response.json({
        'message': 'Daftar Item Pesanan.',
        'data': orderitems,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data item pesanan.',
        'error': e.toString(),
      }, 500);
    }
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, int orderItem) async {
    try {
      request.validate({
        'order_num': 'required|integer',
        'prod_id': 'required|string|max_length:10',
        'quantity': 'required|integer|min:1',
        'size': 'required|integer|min:1',
      }, {
        'order_num.required': 'Nomor pesanan wajib diisi.',
        'order_num.integer': 'Nomor pesanan harus berupa angka.',
        'prod_id.required': 'ID produk wajib diisi.',
        'prod_id.string': 'ID produk harus berupa teks.',
        'prod_id.max_length': 'ID produk maksimal 10 karakter.',
        'quantity.required': 'Jumlah produk wajib diisi.',
        'quantity.integer': 'Jumlah produk harus berupa angka.',
        'quantity.min': 'Jumlah produk minimal 1.',
        'size.required': 'Ukuran produk wajib diisi.',
        'size.integer': 'Ukuran produk harus berupa angka.',
        'size.min': 'Ukuran produk minimal 1.',
      });

      final orderItemData = request.input();

      final orderItemRecord = await Orderitems()
          .query()
          .where('order_item', '=', orderItem)
          .first();

      print(orderItemData);

      if (orderItemRecord == null) {
        return Response.json({
          'message': 'Item pesanan dengan ID $orderItem tidak ditemukan.',
        }, 404);
      }

      orderItemData.remove('id');

      await Orderitems()
          .query()
          .where('order_item', '=', orderItem)
          .update(orderItemData);

      return Response.json({
        'message': 'Item pesanan berhasil diperbarui.',
        'data': orderItemData,
      }, 200);
    } catch (e) {
      if (e is ValidationException) {
        return Response.json({
          'errors': e.message,
        }, 400);
      }

      return Response.json({
        'message': 'Terjadi kesalahan di sisi server. Harap coba lagi nanti.',
      }, 500);
    }
  }

  Future<Response> destroy(Request request, int orderItem) async {
    try {
      final orderItemRecord = await Orderitems()
          .query()
          .where('order_item', '=', orderItem)
          .first();

      if (orderItemRecord == null) {
        return Response.json({
          'message': 'Item pesanan dengan ID $orderItem tidak ditemukan.',
        }, 404);
      }

      await Orderitems().query().where('order_item', '=', orderItem).delete();

      return Response.json({
        'message': 'Item pesanan berhasil dihapus.',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan di sisi server. Harap coba lagi nanti.',
      }, 500);
    }
  }
}

final OrderItemsController orderItemsController = OrderItemsController();
