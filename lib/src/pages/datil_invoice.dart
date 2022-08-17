import 'package:flutter/material.dart';

import '../../services/APIs/datil-api/api_datil.dart';
import '../../shared/widgets/notifications.dart';

class DatilInvoicePage extends StatefulWidget {
  DatilInvoicePage({Key? key}) : super(key: key);

  static const routeName = '/datil';

  @override
  State<DatilInvoicePage> createState() => _DatilInvoicePageState();
}

class _DatilInvoicePageState extends State<DatilInvoicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datil Invoice Page'),
      ),
      floatingActionButton: IconButton(
        icon: const Icon(
          Icons.edit_note_rounded,
          color: Colors.greenAccent,
        ),
        onPressed: _createInvoice,
      ),
    );
  }

  Future<void> _createInvoice() async {
    Map<String, dynamic> factura = {
      "ambiente": 1,
      "tipo_emision": 1,
      "secuencial": 40,
      "fecha_emision": "2022-08-09T11:10:44.221Z",
      "moneda": "USD",
      "emisor": {
        "ruc": "1793189991001",
        "razon_social": "Isedone S.A.S.",
        "nombre_comercial": "Isedone",
        "direccion": "Los Cardenales y N Pichincha",
        "contribuyente_especial": "",
        "obligado_contabilidad": false,
        "establecimiento": {
          "punto_emision": "002",
          "codigo": "001",
          "direccion": "Los Cardenales y N"
        }
      },
      "comprador": {
        "razon_social": "Cristhian Apolo Cevallos",
        "email": "caapolo@ecx-labs.com",
        "identificacion": "1103987259",
        "tipo_identificacion": "05",
        "direccion": "Tebaida Baja",
        "telefono": "+593987634216"
      },
      "items": [
        {
          "descripcion": "Plan III",
          "codigo_principal": "Codigo Plan",
          "codigo_auxiliar": "Codigo auxiliar Plan",
          "unidad_medida": "Unidad",
          "cantidad": 1,
          "precio_unitario": 17.59,
          "descuento": 0,
          "precio_total_sin_impuestos": 17.59,
          "impuestos": [
            {
              "base_imponible": 17.59,
              "valor": 2.4,
              "tarifa": 12,
              "codigo": "2",
              "codigo_porcentaje": "2"
            }
          ]
        }
      ],
      "totales": {
        "total_sin_impuestos": 17.59,
        "impuestos": [
          {
            "base_imponible": 17.59,
            "valor": 2.4,
            "codigo": "2",
            "codigo_porcentaje": "2"
          }
        ],
        "importe_total": 19.99,
        "propina": 0,
        "descuento": 0
      },
      "valor_retenido_iva": 0,
      "valor_retenido_renta": 0,
      "pagos": [
        {
          "fecha": "2022-08-09T11:10:44.221Z",
          "medio": "tarjeta_credito",
          "total": 19.99,
          "notas": "Compra con tarjeta de crédito",
          "propiedades": {
            "tarjeta": "AmericanExpress",
            "número": "370000000000002"
          }
        }
      ]
    };

    // TODO Api DATIL Generar factura electrocnica
    Map invoice = await ApiDatil.createInvoice(context: context, data: factura);
    print('invoice $invoice');

    if (invoice.isNotEmpty) {
      Notifications.goodNotification(msg: 'Facturación correcta.');
    } else {
      Notifications.badNotification(msg: 'Error en la facturación');
    }
  }
}
