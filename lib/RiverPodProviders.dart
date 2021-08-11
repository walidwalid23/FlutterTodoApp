import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'changenotifier.dart';

var tasksDataProvider=new ChangeNotifierProvider<ListenedData>((ref){return ListenedData();});