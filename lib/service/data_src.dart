
import 'package:mwwm_demo/domain/detail.dart';

const detailDataSrc = <DetailData>[
  const DetailData(
    'MWWM',
    '''
About 
MVVM-inspired lightweight architectural framework for Flutter apps made with respect to Clean Architecture.

Currently supported features 
Complete separation of the application's codebase into independent layers: UI, presentation and business logic;
Keeps widget tree clear: the main building block is just an extended version of StatefulWidget;
Built-in mechanisms for handling asynchronous operations;
The ability to easily implement the default error handling strategy;
An event-like mechanism that helps keep the business logic well structured and testable.
      ''',
    'asset/image/gear_logo.png',
  ),
  const DetailData(
    'Surf',
    '''
Задаем тренды, меняем индустрию и создаем приложения, на которые хотят равняться.
Уже 10 лет создаем яркие решения для настоящих акул бизнеса. В наших приложениях вы чаще всего заказываете пиццу, покупаете книги или переводите деньги
      ''',
    'asset/image/surf_logo.png',
  ),
  const DetailData(
    'Иннополис',
    '''
Высокотехнологичный технополис.
Беспилотные авто и роботы-доставщики по всему городу.
Здания с необычной архитектурой и удобные кампусы для студентов.
      ''',
    'asset/image/inno_logo.jpeg',
  ),
];