enum ApiState {
  initial,
  loading,
  success,
  error;

  bool get isLoading => this == ApiState.loading;
  bool get isSuccess => this == ApiState.success;
  bool get isError => this == ApiState.error;
  bool get isInitial => this == ApiState.initial;
}
