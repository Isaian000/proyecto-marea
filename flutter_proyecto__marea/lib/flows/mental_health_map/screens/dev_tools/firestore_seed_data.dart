import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedJaliscoCareCenters(FirebaseFirestore firestore) async {
  final centers = [
    {
      'id': 'salme_zapopan',
      'name': 'Instituto Jalisciense de Salud Mental (SALME)',
      'address': 'Av. Zoquipan 1000-A, Zoquipan, 45170 Zapopan, Jal.',
      'phone': '33 9689 2834',
      'lat': 20.7286,
      'lng': -103.3865,
    },
    {
      'id': 'dif_zapopan_psicologia',
      'name': 'Atención Psicológica - DIF Zapopan',
      'address': 'Zapopan, Jalisco',
      'phone': '33 3836 3457',
      'lat': 20.7214,
      'lng': -103.3918,
    },
    {
      'id': 'sap_guadalajara',
      'name': 'Servicios de Atención Psicológica (SAP) - Guadalajara',
      'address': 'Dirección Municipal de Salud, Guadalajara, Jal.',
      'phone': '33 3669 1324',
      'lat': 20.6767,
      'lng': -103.3475,
    },
    {
      'id': 'dif_jalisco_familia',
      'name': 'Clínica de Asistencia Psicológica a la Familia - DIF Jalisco',
      'address': 'Guadalajara / Zona Metropolitana, Jalisco',
      'phone': '33 3624 4154',
      'lat': 20.6650,
      'lng': -103.3560,
    },
    {
      'id': 'modulo_guadalajara_1',
      'name': 'Módulo de Salud Mental Guadalajara 1',
      'address': 'Av. San Rafael 403, Col. La Paz, Guadalajara, Jal.',
      'phone': '33 1816 9579',
      'lat': 20.6625,
      'lng': -103.3065,
    },
    {
      'id': 'cisame_tlaquepaque',
      'name': 'CISAME Tlaquepaque',
      'address': 'Salvador Orozco Loreto 411, Las Liebres, 45410 Tlaquepaque, Jal.',
      'phone': '33 1224 1713',
      'lat': 20.6170,
      'lng': -103.2960,
    },
    {
      'id': 'cisame_tonala',
      'name': 'CISAME Tonalá',
      'address': 'Prados de la Higuera 1045, Prados de la Cruz, Tonalá, Jal.',
      'phone': '33 3792 0534',
      'lat': 20.6240,
      'lng': -103.2340,
    },
    {
      'id': 'cisame_tepatitlan',
      'name': 'CISAME Tepatitlán',
      'address': 'Matías Plascencia 214, Col. Lomalinda, 47675 Tepatitlán, Jal.',
      'phone': '378 688 0301',
      'lat': 20.8170,
      'lng': -102.7640,
    },
    {
      'id': 'cisame_puerto_vallarta',
      'name': 'CISAME Puerto Vallarta',
      'address': 'Cempasúchil 78 esq. Inés Meza, La Floresta, 48290 Puerto Vallarta, Jal.',
      'phone': '322 299 6714',
      'lat': 20.6420,
      'lng': -105.2250,
    },
    {
      'id': 'cisame_autlan',
      'name': 'CISAME Autlán de Navarro',
      'address': 'Puerto Rico 44, La Grana, 48904 Autlán de Navarro, Jal.',
      'phone': '317 381 1098',
      'lat': 19.7708,
      'lng': -104.3636,
    },
  ];

  final batch = firestore.batch();
  for (final item in centers) {
    final docId = item['id'] as String;
    final docRef = firestore.collection('care_centers').doc(docId);
    batch.set(
      docRef,
      {
        'name': item['name'],
        'address': item['address'],
        'phone': item['phone'],
        'lat': item['lat'],
        'lng': item['lng'],
      },
      SetOptions(merge: true),
    );
  }
  await batch.commit();
}