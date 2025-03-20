class User {
  String _userId;
  String _name;
  String _email;
  DateTime _birthdate;
  String _gender;
  String _employmentStatus;
  String _livingStatus;
  DateTime _createdAt;
  DateTime _updatedAt;

  User({
    required String userId,
    required String name,
    required String email,
    required DateTime birthdate,
    required String gender,
    required String employmentStatus,
    required String livingStatus,
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : _userId = userId,
        _name = name,
        _email = email,
        _birthdate = birthdate,
        _gender = gender,
        _employmentStatus = employmentStatus,
        _livingStatus = livingStatus,
        _createdAt = createdAt,
        _updatedAt = updatedAt;


  String get userId => _userId;
  String get name => _name;
  String get email => _email;
  DateTime get birthdate => _birthdate;
  String get gender => _gender;
  String get employmentStatus => _employmentStatus;
  String get livingStatus => _livingStatus;
  DateTime get createdAt => _createdAt;
  DateTime get updatedAt => _updatedAt;



  set userId(String value) {
    if (value.isNotEmpty) {
      _userId = value;
    } else {
      throw ArgumentError("User ID cannot be empty");
    }
  }

  set name(String value) {
    if (value.isNotEmpty) {
      _name = value;
    } else {
      throw ArgumentError("Name cannot be empty");
    }
  }

  set email(String value) {

    _email = value;
  }

  set birthdate(DateTime value) {
    if (value.isBefore(DateTime.now())) {
      _birthdate = value;
    } else {
      throw ArgumentError("Birthdate cannot be in the future");
    }
  }

  set gender(String value) {
    
    _gender = value;
  }

  set employmentStatus(String value) {
    _employmentStatus = value;
  }

  set livingStatus(String value) {
    _livingStatus = value;
  }

  set createdAt(DateTime value) {
    _createdAt = value;
  }

  set updatedAt(DateTime value) {
    if (value.isAfter(_createdAt)) {
      _updatedAt = value;
    } else {
      throw ArgumentError("Updated time cannot be before created time");
    }
  }
}