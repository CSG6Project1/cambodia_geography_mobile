import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'cambodia_geography.dart';
import 'package:path/path.dart';

void main() async {
  File placesFile = File('scripts/places_random.json');
  File restaurantsFile = File('scripts/restaurants_random.json');
  await CambodiaGeography.instance.initilize();
  random(file: placesFile, type: 'place', exampleDatas: places);
  random(file: restaurantsFile, type: 'restaurant', exampleDatas: restaurants);
}

Future<void> random({
  required File file,
  required String type,
  required List<dynamic> exampleDatas,
  int desireRandom = 100,
}) async {
  List<dynamic> list = [];
  List<String?> provincesCodes = CambodiaGeography.instance.tbProvinces.map((e) => e.code).toList();
  for (int i = 0; i < desireRandom; i++) {
    String randomProvinceCode = provincesCodes[Random().nextInt(provincesCodes.length - 1)]!;

    List<String?> districtList =
        CambodiaGeography.instance.districtsSearch(provinceCode: randomProvinceCode).map((e) => e.code).toList();
    String? randomDistrictCode = districtList[Random().nextInt(districtList.length - 1)];

    List<String?>? communeList = randomDistrictCode != null
        ? CambodiaGeography.instance.communesSearch(districtCode: randomDistrictCode).map((e) => e.code).toList()
        : null;

    String? randomCommuneCode =
        communeList?.isNotEmpty == true ? communeList![Random().nextInt(communeList.length - 1)] : null;

    List<String?>? villageList = randomCommuneCode != null
        ? CambodiaGeography.instance.villagesSearch(communeCode: randomCommuneCode).map((e) => e.code).toList()
        : null;

    String? randomVillageCode = villageList?.isNotEmpty == true
        ? villageList![Random().nextInt(villageList.length - 1) % villageList.length]
        : null;

    int nameIndex = Random().nextInt(exampleDatas.length - 1 % exampleDatas.length);
    String randomNameKh = Random().nextInt(desireRandom).toString() + " " + exampleDatas[nameIndex]['khmer'];
    String randomNameEn = Random().nextInt(desireRandom).toString() + " " + exampleDatas[nameIndex]['english'];

    int latLngIndex = Random().nextInt(exampleDatas.length - 1);
    num? randomLat = exampleDatas[latLngIndex]['lat'];
    num? randomLon = exampleDatas[latLngIndex]['lon'];
    String randomBody = exampleDatas[Random().nextInt(exampleDatas.length - 1)]['body'];
    List<String> randomImages = exampleDatas[Random().nextInt(exampleDatas.length - 1)]['images'];

    list.add({
      'type': type,
      'khmer': randomNameKh,
      'english': randomNameEn,
      'province_code': randomProvinceCode,
      'district_code': randomDistrictCode,
      'commune_code': randomCommuneCode,
      'village_code': randomVillageCode,
      'lat': randomLat,
      'lon': randomLon,
      'body': randomBody,
      'images': randomImages.map((e) {
        return {
          "type": "image",
          "id": "${type + list.length.toString() + basename(e)}",
          "url": e,
        };
      }).toList()
        ..removeWhere((e) => !(e['url']?.isNotEmpty == true)),
      'comments': [],
    });

    file.writeAsString(jsonEncode(list));
  }
}

List<Map<String, dynamic>> places = [
  {
    'type': 'place',
    'khmer': 'ផ្សារកណ្តាល',
    'english': 'Phsar Kandal',
    'province_code': '01',
    'district_code': '0110',
    'commune_code': '021204',
    'village_code': '02120408',
    'lat': 135.2039,
    'lon': 122.593,
    'body': '<b>This place is really good</b>',
    'images': [''],
    'comments': [''],
  },
  {
    'type': 'place',
    'khmer': 'ឧទ្យានជាតិបូកគោ',
    'english': 'Boko',
    'province_code': '01',
    'district_code': null,
    'commune_code': null,
    'village_code': null,
    'lat': 135.2039,
    'lon': 122.593,
    'body':
        'ឧទ្យានជាតិព្រះមុនីវង្សភ្នំបូកគោឬឧទ្យានជាតិភ្នំបូកគោមានទីតាំងស្ថិតនៅក្នុងស្រុកទឹកឈូខេត្តកំពត។ ភ្នំបូកគោមានកម្ពស់ ១០៧៥ម៉ែត្រធៀបទៅនឹងនីវ៉ូទឹកសមុទ្រនិងមានចម្ងាយប្រមាណ ១១គីឡូម៉ែត្រពីក្រុងកំពតទៅកាន់ជើងភ្នំនិងចម្ងាយ ៣២គីឡូម៉ែត្រពីជើងភ្នំដល់កំពូលភ្នំ។ ភ្នំបូកគោត្រូវបានរកឃើញនៅឆ្នាំ១៩១៧ ដោយជនជាតិបារាំងនិងត្រូវបានអភិវឌ្ឍឲ្យទៅជារមណីយដ្ឋាននៅឆ្នាំ១៩២១ ក្នុងរជ្ជកាលព្រះបាទស៊ីសុវត្ថិ។',
    'images': [
      'https://thumbs.dreamstime.com/b/abandoned-christian-church-top-bokor-mountain-preah-monivong-national-park-kampot-cambodia-kep-71161752.jpg',
      'https://thumbs.dreamstime.com/b/abandoned-christian-church-top-bokor-mountain-preah-monivong-national-park-kampot-cambodia-kep-71163269.jpg',
    ],
    'comments': [''],
  },
  {
    'type': 'place',
    'khmer': 'ទឹកធ្លាក់ពពកវិល',
    'english': 'Tek Vil',
    'province_code': '01',
    'district_code': null,
    'commune_code': null,
    'village_code': null,
    'lat': 10.658770751039778,
    'lon': 104.051250835383,
    'body':
        'ទឹកជ្រោះពពកវិលស្ថិតនៅលើភ្នំបូកគោដែលជាទិសដៅពេញនិយមសម្រាប់ភ្ញៀវទេសចរក្នុងខេត្តកំពតដោយសារអាកាសធាតុត្រជាក់និងភ្នំដែលមានទេសភាពដ៏ស្រស់ស្អាត។ វាពិតជារីករាយណាស់ក្នុងការធ្វើដំណើរទៅកាន់ទីនោះ មិនត្រឹមតែប៉ុណ្ណោះ អ្នកក៏អាចមើលឃើញពីជីវិតសត្វព្រៃគួរឱ្យចាប់អារម្មណ៍មួយចំនួនដូចជាសត្វកំប្រុកក្រហមឬសត្វស្វា។ ទោះបីពេលមកដល់ទឹកជ្រោះអាចនឹងមានការលំបាកបន្តិចប៉ុន្តែនៅពេលដែលអ្នកបានឃើញដោយផ្ទាល់នូវសម្រស់ធម្មជាតិនៃទឹកធ្លាក់បន្ទាប់មកអ្នកប្រាកដជាដឹងច្បាស់ហើយថាវាពិតជាសក្តិសមនឹងការខិតខំរបស់អ្នក។',
    'images': [
      'https://d27k8xmh3cuzik.cloudfront.net/wp-content/uploads/2018/10/og-image-for-waterfall-attractions-in-cambodia.jpg',
      'https://www.madmonkeyhostels.com/wp-content/uploads/2017/09/rsz_popokvil_waterfall.jpg',
    ],
    'comments': [''],
  },
  {
    'type': 'place',
    'khmer': 'ឧទ្យានព្រែកចាក',
    'english': 'Prek Jak',
    'province_code': '01',
    'district_code': null,
    'commune_code': null,
    'village_code': null,
    'lat': 10.49895392838263,
    'lon': 103.65155873315233,
    'body': '',
    'images': [
      'https://d27k8xmh3cuzik.cloudfront.net/wp-content/uploads/2018/10/og-image-for-waterfall-attractions-in-cambodia.jpg',
      'https://www.madmonkeyhostels.com/wp-content/uploads/2017/09/rsz_popokvil_waterfall.jpg',
    ],
    'comments': [''],
  },
  {
    'type': 'place',
    'khmer': 'ឧទ្យានព្រែកចាក',
    'english': 'Prek Jak',
    'province_code': '01',
    'district_code': null,
    'commune_code': null,
    'village_code': null,
    'lat': 10.668064871653021,
    'lon': 104.1578565502459,
    'body':
        'មានទីតាំងស្ថិតនៅជិតរមណីយដ្ឋានទឹកឈូតាមបណ្តោយដងទន្លេកំពង់បាយដែលមានចម្ងាយប្រហែល ៨.៥ គីឡូម៉ែត្រខាងជើងពីរង្វង់មូលធូរេន។ អ្នកប្រហែលជាគិតថាវាមិនមែនជាទីតាំងងាយស្រួលនោះទេប៉ុន្តែតាមពិតវាជាជំរើសដ៏ល្អឥតខ្ចោះសម្រាប់ភ្ញៀវទេសចរដែលចង់ទទួលបាននូវឱកាសពិសេសមួយ។ វាផ្តល់ជូននូវហ្សីបលីន, ដើមឈើរ៉ូប, បារអណ្តែតទូកលេងហ្គេមលើមេឃនិងបឹងជាច្រើនទៀត។ នៅពេលនិយាយអំពីសកម្មភាពនៅខេត្តកំពតអ្នកខ្លះប្រហែលជាគិតអំពីការឡើងភ្នំ។ ទោះយ៉ាងណាក៏ដោយសម្រាប់អ្នកដែលចង់បានបទពិសោធរំភើបរីករាយយើងសូមណែនាំអ្នកឱ្យទៅសួនឧទ្យាន។',
    'images': [
      'https://tripsary.s3.amazonaws.com/uploads/sub_location/cover_photo/96/standard_kayak-park-cover.jpg',
      'https://avocado-app.s3.amazonaws.com/uploads/cms/image_gallery/image/1/kampot_20l.jpg',
    ],
    'comments': [''],
  },
  {
    'type': 'place',
    'khmer': 'រង្វង់មូលធុរេន',
    'english': 'Turen',
    'province_code': '01',
    'district_code': null,
    'commune_code': null,
    'village_code': null,
    'lat': 10.610683946483933,
    'lon': 104.18149925024555,
    'body':
        'មានទីតាំងស្ថិតនៅជិតរមណីយដ្ឋានទឹកឈូតាមបណ្តោយដងទន្លេកំពង់បាយដែលមានចម្ងាយប្រហែល ៨.៥ គីឡូម៉ែត្រខាងជើងពីរង្វង់មូលធូរេន។ អ្នកប្រហែលជាគិតថាវាមិនមែនជាទីតាំងងាយស្រួលនោះទេប៉ុន្តែតាមពិតវាជាជំរើសដ៏ល្អឥតខ្ចោះសម្រាប់ភ្ញៀវទេសចរដែលចង់ទទួលបាននូវឱកាសពិសេសមួយ។ វាផ្តល់ជូននូវហ្សីបលីន, ដើមឈើរ៉ូប, បារអណ្តែតទូកលេងហ្គេមលើមេឃនិងបឹងជាច្រើនទៀត។ នៅពេលនិយាយអំពីសកម្មភាពនៅខេត្តកំពតអ្នកខ្លះប្រហែលជាគិតអំពីការឡើងភ្នំ។ ទោះយ៉ាងណាក៏ដោយសម្រាប់អ្នកដែលចង់បានបទពិសោធរំភើបរីករាយយើងសូមណែនាំអ្នកឱ្យទៅសួនឧទ្យាន។',
    'images': [
      'https://tripsary.s3.amazonaws.com/uploads/sub_location/cover_photo/96/standard_kayak-park-cover.jpg',
      'https://avocado-app.s3.amazonaws.com/uploads/cms/image_gallery/image/1/kampot_20l.jpg',
    ],
    'comments': [''],
  },
  {
    'type': 'place',
    'khmer': 'វត្តសំពៅប្រាំ',
    'english': 'Turen',
    'province_code': '01',
    'district_code': null,
    'commune_code': null,
    'village_code': null,
    'lat': 10.630035094887255,
    'lon': 104.01734762756038,
    'body':
        'វត្តសំពៅប្រាំដែលត្រូវបានគេចាត់ទុកថាជាវត្តព្រះពុទ្ធខ្ពស់ជាងគេនៅកម្ពុជាគឺជាទីកន្លែងបែបសាសនាដ៏មានភាពទាក់ទាញ។ ឈ្មោះវត្តសំពៅប្រាំនេះមានន័យថាប្រាសាទទូកប្រាំដែលជាឯកសារយោងសម្រាប់ទ្រង់ទ្រាយថ្មធំនិងរាបស្មើនៅក្បែរនោះមានបណ្តោយ ១០ ម៉ែត្រគុណនឹង ១០ ម៉ែត្រទ្រង់ទ្រាយធម្មជាតិទាំងនេះបង្ហាញពីរូបភាពនៃទូកដែលដាក់ឈ្មោះវត្តនោះ។',
    'images': [
      'https://tripsary.s3.amazonaws.com/uploads/sub_location/cover_photo/96/standard_kayak-park-cover.jpg',
      'https://avocado-app.s3.amazonaws.com/uploads/cms/image_gallery/image/1/kampot_20l.jpg',
    ],
    'comments': [''],
  },
  {
    'type': 'place',
    'khmer': 'ទឹកជ្រោះតាតៃ',
    'english': 'Turen',
    'province_code': '01',
    'district_code': null,
    'commune_code': null,
    'village_code': null,
    'lat': 10.630035094887255,
    'lon': 104.01734762756038,
    'body':
        'រមណីយដ្ឋាននេះ ជាតំបន់អេកូទេសចរណ៍មួយ ដែលទាំង​ភ្ញៀវ​ជាតិ និង​ភ្ញៀវ​អន្តរជាតិ មិន​អាច​នឹង​មើល​រំលងនៅ​ពេល​មក​កំសាន្ត​ក្នុង​ខេត្ត​កោះកុង។ ទេសភាព​ព្រៃ​ប្រឹក្សា​ដ៏ខៀវ​ស្រងាត់ បាន​ឆក់​នូវ​ភាពស្មុគស្មាញ និង​រំសាយ​អារម្មណ៍​ជាមួយ​នឹង​ខ្យល់​អាកាស​បរិសុទ្ធ​លាយ​ឡំ​នឹង​ទិដ្ឋភាព​នៃ​ទឹកហូរ​កាត់​តាម​ផ្ទាំង​ថ្ម​ធំៗ​។',
    'images': [
      'https://www.kohkong.gov.kh/wp-content/uploads/sites/12/2019/08/IMG_0207-768x497.jpg',
    ],
    'comments': [''],
  },
];

List<dynamic> restaurants = [
  {
    'type': 'restaurant',
    'khmer': 'ហាងលក់អាហាគ្រប់ប្រភេទ',
    'english': 'Sell every food resturants',
    'province_code': '01',
    'district_code': '0111',
    'commune_code': '021205',
    'village_code': '02120408',
    'lat': 135.2039,
    'lon': 122.593,
    'body': '<b>This place is really good</b>',
    'images': [''],
    'comments': [''],
  },
  {
    'type': 'restaurant',
    'khmer': 'អេពីក អាត កាហ្វេ',
    'english': 'Epic Arts Cafe',
    'province_code': '01',
    'district_code': null,
    'commune_code': null,
    'village_code': null,
    'lat': 135.2039,
    'lon': 122.593,
    'body':
        'បានបង្កើតឡើងក្នុងឆ្នាំ2006កាហ្វេរបស់យើងគឺជាកន្លែងធ្វើការដែលមានបម្រើអាហារពេលព្រឹកដ៏អស្ចារ្យនិងអាហារថ្ងៃត្រង់ដែលមានរសជាតិឈ្ងុយឆ្ងាញ់។',
    'images': [
      'https://www.madmonkeyhostels.com/wp-content/uploads/2017/06/Epic-Arts-Cafe-copy.jpg',
    ],
    'comments': [''],
  },
  {
    'type': 'restaurant',
    'khmer': 'ផ្ទះបៃតង',
    'english': 'Green house',
    'province_code': '01',
    'district_code': null,
    'commune_code': null,
    'village_code': null,
    'lat': 135.2039,
    'lon': 122.593,
    'body': '',
    'images': [
      'https://www.madmonkeyhostels.com/wp-content/uploads/2017/06/Epic-Arts-Cafe-copy.jpg',
    ],
    'comments': [''],
  },
  {
    'type': 'restaurant',
    'khmer': 'Tertulia',
    'english': 'Tertulia',
    'province_code': '01',
    'district_code': null,
    'commune_code': null,
    'village_code': null,
    'lat': 0,
    'lon': 0,
    'body': '',
    'images': [
      'https://firebasestorage.googleapis.com/v0/b/romduoltravel.appspot.com/o/kompot%2Ffoods%2Ftertulia.jpg?alt=media&token=2c71961e-502b-4ed2-a379-1a80e41753ee',
    ],
    'comments': [''],
  },
  {
    'type': 'restaurant',
    'khmer': 'Longset Beach  Resort',
    'english': 'Longset Beach  Resort',
    'province_code': '01',
    'district_code': null,
    'commune_code': null,
    'village_code': null,
    'lat': 0,
    'lon': 0,
    'body': '',
    'images': [
      'https://m.facebook.com/tpokmedia/photos/pcb.3691234994260494/3691222504261743/?type=3&source=49&ref=bookmarks',
      'https://z-m-scontent.fpnh5-4.fna.fbcdn.net/v/t1.0-9/fr/cp0/e15/q65/123662219_3691222510928409_1446167200565489394_o.jpg?_nc_cat=101&ccb=2&_nc_sid=8024bb&_nc_ohc=MMBc3UUi2LkAX-Ggq3P&_nc_ad=z-m&_nc_cid=1595&_nc_eh=0df1c28da239defe5f2c40eac0ab23f1&_nc_ht=z-m-scontent.fpnh5-4.fna&tp=14&oh=ed3c3f6fbccc1af2f9406470360603a9&oe=5FD24BB5',
    ],
    'comments': [''],
  },
  {
    'type': 'restaurant',
    'khmer': 'បឹងកាឡូឬស្សី',
    'english': 'amboo Bungalow',
    'province_code': '01',
    'district_code': null,
    'commune_code': null,
    'village_code': null,
    'lat': 0,
    'lon': 0,
    'body':
        'បឹងកាឡូ ឫស្សី ឬក៏គេច្រើនហៅថា Bamboo Bungalow មានទីតាំងស្ថិតនៅ ភូមិអូរតូច សង្កាត់អណ្ដូងខ្មែរ ក្រុងកំពត ខេត្តកំពត និងមានចម្ងាយប្រហែល ~3km ពីរង្វង់មូល​ធូរេន។',
    'images': [
      'https://cf.bstatic.com/images/hotel/max1280x900/900/90042437.jpg',
      'https://pix10.agoda.net/hotelImages/1622444/-1/a4c564d83a0b16b2625c0d62b342eae0.jpg?s=1024x768',
    ],
    'comments': [''],
  },
  {
    'type': 'restaurant',
    'khmer': 'ភូមិអេកូ',
    'english': 'Eden',
    'province_code': '01',
    'district_code': null,
    'commune_code': null,
    'village_code': null,
    'lat': 0,
    'lon': 0,
    'body':
        'ស្ថិតនៅចំងាយ4គ.មពីទីរួមខេត្តកំពតផ្ទះសំណាក់ហ្គេសហាកំពតអេកូផ្តល់ជូនភ្ញៀវនូវកន្លែងស្នាក់នៅសាមញ្ញនិងមានតំលៃសមរម្យ។កន្លែងចតរថយន្តឥតគិតថ្លៃត្រូវបានផ្តល់ជូនដល់អ្នកដែលបើកឡាននិងបើកវ៉ាយហ្វាយឥតគិតថ្លៃអាចរកបាននៅនឹងកន្លែង។បន្ទប់ត្រូវបានបំពាក់ដោយគ្រឿងបរិក្ខារមូលដ្ឋានរួមមានពូកមុងមុងនិងកង្ហារ។សម្ភារៈបន្ទប់ទឹកត្រូវបានចែករំលែក។បុគ្គលិកអាចរៀបចំឱ្យអ្នករីករាយនឹងសកម្មភាពក្រៅផ្សេងៗគ្នាដូចជាការនេសាទជិះកង់និងទូកកាណូ។ផ្ទះសំណាក់ហ្គេសសាកំពតអេកូអេកក៏មានកន្លែងបោកគក់ផងដែរ។ទាំងអាហារក្នុងស្រុកនិងអន្តរជាតិនឹងត្រូវបានបម្រើនៅភោជនីយដ្ឋានពីនឹងកន្លែង។ស្រាបៀរក្នុងស្រុកនិងជម្រើសស្រាដ៍រីករាយនៅបារ៍។',
    'images': [
      'https://cf.bstatic.com/images/hotel/max1024x768/195/195942644.jpg',
      'https://firebasestorage.googleapis.com/v0/b/romduoltravel.appspot.com/o/kompot%2Faccomodations%2Feden-eco-village.jpg?alt=media&token=561925b0-444e-4467-96b8-7a5eed802052',
    ],
    'comments': [''],
  },
  {
    'type': 'restaurant',
    'khmer': 'ផ្ទះសំណាក់អេកូ',
    'english': 'Ganesha',
    'province_code': '01',
    'district_code': null,
    'commune_code': null,
    'village_code': null,
    'lat': 0,
    'lon': 0,
    'body':
        'ស្ថិតនៅចំងាយ4គ.មពីទីរួមខេត្តកំពតផ្ទះសំណាក់ហ្គេសហាកំពតអេកូផ្តល់ជូនភ្ញៀវនូវកន្លែងស្នាក់នៅសាមញ្ញនិងមានតំលៃសមរម្យ។កន្លែងចតរថយន្តឥតគិតថ្លៃត្រូវបានផ្តល់ជូនដល់អ្នកដែលបើកឡាននិងបើកវ៉ាយហ្វាយឥតគិតថ្លៃអាចរកបាននៅនឹងកន្លែង។បន្ទប់ត្រូវបានបំពាក់ដោយគ្រឿងបរិក្ខារមូលដ្ឋានរួមមានពូកមុងមុងនិងកង្ហារ។សម្ភារៈបន្ទប់ទឹកត្រូវបានចែករំលែក។បុគ្គលិកអាចរៀបចំឱ្យអ្នករីករាយនឹងសកម្មភាពក្រៅផ្សេងៗគ្នាដូចជាការនេសាទជិះកង់និងទូកកាណូ។ផ្ទះសំណាក់ហ្គេសសាកំពតអេកូអេកក៏មានកន្លែងបោកគក់ផងដែរ។ទាំងអាហារក្នុងស្រុកនិងអន្តរជាតិនឹងត្រូវបានបម្រើនៅភោជនីយដ្ឋានពីនឹងកន្លែង។ស្រាបៀរក្នុងស្រុកនិងជម្រើសស្រាដ៍រីករាយនៅបារ៍។',
    'images': [
      'https://firebasestorage.googleapis.com/v0/b/romduoltravel.appspot.com/o/kompot%2Faccomodations%2Fgenesha.webp?alt=media&token=a19d2e78-7551-43b1-bafb-5b9df9e0e145',
      'https://firebasestorage.googleapis.com/v0/b/romduoltravel.appspot.com/o/kompot%2Faccomodations%2Feden-eco-village.jpg?alt=media&token=561925b0-444e-4467-96b8-7a5eed802052',
    ],
    'comments': [''],
  },
  {
    'type': 'restaurant',
    'khmer': 'រីសត Ramo',
    'english': 'Ramo',
    'province_code': '01',
    'district_code': null,
    'commune_code': null,
    'village_code': null,
    'lat': 0,
    'lon': 0,
    'body': '',
    'images': [
      'https://firebasestorage.googleapis.com/v0/b/romduoltravel.appspot.com/o/kompot%2Faccomodations%2Framo.jpg?alt=media&token=ed9a5d19-7624-47fa-b35e-8bf51577f974',
    ],
    'comments': [''],
  },
];
