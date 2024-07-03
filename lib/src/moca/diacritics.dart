String removeDiacritics(String str) {
  const diacriticMap = {
    'Ά': 'Α', 'ά': 'α',
    'Έ': 'Ε', 'έ': 'ε',
    'Ή': 'Η', 'ή': 'η',
    'Ί': 'Ι', 'Ϊ': 'Ι', 'ί': 'ι', 'ΐ': 'ι', 'ϊ': 'ι',
    'Ό': 'Ο', 'ό': 'ο',
    'Ύ': 'Υ', 'Ϋ': 'Υ', 'ύ': 'υ', 'ΰ': 'υ', 'ϋ': 'υ',
    'Ώ': 'Ω', 'ώ': 'ω'
  };

  StringBuffer buffer = StringBuffer();

  for (int i = 0; i < str.length; i++) {
    String char = str[i];
    if (diacriticMap.containsKey(char)) {
      buffer.write(diacriticMap[char]);
    } else {
      buffer.write(char);
    }
  }

  return buffer.toString();
}
