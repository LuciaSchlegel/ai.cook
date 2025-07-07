class AppErrorHandler {
  static String handle(Object error) {
    final message = error.toString().toLowerCase();

    if (message.contains('already exists')) {
      return 'Ese ingrediente ya está en tu despensa.';
    }
    if (message.contains('not authenticated')) {
      return 'Debes iniciar sesión para realizar esta acción.';
    }
    if (message.contains('quantity must be greater than 0')) {
      return 'La cantidad debe ser mayor a cero.';
    }
    if (message.contains('network')) {
      return 'Error de red. Por favor, revisa tu conexión a internet.';
    }
    if (message.contains('timeout')) {
      return 'La solicitud tardó demasiado. Intenta de nuevo.';
    }
    // Puedes agregar más casos aquí...

    // Fallback
    return 'Ocurrió un error inesperado: $message';
  }
} 