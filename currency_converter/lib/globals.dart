library globals;

import 'package:flutter/material.dart';
import 'conversion_rate.dart';

Apicaller api = Apicaller.onAppStart();

List<String> currencies = api.currencies;
