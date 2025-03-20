import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../widgets/info_card.dart';
import '../auth/secure_storage.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String name;
  late String email;
  late String birthdate;
  late String gender;
  late String employmentStatus;
  late String livingStatus;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://researchrealm.world/user'),
      headers: {
        'Authorization': await secureStorage.read(key: 'token'),
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      print('data: $data');

      setState(() {
        name = data['name'];
        email = data['email'];
        birthdate = data['birthdate'];
        gender = data['gender'];
        employmentStatus = data['employment_status'];
        livingStatus = data['living_status'];
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Profile', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                    ),
                    SizedBox(height: 16),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              InfoCard(title: 'Birthdate', value: birthdate, icon: Icon(Icons.date_range)),
              InfoCard(title: 'Gender', value: gender, icon: Icon(Icons.person)),
              InfoCard(title: 'Employment Status', value: employmentStatus, icon: Icon(Icons.monetization_on)),
              InfoCard(title: 'Living Status', value: livingStatus, icon: Icon(Icons.female)),
            ],
          ),
        ),
      ),
    );
  }
}







/*
HomeScreen Page Code before redesign


class _ProfileState extends State<Profile> {

  SecureStorage secureStorage = SecureStorage();
  Future<void> logOut() async {
    try {
      final _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/userinfo.profile',
          'openid',
        ],
        serverClientId:
        '180610885511-l96rtfbkh1ucdlsmgnaue8or4ujm7k98.apps.googleusercontent.com', // Replace with your Web Client ID
      );
      await _googleSignIn.signOut().then(
            (value) {
          secureStorage.delete(key: 'token');
          secureStorage.delete(key: 'isNew');
        },
      ).then(
            (value) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const AuthScreen()));
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign in failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text('HomeScreen'),
          ),
          Center(
            // child:
            // IconButton(onPressed: () => logOut(), icon: Icon(Icons.logout)),
          )
        ],
      ),
    );
  }
}


 */
