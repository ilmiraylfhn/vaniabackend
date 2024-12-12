import 'package:vania/vania.dart';
import 'package:vaniabackend/app/models/productnotes.dart';
import 'package:vania/src/exception/validation_exception.dart';

class ProductNotesController extends Controller {
  // Get all product notes
  Future<Response> index() async {
    return Response.json({'message': 'List of product notes'});
  }

  Future<Response> create() async {
    return Response.json({'message': 'Show create product note form'});
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'note_id': 'required|string|max_length:5',
        'prod_id': 'required|string|max_length:10',
        'note_date': 'required|date',
        'note_text': 'required|string',
      }, {
        'note_id.required': 'ID catatan wajib diisi.',
        'prod_id.required': 'ID produk wajib diisi.',
        'prod_id.string': 'ID produk harus berupa teks.',
        'prod_id.max_length': 'ID produk maksimal 10 karakter.',
        'note_date.required': 'Tanggal catatan wajib diisi.',
        'note_date.date': 'Tanggal catatan harus berupa tanggal.',
        'note_text.required': 'Teks catatan wajib diisi.',
        'note_text.string': 'Teks catatan harus berupa teks.',
      });

      final noteData = request.input();

      final existingNote = await Productnotes()
          .query()
          .where('note_id', '=', noteData['note_id'])
          .first();

      if (existingNote != null) {
        return Response.json({
          'message': 'Catatan dengan ID ini sudah ada.',
        }, 409);
      }

      await Productnotes().query().insert(noteData);

      return Response.json({
        'message': 'Catatan produk berhasil ditambahkan.',
        'data': noteData,
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
      final productNotes = await Productnotes().query().get();
      return Response.json({
        'message': 'Daftar catatan produk.',
        'data': productNotes,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data catatan produk.',
        'error': e.toString(),
      }, 500);
    }
  }

  Future<Response> update(Request request, String noteId) async {
    try {
      request.validate({
        'prod_id': 'required|string|max_length:10',
        'note_date': 'required|date',
        'note_text': 'required|string',
      }, {
        'prod_id.required': 'ID produk wajib diisi.',
        'prod_id.string': 'ID produk harus berupa teks.',
        'prod_id.max_length': 'ID produk maksimal 10 karakter.',
        'note_date.required': 'Tanggal catatan wajib diisi.',
        'note_date.date': 'Tanggal catatan harus berupa tanggal yang valid.',
        'note_text.required': 'Teks catatan wajib diisi.',
        'note_text.string': 'Teks catatan harus berupa teks.',
      });

      final noteData = request.input();

      final productNote =
          await Productnotes().query().where('note_id', '=', noteId).first();

      if (productNote == null) {
        return Response.json({
          'message': 'Catatan produk dengan ID $noteId tidak ditemukan.',
        }, 404);
      }

      print(noteData);
      noteData.remove('id');

      await Productnotes()
          .query()
          .where('note_id', '=', noteId)
          .update(noteData);

      return Response.json({
        'message': 'Catatan produk berhasil diperbarui.',
        'data': noteData,
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
      final productNote =
          await Productnotes().query().where('note_id', '=', id).first();

      if (productNote == null) {
        return Response.json({
          'message': 'Catatan produk dengan ID $id tidak ditemukan.',
        }, 404);
      }

      await Productnotes().query().where('note_id', '=', id).delete();

      return Response.json({
        'message': 'Catatan produk berhasil dihapus.',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan di sisi server. Harap coba lagi nanti.',
      }, 500);
    }
  }
}

final ProductNotesController productNotesController = ProductNotesController();
