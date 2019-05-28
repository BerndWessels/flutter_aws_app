import 'package:flutter/material.dart';

abstract class Repository {}

/// A Flutter widget which provides a repository to its children via `RepositoryProvider.of(context)`.
/// It is used as a DI widget so that a single instance of a repository can be provided
/// to multiple widgets within a subtree.
class RepositoryProvider<T extends Repository> extends InheritedWidget {
  /// The [Repository] which is to be made available throughout the subtree
  final T repository;

  /// The [Widget] and its descendants which will have access to the [Repository].
  final Widget child;

  RepositoryProvider({
    Key key,
    @required this.repository,
    this.child,
  })  : assert(repository != null),
        super(key: key);

  /// Method that allows widgets to access the repository as long as their `BuildContext`
  /// contains a `RepositoryProvider` instance.
  static T of<T extends Repository>(BuildContext context) {
    final type = _typeOf<RepositoryProvider<T>>();
    final RepositoryProvider<T> provider = context
        .ancestorInheritedElementForWidgetOfExactType(type)
        ?.widget as RepositoryProvider<T>;

    if (provider == null) {
      throw FlutterError(
        """
        RepositoryProvider.of() called with a context that does not contain a Repository of type $T.
        No ancestor could be found starting from the context that was passed to RepositoryProvider.of<$T>().
        This can happen if the context you use comes from a widget above the RepositoryProvider.
        This can also happen if you used RepositoryProviderTree and didn\'t explicity provide 
        the RepositoryProvider types: RepositoryProvider(repository: $T()) instead of RepositoryProvider<$T>(repository: $T()).
        The context used was: $context
        """,
      );
    }
    return provider?.repository;
  }

  /// Clone the current [RepositoryProvider] with a new child [Widget].
  /// All other values, including [Key] and [Repository] are preserved.
  RepositoryProvider<T> copyWith(Widget child) {
    return RepositoryProvider<T>(
      key: key,
      repository: repository,
      child: child,
    );
  }

  /// Necessary to obtain generic [Type]
  /// https://github.com/dart-lang/sdk/issues/11923
  static Type _typeOf<T>() => T;

  @override
  bool updateShouldNotify(RepositoryProvider oldWidget) => false;
}
