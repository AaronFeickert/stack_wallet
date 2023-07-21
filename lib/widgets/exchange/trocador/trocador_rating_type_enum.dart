/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

enum TrocadorKYCType {
  a,
  b,
  c,
  d;

  static TrocadorKYCType fromString(String type) {
    for (final result in values) {
      if (result.name == type.toLowerCase()) {
        return result;
      }
    }
    throw ArgumentError("Invalid trocador kyc type: $type");
  }
}