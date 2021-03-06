part of "providers.dart";

final userProvider = ChangeNotifierProvider<UserServices>(
  (ref) => UserServices(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firebaseFirestoreProvider),
    storage: ref.watch(firebaseStorageProvider)
  )
);

final currentUserProvider = StreamProvider<UserModel>(
  (ref) => UserServices(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firebaseFirestoreProvider),
    storage: ref.watch(firebaseStorageProvider)
  ).getCurrentUser
);

