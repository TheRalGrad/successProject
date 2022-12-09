import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:telekonsul/models/admin/admin.dart';
import 'package:telekonsul/models/user/user.dart';

import 'admin_provider.dart';

class UserProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserModel? _user;
  UserModel? get user => _user;

  final List<UserModel> _users = [];
  List<UserModel> get users => _users;

  DoctorProvider? _adminProvider;
  DoctorProvider? get adminProvider => _adminProvider;

  // For updating the value of DoctorProvider, we use it on main.dart for ChangeNotifierProxyProvider
  set update(DoctorProvider value) {
    _adminProvider = value;
    notifyListeners();
  }

  // We put the getUser() method inside the constructor, so everytime the Provider get called
  // We'll know is the User already login or not, if not then we set the User and Doctor value as null
  // So, they will ge redirect to SplashPage()
  UserProvider() {
    getUser(adminProvider);
  }

  // We fetching the data based on FirebaseAuth userChanges(), here for further information about userChanges() : https://firebase.flutter.dev/docs/auth/usage
  // Then we fetch the data from firestore with the uid we get from listening userChanges
  // And then put it inside the Provider whether is Doctor or User based on what the user are login on
  // Same goes if the user just registered it will called this method and then the user will be logged in
  getUser(DoctorProvider? adminProvider) async {
    _isLoading = true;
    _user = null;
    if (this.adminProvider != null) this.adminProvider!.setDoctor = null;
    FirebaseAuth.instance.userChanges().listen((currentUser) async {
      if (currentUser == null) {
        _user = null;
        if (this.adminProvider != null) this.adminProvider!.setDoctor = null;
        _isLoading = false;
        notifyListeners();
        return;
      }

      var dataUser = await FirebaseFirestore.instance
          .doc('users/${currentUser.uid}')
          .get();

      var dataDoctor = await FirebaseFirestore.instance
          .doc('admin/${currentUser.uid}')
          .get();

      if (dataUser.exists) {
        _user = UserModel.fromJson(dataUser.data()!);
        _isLoading = false;
        notifyListeners();
        return;
      } else if (dataDoctor.exists) {
        if (this.adminProvider != null) {
          this.adminProvider!.setDoctor = Doctor.fromJson(dataDoctor.data()!);
        }

        _isLoading = false;
        notifyListeners();
        return;
      }
    });
  }

  // Take all the data inside users collection
  getAllUsers() async {
    _isLoading = true;
    _users.clear();
    FirebaseFirestore.instance.collection('users').get().then((value) {
      if (value.docs.isEmpty) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      _users.addAll(value.docs.map((e) => UserModel.fromJson(e.data())));
      _isLoading = false;
      notifyListeners();
      return;
    });
  }
}
