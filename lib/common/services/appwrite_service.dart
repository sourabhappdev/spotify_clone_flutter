import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppWriteService {
  static final AppWriteService instance = AppWriteService._();

  factory AppWriteService() {
    return instance;
  }

  AppWriteService._();

  static final Client client = Client();
  static late final Account account;
  static late final Databases databases;
  static late final Storage storage;

  void init() {
    Client client = Client();
    client.setProject(dotenv.env['PROJECT']);
    account = Account(client);
    databases = Databases(client);
    storage = Storage(client);
  }
}
