class EmptySearchResultException implements Exception {
  const EmptySearchResultException();
}

class UserAuthenticationRequiredException implements Exception {
  const UserAuthenticationRequiredException();
}

class InvalidCredentialsException implements Exception {
  const InvalidCredentialsException();
}

class UsernameAlreadyTakenException implements Exception {
  const UsernameAlreadyTakenException();
}

class EmailAlreadyRegisteredException implements Exception {
  const EmailAlreadyRegisteredException();
}
