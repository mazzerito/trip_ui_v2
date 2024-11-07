import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:trip_vibes_ui_v2/models/activities.dart';
import 'package:trip_vibes_ui_v2/models/bookings.dart';
import 'package:trip_vibes_ui_v2/models/destinations.dart';
import '../models/trips.dart';

class AuthService {
  final String baseUrl = 'http://192.168.44.1:4000/api';

  Future<Map<String, dynamic>> signup(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );

    // Return a structured response with status code and body
    return {
      'statusCode': response.statusCode,
      'body': json.decode(response.body),
    };
  }

  Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );

    return {
      'statusCode': response.statusCode,
      'body': json.decode(response.body),
    };
}

//==========================User============================


//Get user
Future<Map<String, dynamic>?> getUserData(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users/$userId'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to load user data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
}

//Update user
Future<bool> updateUser({
    required int userId,
    required String userName,
    required String email,
    String? password,
    File? profileImage,
  }) async {
    try {
      var request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/users/$userId'));

      // Add text fields
      request.fields['user_name'] = userName;
      request.fields['email'] = email;
      if (password != null && password.isNotEmpty) {
        request.fields['password'] = password;
      }

      // Add image if provided
      if (profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_picture',
          profileImage.path,
        ));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update user: ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }


//==========================TRIP============================

//create trip
  Future<Map<String, dynamic>> createNewTrip(
    int userId,
    String title,
    String description,
    String end,
    String start,
    String people,
    double budget,
  ) async {
    // Define the trip data to be sent in the request body
    final Map<String, dynamic> tripData = {
      'trip_title': title,
      'description': description,
      'end_date': end,
      'start_date': start,
      'trip_people': people,
      'trip_budget': budget,
    };

    // Perform the POST request
    final response = await http.post(
      Uri.parse('$baseUrl/users/$userId/trips'),
      body: json.encode(tripData),
      headers: {'Content-Type': 'application/json'},
    );

    // Return the status code and parsed response body
    if (response.statusCode == 201) {
    return {
      'statusCode': response.statusCode,
      'body': json.decode(response.body),
    };
  } else {
    throw Exception('Failed to create trip');
  }
  }

//edit trip
Future<Map<String, dynamic>> editTrip(
  //int userId,
  int tripId,
  String title,
  String description,
  String start,
  String end,
  String people,
  double budget,
) async {
  // Define the trip data to be sent in the request body
  final Map<String, dynamic> tripData = {
    'trip_title': title,
    'description': description,
    'start_date': start,
    'end_date': end,
    'trip_people': people,
    'trip_budget': budget,
  };

  // Perform the PUT request
  final response = await http.put(
    Uri.parse('$baseUrl/trips/$tripId'),
    body: json.encode(tripData),
    headers: {'Content-Type': 'application/json'},
  );

  // Check the response status and return the response body if successful
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to edit trip: ${response.statusCode}');
  }
}

//Delete
Future<Map<String, dynamic>> deleteTrip(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/trips/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return {
          'statusCode': response.statusCode,
          'body': json.decode(response.body),
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'body': json.decode(response.body),
        };
      }
    } catch (error) {
      return {
        'statusCode': 500,
        'body': {'error': error.toString()},
      };
    }
  }

// Get Trip by ID
Future<List<Trip>> getTripsByUserId(int user_id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users/$user_id/trips'));
      if (response.statusCode == 200) {
        final List tripsJson = json.decode(response.body);
        return tripsJson.map((json) => Trip.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load trips');
      }
    } catch (e) {
      print('Error fetching trips: $e');
      return [];
    }
  }

//Get all trips
Future<List<Trip>> getAllTrips() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/trips'));
      if (response.statusCode == 200) {
        final List tripsJson = json.decode(response.body);
        return tripsJson.map((json) => Trip.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load trips');
      }
    } catch (e) {
      print('Error fetching trips: $e');
      return [];
    }
  }


//==========================Bookings============================

// Get Trip by ID
Future<List<Bookings>> getBookingByTripId(int tripId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/trips/$tripId/bookings'));
      if (response.statusCode == 200) {
        final List bookingJson = json.decode(response.body);
        return bookingJson.map((json) => Bookings.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load Bookings');
      }
    } catch (e) {
      print('Error fetching bookings: $e');
      return [];
    }
  }


//get all bookings
Future<List<Bookings>> getAllBookings() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/bookings'));
      if (response.statusCode == 200) {
        final List bookingJson = json.decode(response.body);
        return bookingJson.map((json) => Bookings.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load all bookings');
      }
    } catch (e) {
      print('Error fetching trips: $e');
      return [];
    }
  }

//Add new booking
Future<void> createNewBooking(
    int tripId,
    //int userId,
    String title,
    double cost,
    String date,
    BookingStatus status,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/trips/$tripId/bookings'), // Adjusted endpoint
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'trip_id': tripId,
        //'user_id': userId,
        'booking_title': title,
        'booking_cost': cost,
        'booking_date': date,
        'status': status.toString().split('.').last, // Convert enum to string
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create booking: ${response.body}');
    }
  }

//UpdateBooking
Future<void> updateBooking(
    int bookingId,
    int tripId,
    //int userId,
    String title,
    double cost,
    String date,
    BookingStatus status,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/bookings/$bookingId'), // Adjust endpoint as needed
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'trip_id': tripId,
        //'user_id': userId,
        'booking_title': title,
        'booking_cost': cost,
        'booking_date': date,
        'status': status.toString().split('.').last, // Convert enum to string
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update booking: ${response.body}');
    }
  }

//Delete Bookings
Future<void> deleteBooking(int bookingId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/bookings/$bookingId'), // Adjust endpoint as needed
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete booking: ${response.body}');
    }
  }


//==========================Destinations============================

//get destination by id
Future<List<Destination>> getDestinationsByTripId(int tripId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/trips/$tripId/destinations'));
      if (response.statusCode == 200) {
        final List destinationJson = json.decode(response.body);
        return destinationJson.map((json) => Destination.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load Destinations');
      }
    } catch (e) {
      print('Error fetching destinations: $e');
      return [];
    }
  }

//get all destinations
Future<List<Destination>> getAllDestinations() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/destinations'));
      if (response.statusCode == 200) {
        final List destinationJson = json.decode(response.body);
        return destinationJson.map((json) => Destination.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load all destinations');
      }
    } catch (e) {
      print('Error fetching destinations: $e');
      return [];
    }
  }

//add new destinations
Future<void> addDestination(int tripId, Destination destination) async {
    final response = await http.post(
      Uri.parse('$baseUrl/trips/$tripId/destinations'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(destination.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add destination: ${response.body}');
    }
  }

//edit destination
 // Method to edit an existing destination
  Future<void> editDestination(
    int tripId,
    int destinationId,
    String name,
    String startDate,
    String endDate,
    String? imageUrl,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/destinations/$destinationId'), // URL path for updating a destination
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'trip_id': tripId, // Include tripId in the request payload
        'destination_name': name,
        'start_date': startDate,
        'end_date': endDate,
        'image_url': imageUrl,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update destination: ${response.body}');
    }
  }
//delete destination
Future<void> deleteDestination(int destinationId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/destinations/$destinationId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete destination: ${response.body}');
    }
  }


//==========================Acvitivity============================


//get activity by destination Id
Future<List<Activities>> getActivityByDestinationId(int destinationId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/destinations/$destinationId/activities'));
      if (response.statusCode == 200) {
        final List activityJson = json.decode(response.body);
        return activityJson.map((json) => Activities.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load Activity');
      }
    } catch (e) {
      print('Error fetching activity: $e');
      return [];
    }
  }


//get all acitivities
Future<List<Activities>> getAllActivities() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/activities'));
      if (response.statusCode == 200) {
        final List activityJson = json.decode(response.body);
        return activityJson.map((json) => Activities.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load Activity');
      }
    } catch (e) {
      print('Error fetching activity: $e');
      return [];
    }
  }


 // Add a new activity
  Future<void> addActivity(int destinationId, Activities activity) async {
    final response = await http.post(
      Uri.parse('$baseUrl/destinations/$destinationId/activities'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(activity.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add activity: ${response.body}');
    }
  }

  // Edit an existing activity
  Future<void> editActivity(
    int activityId,
    String title,
    String? location,
    String? startTime,
    String? endTime,
    double? cost,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/activities/$activityId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'activity_title': title,
        'location': location,
        'start_time': startTime,
        'end_time': endTime,
        'activity_cost': cost,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update activity: ${response.body}');
    }
  }

  // Delete an activity
  Future<void> deleteActivity(int activityId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/activities/$activityId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete activity: ${response.body}');
    }
  }

  // Get activities by destination ID
  // Future<List<Activities>> getActivitiesByDestinationId(int destinationId) async {
  //   final response = await http.get(
  //     Uri.parse('$baseUrl/destinations/$destinationId/activities'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     List<dynamic> jsonList = jsonDecode(response.body);
  //     return jsonList.map((json) => Activities.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load activities: ${response.body}');
  //   }
  // }


}

