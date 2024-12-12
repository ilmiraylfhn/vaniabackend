import 'package:vania/vania.dart';
import 'package:vaniabackend/app/models/vendors.dart';
import 'package:vania/src/exception/validation_exception.dart';

class VendorsController extends Controller {
  Future<Response> index() async {
    return Response.json({'message': 'Hello World'});
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'vend_id': 'required|string|max_length:5',
        'vend_name': 'required|string|max_length:50',
        'vend_address': 'required|string',
        'vend_kota': 'required|string',
        'vend_state': 'required|string|max_length:5',
        'vend_zip': 'required|string|max_length:7',
        'vend_country': 'required|string|max_length:25',
      }, {
        'vend_id.required': 'ID vendor wajib diisi.',
        'vend_id.string': 'ID vendor harus berupa teks.',
        'vend_id.max_length': 'ID vendor maksimal 5 karakter.',
        'vend_name.required': 'Nama vendor wajib diisi.',
        'vend_name.string': 'Nama vendor harus berupa teks.',
        'vend_name.max_length': 'Nama vendor maksimal 50 karakter.',
        'vend_address.required': 'Alamat vendor wajib diisi.',
        'vend_kota.required': 'Kota vendor wajib diisi.',
        'vend_state.required': 'Provinsi vendor wajib diisi.',
        'vend_state.max_length': 'Provinsi vendor maksimal 5 karakter.',
        'vend_zip.required': 'Kode pos vendor wajib diisi.',
        'vend_zip.max_length': 'Kode pos vendor maksimal 7 karakter.',
        'vend_country.required': 'Negara vendor wajib diisi.',
        'vend_country.max_length': 'Negara vendor maksimal 25 karakter.',
      });

      final vendorData = request.input();

      final existingVendor = await Vendors()
          .query()
          .where('vend_id', '=', vendorData['vend_id'])
          .first();

      if (existingVendor != null) {
        return Response.json({
          'message': 'Vendor dengan ID ini sudah ada.',
        }, 409);
      }

      print('Validasi berhasil, data: $vendorData');

      await Vendors().query().insert(vendorData);

      print('Data berhasil disimpan ke database');

      return Response.json({
        'message': 'Vendor berhasil ditambahkan.',
        'data': vendorData,
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
      final vendors = await Vendors().query().get();
      return Response.json({
        'message': 'Daftar vendor.',
        'data': vendors,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data vendor.',
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
        'vend_name': 'required|string|max_length:50',
        'vend_address': 'required|string',
        'vend_kota': 'required|string|max_length:50',
        'vend_state': 'required|string|max_length:5',
        'vend_zip': 'required|string|max_length:7',
        'vend_country': 'required|string|max_length:25',
      }, {
        'vend_name.required': 'Nama vendor wajib diisi.',
        'vend_name.string': 'Nama vendor harus berupa teks.',
        'vend_name.max_length': 'Nama vendor maksimal 50 karakter.',
        'vend_address.required': 'Alamat vendor wajib diisi.',
        'vend_address.string': 'Alamat vendor harus berupa teks.',
        'vend_kota.required': 'Kota vendor wajib diisi.',
        'vend_kota.string': 'Kota vendor harus berupa teks.',
        'vend_kota.max_length': 'Kota vendor maksimal 50 karakter.',
        'vend_state.required': 'Provinsi vendor wajib diisi.',
        'vend_state.string': 'Provinsi vendor harus berupa teks.',
        'vend_state.max_length': 'Provinsi vendor maksimal 5 karakter.',
        'vend_zip.required': 'Kode pos vendor wajib diisi.',
        'vend_zip.string': 'Kode pos vendor harus berupa teks.',
        'vend_zip.max_length': 'Kode pos vendor maksimal 7 karakter.',
        'vend_country.required': 'Negara vendor wajib diisi.',
        'vend_country.string': 'Negara vendor harus berupa teks.',
        'vend_country.max_length': 'Negara vendor maksimal 25 karakter.',
      });

      final vendorData = request.input();

      final vendor = await Vendors().query().where('vend_id', '=', id).first();

      if (vendor == null) {
        return Response.json({
          'message': 'Vendor dengan ID $id tidak ditemukan.',
        }, 404);
      }

      vendorData.remove('id');

      await Vendors().query().where('vend_id', '=', id).update(vendorData);

      return Response.json({
        'message': 'Vendor berhasil diperbarui.',
        'data': vendorData,
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
      final vendor = await Vendors().query().where('vend_id', '=', id).first();

      if (vendor == null) {
        return Response.json({
          'message': 'Vendor dengan ID $id tidak ditemukan.',
        }, 404);
      }

      await Vendors().query().where('vend_id', '=', id).delete();

      return Response.json({
        'message': 'Vendor berhasil dihapus.',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan di sisi server. Harap coba lagi nanti.',
      }, 500);
    }
  }
}

final VendorsController vendorsController = VendorsController();
