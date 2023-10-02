import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AuthService with ChangeNotifier {
  bool _autenticando = false;
  String? _token;

  bool get autenticando => _autenticando;
  String? get token => _token;

  set autenticando(bool valor) {
    _autenticando = valor;
    notifyListeners();
  }

  Future<String?> login(String username, String password) async {
    try {
      autenticando = true;

      final HttpLink httpLink = HttpLink(
        "http://localhost:8000/graphql/",
      );

      final GraphQLClient client = GraphQLClient(
        cache: GraphQLCache(),
        link: httpLink,
      );

      final MutationOptions options = MutationOptions(
        document: gql('''
          mutation TokenAuth(\$username: String!, \$password: String!) {
            tokenAuth(username: \$username, password: \$password) {
              token
            }
          }
        '''),
        variables: <String, dynamic>{
          'username': username,
          'password': password,
        },
      );

      final QueryResult result = await client.mutate(options);

      if (result.hasException) {
        // Manejar errores aquí
        print(result.exception.toString());
        return null;
      }

      _token = result.data?['tokenAuth']['token'];
      autenticando = false;
      return _token;
    } catch (error) {
      print(error.toString());
      autenticando = false;
      return null;
    }
  }
}
