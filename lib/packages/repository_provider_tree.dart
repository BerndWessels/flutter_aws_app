import 'package:flutter/widgets.dart';
import 'package:flutter_aws_app/packages/repository.dart';

/// A Flutter [Widget] that merges multiple [RepositoryProvider] widgets into one widget tree.
///
/// [RepositoryProviderTree] improves the readability and eliminates the need
/// to nest multiple [RepositoryProviders].
///
/// By using [RepositoryProviderTree] we can go from:
///
/// ```dart
/// RepositoryProvider<RepositoryA>(
///   repository: RepositoryA(),
///   child: RepositoryProvider<RepositoryB>(
///     repository: RepositoryB(),
///     child: RepositoryProvider<RepositoryC>(
///       value: RepositoryC(),
///       child: ChildA(),
///     )
///   )
/// )
/// ```
///
/// to:
///
/// ```dart
/// RepositoryProviderTree(
///   repositoryProviders: [
///     RepositoryProvider<RepositoryA>(repository: RepositoryA()),
///     RepositoryProvider<RepositoryB>(repository: RepositoryB()),
///     RepositoryProvider<RepositoryC>(repository: RepositoryC()),
///   ],
///   child: ChildA(),
/// )
/// ```
///
/// [RepositoryProviderTree] converts the [RepositoryProvider] list
/// into a tree of nested [RepositoryProvider] widgets.
/// As a result, the only advantage of using [RepositoryProviderTree] is improved
/// readability due to the reduction in nesting and boilerplate.
class RepositoryProviderTree extends StatelessWidget {
  /// The [RepositoryProvider] list which is converted into a tree of [RepositoryProvider] widgets.
  /// The tree of [RepositoryProvider] widgets is created in order meaning the first [RepositoryProvider]
  /// will be the top-most [RepositoryProvider] and the last [RepositoryProvider] will be a direct ancestor
  /// of the `child` [Widget].
  final List<RepositoryProvider> repositoryProviders;

  /// The [Widget] and its descendants which will have access to every [Repository] provided by `repositoryProviders`.
  /// This [Widget] will be a direct descendent of the last [RepositoryProvider] in `repositoryProviders`.
  final Widget child;

  RepositoryProviderTree({
    Key key,
    @required this.repositoryProviders,
    @required this.child,
  })  : assert(repositoryProviders != null),
        assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget tree = child;
    for (final repositoryProvider in repositoryProviders.reversed) {
      tree = repositoryProvider.copyWith(tree);
    }
    return tree;
  }
}
