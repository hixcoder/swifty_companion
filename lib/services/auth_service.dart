// lib/services/auth_service.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // Get credentials from .env file
  static final String clientId = dotenv.env['CLIENT_ID'] ?? '';
  static final String clientSecret = dotenv.env['CLIENT_SECRET'] ?? '';
  static final String redirectUrl = 'swiftycompanion://callback';
  static final String authorizationEndpoint =
      'https://api.intra.42.fr/oauth/authorize';
  static final String tokenEndpoint = 'https://api.intra.42.fr/oauth/token';

  // Store the OAuth client
  static oauth2.Client? _client;

  // Get or refresh OAuth client
  static Future<oauth2.Client> getClient() async {
    // Check if we have a valid token
    if (_client != null && !_client!.credentials.isExpired) {
      return _client!;
    }

    // If token exists but is expired, try to refresh
    if (_client != null && _client!.credentials.isExpired) {
      debugPrint('Token expired, attempting to refresh...');
      try {
        // In oauth2 2.0.3, we need to manually refresh the token
        final tokenUri = Uri.parse(tokenEndpoint);

        // Create refresh token request
        final response = await http.post(
          tokenUri,
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: {
            'grant_type': 'refresh_token',
            'refresh_token': _client!.credentials.refreshToken,
            'client_id': clientId,
            'client_secret': clientSecret,
          },
        );

        if (response.statusCode == 200) {
          // Parse the refreshed credentials manually
          final Map<String, dynamic> refreshJson = json.decode(response.body);

          // Create new credentials with the refresh token response
          final credentials = oauth2.Credentials.fromJson(response.body);

          // Create a new client with the refreshed credentials
          _client = oauth2.Client(
            credentials,
            identifier: clientId,
            secret: clientSecret,
          );

          debugPrint('Token refreshed successfully');
          return _client!;
        } else {
          throw Exception('Failed to refresh token: ${response.statusCode}');
        }
      } catch (e) {
        debugPrint('Failed to refresh token: $e');
        // If refresh fails, we'll need to authenticate again
        _client = null;
      }
    }

    // If we have no token or refresh failed, request a new one
    debugPrint('Requesting new token...');
    final tokenUri = Uri.parse(tokenEndpoint);

    try {
      // Use client credentials grant for simplicity in this demo
      // In a real app, you would use the authorization code flow with a WebView
      final client = await oauth2.clientCredentialsGrant(
        tokenUri,
        clientId,
        clientSecret,
      );

      _client = client;
      debugPrint('New token acquired successfully');
      return client;
    } catch (e) {
      debugPrint('Failed to acquire token: $e');
      throw Exception('Authentication failed: $e');
    }
  }

  // Clear the current token (for logout)
  static void clearToken() {
    _client = null;
  }
}
