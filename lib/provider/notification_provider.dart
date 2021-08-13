part of "providers.dart";

final notificationProvider = Provider<NotificationServices>(
  (ref) => NotificationServices(
    ref.watch(firebaseAuthProvider),
    ref.watch(firebaseFirestoreProvider),
    ref.watch(firebaseStorageProvider)
  )
);