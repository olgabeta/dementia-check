class Question {
  final String questionText;
  final List<String> options;
  final List<double> optionPoints;

  Question({
    required this.questionText,
    required this.options,
    required this.optionPoints,
  });
}

final List<Question> questions = [
  Question(
    questionText: 'Πιστεύετε ότι έχετε προβλήματα με τη μνήμη σας;',
    options: ['Ναι', 'Όχι'],
    optionPoints: [1, 0],
  ),
  Question(
    questionText: 'Δυσκολεύεστε να θυμηθείτε μια συζήτηση που είχατε πριν από λίγες ημέρες;',
    options: ['Ναι', 'Όχι'],
    optionPoints: [1, 0],
  ),
  Question(
    questionText: 'Έχετε παράπονα από τη μνήμη σας τα τελευταία 2 χρόνια;',
    options: ['Ναι', 'Όχι'],
    optionPoints: [1, 0],
  ),
  Question(
    questionText: 'Πόσο συχνά σας δυσκολεύουν τα ακόλουθα: Προσωπικές ημερομηνίες (π.χ. γενέθλια)',
    options: ['Πάντα', 'Μερικές φορές', 'Ποτέ'],
    optionPoints: [1, 0.5, 0],
  ),
  Question(
    questionText: 'Πόσο συχνά σας δυσκολεύουν τα ακόλουθα: Τηλεφωνικοί αριθμοί που χρησιμοποιείτε συχνά',
    options: ['Πάντα', 'Μερικές φορές', 'Ποτέ'],
    optionPoints: [1, 0.5, 0],
  ),
  Question(
    questionText: 'Συνολικά, πιστεύετε ότι δυσκολεύεστε να θυμηθείτε πράγματα που θέλετε να κάνετε ή να πείτε;',
    options: ['Ναι', 'Όχι'],
    optionPoints: [1, 0],
  ),
  Question(
    questionText: 'Πόσο συχνά σας δυσκολεύουν τα ακόλουθα: Να πηγαίνετε για ψώνια και να ξεχνάτε τι θέλατε να αγοράσετε',
    options: ['Πάντα', 'Μερικές φορές', 'Ποτέ'],
    optionPoints: [1, 0.5, 0],
  ),
  Question(
    questionText: 'Πιστεύετε ότι η μνήμη σας είναι χειρότερη από ό,τι ήταν πριν από 5 χρόνια;',
    options: ['Ναι', 'Όχι'],
    optionPoints: [1, 0],
  ),
  Question(
    questionText: 'Νιώθετε ότι ξεχνάτε πού είχατε τοποθετήσει τα πράγματά σας;',
    options: ['Ναι', 'Όχι'],
    optionPoints: [1, 0],
  ),
];
