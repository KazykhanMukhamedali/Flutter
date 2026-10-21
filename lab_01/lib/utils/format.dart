const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String formatDate(DateTime d) => '${d.day} ${_months[d.month - 1]}';

String formatTime(DateTime d) =>
    '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

String formatDateTime(DateTime d) => '${formatDate(d)}, ${formatTime(d)}';