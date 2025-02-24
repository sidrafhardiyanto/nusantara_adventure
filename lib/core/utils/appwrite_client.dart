import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../constants/app_constants.dart';

class AppwriteClient {
  static Client get client {
    Client client = Client();
    return client
      ..setEndpoint(dotenv.env[AppConstants.appwriteEndpointKey]!)
      ..setProject(dotenv.env[AppConstants.appwriteProjectIdKey]!)
      ..setSelfSigned(status: true); // Hapus di production
  }

  static Account get account => Account(client);
  static Databases get databases => Databases(client);
  static Storage get storage => Storage(client);
} 