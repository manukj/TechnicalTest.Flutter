// Mocks generated by Mockito 5.4.5 from annotations
// in flutter_tech_task/test/data/repositories/comment_repository_impl_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:flutter_tech_task/core/error/failures.dart' as _i5;
import 'package:flutter_tech_task/data/datasources/comment_local_datasource.dart'
    as _i8;
import 'package:flutter_tech_task/data/datasources/post_remote_datasource.dart'
    as _i3;
import 'package:flutter_tech_task/data/models/comment_model.dart' as _i7;
import 'package:flutter_tech_task/data/models/post_model.dart' as _i6;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [PostRemoteDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockPostRemoteDataSource extends _i1.Mock
    implements _i3.PostRemoteDataSource {
  MockPostRemoteDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.PostModel>>> getPosts() =>
      (super.noSuchMethod(
        Invocation.method(
          #getPosts,
          [],
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, List<_i6.PostModel>>>.value(
                _FakeEither_0<_i5.Failure, List<_i6.PostModel>>(
          this,
          Invocation.method(
            #getPosts,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, List<_i6.PostModel>>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.PostModel>> getPostById(int? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #getPostById,
          [id],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.PostModel>>.value(
            _FakeEither_0<_i5.Failure, _i6.PostModel>(
          this,
          Invocation.method(
            #getPostById,
            [id],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.PostModel>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i7.CommentModel>>>
      getCommentsByPostId(int? postId) => (super.noSuchMethod(
            Invocation.method(
              #getCommentsByPostId,
              [postId],
            ),
            returnValue: _i4
                .Future<_i2.Either<_i5.Failure, List<_i7.CommentModel>>>.value(
                _FakeEither_0<_i5.Failure, List<_i7.CommentModel>>(
              this,
              Invocation.method(
                #getCommentsByPostId,
                [postId],
              ),
            )),
          ) as _i4.Future<_i2.Either<_i5.Failure, List<_i7.CommentModel>>>);
}

/// A class which mocks [CommentLocalDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockCommentLocalDataSource extends _i1.Mock
    implements _i8.CommentLocalDataSource {
  MockCommentLocalDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<List<_i7.CommentModel>> getComments(int? postId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getComments,
          [postId],
        ),
        returnValue:
            _i4.Future<List<_i7.CommentModel>>.value(<_i7.CommentModel>[]),
      ) as _i4.Future<List<_i7.CommentModel>>);

  @override
  _i4.Future<void> saveComments(
    int? postId,
    List<_i7.CommentModel>? comments,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #saveComments,
          [
            postId,
            comments,
          ],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> removeComments(int? postId) => (super.noSuchMethod(
        Invocation.method(
          #removeComments,
          [postId],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}
