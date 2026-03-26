import 'package:bhbd_project/providers/auth_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainVM
{
  static AuthVM authVM(BuildContext context)
  {
    return Provider.of<AuthVM>(context,listen: false);
  }
}
