class DailySchedule {
  final bool isOpen;
  final String openTime;
  final String closeTime;

  const DailySchedule({
    required this.isOpen,
    required this.openTime,
    required this.closeTime,
  });
}

class OperationalHoursModel {
  final Map<String, DailySchedule> weeklySchedule;
  final bool isOpen24HoursGlobal;
  final bool closeOnNationalHoliday;

  const OperationalHoursModel({
    required this.weeklySchedule,
    this.isOpen24HoursGlobal = false,
    this.closeOnNationalHoliday = false,
  });
}
