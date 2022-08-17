import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../../../shared/widgets/notifications.dart';

const _API_KEY_DATIL = "9144f13a90b1494e912466f8a4c3ae9a";
const _API_PASS_DATIL = "Isedonebi2023\$\$";

class ApiDatil {
  // Emite una factura en API de Datil
  static Future<Map> createInvoice(
      {required BuildContext context, required Map data}) async {
    String idInvoice = '';
    Map invoice = {};

    const endPointDatilAPI = 'https://link.datil.co/invoices/issue';

    Map<String, String> headers = {
      // 'Access-Control-Allow-Headers': 'X-Requested-With',
      'Accept': '*/*',
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
      'X-Key': _API_KEY_DATIL,
      'X-Password': _API_PASS_DATIL,
    };

    Uri postUri = Uri.parse(endPointDatilAPI);

    String bodyEncode = json.encode(data);

    // print('bodyEncode> $bodyEncode');
    print('haders> $headers');

    try {
      http.Response response = await http.post(
        postUri,
        headers: headers,
        body: bodyEncode,
      );

      print('response status ${response.statusCode}');

      if (response.statusCode == 200) {
        Notifications.goodNotification(msg: 'Factura generada correctamente');

        Map res = json.decode(response.body);

        idInvoice = res['id'].toString();

        // TODO Api DATIL Autorizar factura SRI
        await autorizationSRIInvoice(context: context, idInvoice: idInvoice);
        invoice =
            await getAutorizationStatus(context: context, idInvoice: idInvoice);
        print('response body $invoice');

        return invoice;
      }
    } on Error catch (e) {
      print('Catch $e');
      Notifications.badNotification(msg: '¡Factura no pudo ser registrada!');
    }
    //  finally {
    //   httpClient.close();
    // }
    return invoice;
  }

  static Future<void> autorizationSRIInvoice(
      {required BuildContext context, required String idInvoice}) async {
    final endPointDatilAPI = 'https://link.datil.co/edocs/$idInvoice/issue';

    Map<String, String> headers = {
      // 'x-key': dotenv.env['API_KEY_DATIL'],
      // 'x-password': dotenv.env['API_PASS_DATIL'],
      'x-key': _API_KEY_DATIL,
      'x-password': _API_PASS_DATIL,
      'content-type': 'application/json'
    };

    Uri postUri = Uri.parse(endPointDatilAPI);

    try {
      http.Response response = await http.post(
        postUri,
        headers: headers,
      );

      // print('Autorization ${response.statusCode}');

      if (response.statusCode == 200) {
        Notifications.goodNotification(msg: 'Factura en revisión por SRI');
        print('Factura en revisión por SRI');
      }
    } catch (e) {
      print('Catch $e');
    }
  }

  static Future<Map> getAutorizationStatus(
      {required BuildContext context, required String idInvoice}) async {
    Map res = {};
    final endPointDatilAPI = 'https://link.datil.co/edocs/$idInvoice';

    Map<String, String> headers = {
      // 'x-key': dotenv.env['API_KEY_DATIL'],
      // 'x-password': dotenv.env['API_PASS_DATIL'],
      'x-key': _API_KEY_DATIL,
      'x-password': _API_PASS_DATIL,
      'content-type': 'application/json'
    };

    Uri postUri = Uri.parse(endPointDatilAPI);

    try {
      http.Response response = await http.get(
        postUri,
        headers: headers,
      );

      if (response.statusCode == 200) {
        res = json.decode(response.body);
      }
    } catch (e) {
      print('Catch $e');
      Notifications.badNotification(msg: 'Error $e');
    }
    return res;
  }

  static Future<Uint8List?> getInvoicePDF(
      {required BuildContext context, required String idInvoice}) async {
    Uint8List? pdf;
    final endPointDatilAPI = 'https://app.datil.co/ver/$idInvoice/pdf';

    Map<String, String> headers = {
      'x-key': _API_KEY_DATIL,
      'x-password': _API_PASS_DATIL,
      'content-type': 'application/json'
    };

    Uri postUri = Uri.parse(endPointDatilAPI);

    try {
      http.Response response = await http.get(
        postUri,
        headers: headers,
      );

      if (response.statusCode == 200) {
        // Map res = json.decode(response.body);
        pdf = base64.decode(response.body);

        // print('Get status Autorization ${res}');
      }
    } catch (e) {
      print('Catch $e');
      Notifications.badNotification(msg: 'Error $e');
    }
    return pdf;
  }
}
