import 'package:vania/vania.dart';
import 'package:vania/src/exception/validation_exception.dart';
import 'package:vaniabackend/app/models/orders.dart';

class OrdersController extends Controller {
  Future<Response> index() async {
    return Response.json({'message': 'Hello World'});
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'order_num': 'required',
        'order_date': 'required',
        'cust_id': 'required',
      }, {
        'order_num.required': 'Nomor pesanan wajib diisi.',
        'order_date.required': 'Tanggal pesanan wajib diisi.',
        'cust_id.required': 'ID pelanggan wajib diisi.',
      });

      final orderData = request.input();

      final existingOrder = await Orders()
          .query()
          .where('order_num', '=', orderData['order_num'])
          .first();

      if (existingOrder != null) {
        return Response.json({
          'message': 'Pesanan dengan nomor ini sudah ada.',
        }, 409);
      }

      await Orders().query().insert(orderData);

      return Response.json({
        'message': 'Pesanan berhasil ditambahkan.',
        'data': orderData,
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
      final orders = await Orders().query().get();
      return Response.json({
        'message': 'Daftar Pesanan.',
        'data': orders,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data pesanan.',
        'error': e.toString(),
      }, 500);
    }
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, int orderNum) async {
    try {
      request.validate({
        'order_date': 'required|date',
        'cust_id': 'required|string|max_length:5',
      }, {
        'order_date.required': 'Tanggal pesanan wajib diisi.',
        'order_date.date': 'Tanggal pesanan harus dalam format yang valid.',
        'cust_id.required': 'ID pelanggan wajib diisi.',
        'cust_id.string': 'ID pelanggan harus berupa teks.',
        'cust_id.max_length': 'ID pelanggan maksimal 5 karakter.',
      });

      final orderData = request.input();

      final order =
          await Orders().query().where('order_num', '=', orderNum).first();

      if (order == null) {
        return Response.json({
          'message': 'Pesanan dengan nomor $orderNum tidak ditemukan.',
        }, 404);
      }

      orderData.remove('id');

      await Orders()
          .query()
          .where('order_num', '=', orderNum)
          .update(orderData);

      return Response.json({
        'message': 'Pesanan berhasil diperbarui.',
        'data': orderData,
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

  Future<Response> destroy(Request request, int orderNum) async {
    try {
      final order =
          await Orders().query().where('order_num', '=', orderNum).first();

      if (order == null) {
        return Response.json({
          'message': 'Pesanan dengan nomor $orderNum tidak ditemukan.',
        }, 404);
      }

      await Orders().query().where('order_num', '=', orderNum).delete();

      return Response.json({
        'message': 'Pesanan berhasil dihapus.',
      }, 200);
    } catch (e) {
      // Menangani kesalahan tak terduga
      return Response.json({
        'message': 'Terjadi kesalahan di sisi server. Harap coba lagi nanti.',
      }, 500);
    }
  }
}

final OrdersController ordersController = OrdersController();
