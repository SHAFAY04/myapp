enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  registrationSuccess,
  error;

  bool get isLoading => this == AuthState.loading;
  bool get isAuthenticated => this == AuthState.authenticated;
  bool get isError => this == AuthState.error;
}
