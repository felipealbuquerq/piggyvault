import 'dart:async';

import 'package:flutter/material.dart';
import 'package:piggy_flutter/blocs/account_bloc.dart';
import 'package:piggy_flutter/blocs/bloc_provider.dart';
import 'package:piggy_flutter/blocs/category_bloc.dart';
import 'package:piggy_flutter/models/api_request.dart';
import 'package:piggy_flutter/screens/home/home.dart';
import 'package:piggy_flutter/screens/home/home_bloc.dart';
import 'package:piggy_flutter/widgets/common/common_dialogs.dart';
import 'package:piggy_flutter/utils/uidata.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

apiSubscription(
    {@required Stream<ApiRequest> stream,
    @required BuildContext context,
    @required GlobalKey<ScaffoldState> key}) {
  stream.listen((ApiRequest p) {
    print(p);
    if (p.isInProcess) {
      showProgress(context);
    } else {
      hideProgress(context);
      if (p.response.success == false) {
        showError(context, p.response);
      } else {
        final AccountBloc accountBloc = BlocProvider.of<AccountBloc>(context);
        final HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context);
        switch (p.type) {
          case ApiType.login:
            {
              if (p.response.result == null) {
                showErrorMessage(
                    key: key,
                    errorMessage:
                        'Something went wrong, check the credentials and try again.');
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(
                          isInitialLoading: true,
                        ),
                  ),
                );
              }
            }
            break;
          case ApiType.createOrUpdateTransaction:
          case ApiType.deleteTransaction:
          case ApiType.updateAccount:
            {
              accountBloc.accountsRefresh(true);
              homeBloc.syncData(true);
              showSuccess(
                  context: context,
                  message: UIData.success,
                  icon: FontAwesomeIcons.check);
            }
            break;
          case ApiType.createCategory:
          case ApiType.updateCategory:
            {
              final CategoryBloc categoryBloc =
                  BlocProvider.of<CategoryBloc>(context);
              categoryBloc.refreshCategories(true);

              if (p.type == ApiType.updateCategory) {
                homeBloc.syncData(true);
              }
              showSuccess(
                  context: context,
                  message: UIData.category_update_success_message,
                  icon: FontAwesomeIcons.check);
            }
            break;
          case ApiType.createAccount:
            {
              accountBloc.accountsRefresh(true);
              showSuccess(
                  context: context,
                  message: UIData.success,
                  icon: FontAwesomeIcons.check);
            }
            break;
        }
      }
    }
  });
}

void showMessage(
    {@required GlobalKey<ScaffoldState> key,
    @required Color color,
    @required String message}) {
  key?.currentState?.showSnackBar(
    SnackBar(
      backgroundColor: color,
      content: Text(message),
    ),
  );
}

void showSuccessMessage(
    {@required GlobalKey<ScaffoldState> key, @required String message}) {
  showMessage(key: key, color: Colors.greenAccent, message: message);
}

void showErrorMessage(
    {@required GlobalKey<ScaffoldState> key, @required String errorMessage}) {
  showMessage(key: key, color: Colors.red, message: errorMessage);
}
