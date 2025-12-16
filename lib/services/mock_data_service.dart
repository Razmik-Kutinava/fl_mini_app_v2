class MockDataService {
  // Mock кофейни
  static List<Map<String, dynamic>> getMockLocations() {
    return [
      {
        'id': '1',
        'name': 'Кофейня Тверская',
        'address': 'Тверская ул., 15',
        'lat': 55.7558,
        'lng': 37.6173,
        'isActive': true,
        'rating': 4.8,
        'isOpen': true,
      },
      {
        'id': '2',
        'name': 'Кофейня Арбат',
        'address': 'Арбат, 24',
        'lat': 55.7517,
        'lng': 37.5914,
        'isActive': true,
        'rating': 4.9,
        'isOpen': true,
      },
      {
        'id': '3',
        'name': 'Кофейня Красная площадь',
        'address': 'Красная площадь, 1',
        'lat': 55.7539,
        'lng': 37.6208,
        'isActive': true,
        'rating': 4.7,
        'isOpen': true,
      },
    ];
  }

  // Mock категории
  static List<Map<String, dynamic>> getMockCategories() {
    return [
      {
        'id': '1',
        'name': '☕ Кофе',
        'icon': 'coffee',
      },
      {
        'id': '2',
        'name': '🍵 Чай',
        'icon': 'tea',
      },
      {
        'id': '3',
        'name': '🍰 Десерты',
        'icon': 'cake',
      },
    ];
  }

  // Mock товары
  static List<Map<String, dynamic>> getMockProducts() {
    return [
      // Кофе
      {
        'id': '1',
        'name': 'Латте',
        'price': 250,
        'description': 'Классический кофе с молоком',
        'imageUrl': 'https://picsum.photos/400/400?random=1',
        'categoryId': '1',
        'modifiers': {
          'size': {
            'required': true,
            'options': [
              {'label': 'S', 'volume': '250мл', 'price': 0},
              {'label': 'M', 'volume': '350мл', 'price': 50},
              {'label': 'L', 'volume': '450мл', 'price': 100},
            ],
          },
          'milk': {
            'required': false,
            'options': [
              {'label': 'Обычное', 'price': 0},
              {'label': 'Соевое', 'price': 30},
              {'label': 'Миндальное', 'price': 40},
            ],
          },
          'extras': {
            'required': false,
            'options': [
              {'label': 'Сироп ванильный', 'price': 50},
              {'label': 'Маршмеллоу', 'price': 30},
              {'label': 'Дополнительный шот', 'price': 50},
            ],
          },
        },
      },
      {
        'id': '2',
        'name': 'Капучино',
        'price': 220,
        'description': 'Эспрессо с молочной пеной',
        'imageUrl': 'https://picsum.photos/400/400?random=2',
        'categoryId': '1',
        'modifiers': {
          'size': {
            'required': true,
            'options': [
              {'label': 'S', 'volume': '200мл', 'price': 0},
              {'label': 'M', 'volume': '300мл', 'price': 40},
              {'label': 'L', 'volume': '400мл', 'price': 80},
            ],
          },
          'milk': {
            'required': false,
            'options': [
              {'label': 'Обычное', 'price': 0},
              {'label': 'Соевое', 'price': 30},
              {'label': 'Овсяное', 'price': 35},
            ],
          },
          'extras': {
            'required': false,
            'options': [
              {'label': 'Корица', 'price': 20},
              {'label': 'Какао', 'price': 25},
            ],
          },
        },
      },
      {
        'id': '3',
        'name': 'Эспрессо',
        'price': 180,
        'description': 'Крепкий черный кофе',
        'imageUrl': 'https://picsum.photos/400/400?random=3',
        'categoryId': '1',
        'modifiers': {
          'size': {
            'required': false,
            'options': [
              {'label': 'S', 'volume': '30мл', 'price': 0},
              {'label': 'D', 'volume': '60мл', 'price': 30},
            ],
          },
        },
      },
      {
        'id': '4',
        'name': 'Американо',
        'price': 200,
        'description': 'Эспрессо с горячей водой',
        'imageUrl': 'https://picsum.photos/400/400?random=4',
        'categoryId': '1',
        'modifiers': {
          'size': {
            'required': true,
            'options': [
              {'label': 'S', 'volume': '200мл', 'price': 0},
              {'label': 'M', 'volume': '300мл', 'price': 40},
            ],
          },
        },
      },
      {
        'id': '5',
        'name': 'Раф кофе',
        'price': 280,
        'description': 'Кофе со сливками и ванилью',
        'imageUrl': 'https://picsum.photos/400/400?random=5',
        'categoryId': '1',
        'modifiers': {
          'size': {
            'required': true,
            'options': [
              {'label': 'M', 'volume': '300мл', 'price': 0},
              {'label': 'L', 'volume': '400мл', 'price': 50},
            ],
          },
        },
      },
      // Чай
      {
        'id': '6',
        'name': 'Черный чай',
        'price': 150,
        'description': 'Классический черный чай',
        'imageUrl': 'https://picsum.photos/400/400?random=6',
        'categoryId': '2',
        'modifiers': {
          'size': {
            'required': true,
            'options': [
              {'label': 'S', 'volume': '250мл', 'price': 0},
              {'label': 'M', 'volume': '350мл', 'price': 30},
            ],
          },
        },
      },
      {
        'id': '7',
        'name': 'Зеленый чай',
        'price': 160,
        'description': 'Свежий зеленый чай',
        'imageUrl': 'https://picsum.photos/400/400?random=7',
        'categoryId': '2',
        'modifiers': {
          'size': {
            'required': true,
            'options': [
              {'label': 'S', 'volume': '250мл', 'price': 0},
              {'label': 'M', 'volume': '350мл', 'price': 30},
            ],
          },
        },
      },
      {
        'id': '8',
        'name': 'Чай матча',
        'price': 320,
        'description': 'Традиционный японский чай',
        'imageUrl': 'https://picsum.photos/400/400?random=8',
        'categoryId': '2',
        'modifiers': {
          'size': {
            'required': false,
            'options': [
              {'label': 'M', 'volume': '300мл', 'price': 0},
            ],
          },
        },
      },
      // Десерты
      {
        'id': '9',
        'name': 'Чизкейк',
        'price': 350,
        'description': 'Нежный чизкейк с ягодами',
        'imageUrl': 'https://picsum.photos/400/400?random=9',
        'categoryId': '3',
        'modifiers': null,
      },
      {
        'id': '10',
        'name': 'Тирамису',
        'price': 380,
        'description': 'Классический итальянский десерт',
        'imageUrl': 'https://picsum.photos/400/400?random=10',
        'categoryId': '3',
        'modifiers': null,
      },
      {
        'id': '11',
        'name': 'Круассан',
        'price': 180,
        'description': 'Свежий французский круассан',
        'imageUrl': 'https://picsum.photos/400/400?random=11',
        'categoryId': '3',
        'modifiers': null,
      },
      {
        'id': '12',
        'name': 'Маффин шоколадный',
        'price': 200,
        'description': 'Шоколадный маффин с кусочками шоколада',
        'imageUrl': 'https://picsum.photos/400/400?random=12',
        'categoryId': '3',
        'modifiers': null,
      },
    ];
  }

  // Имитация задержки сети
  static Future<void> delay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Mock валидация промокода
  static Map<String, dynamic> validatePromoCode(String code) {
    final validCodes = {
      'COFFEE20': {'valid': true, 'discount': 72},
      'SUMMER50': {'valid': true, 'discount': 150},
      'WELCOME10': {'valid': true, 'discount': 30},
    };

    return validCodes[code.toUpperCase()] ?? {'valid': false, 'discount': 0};
  }
}
