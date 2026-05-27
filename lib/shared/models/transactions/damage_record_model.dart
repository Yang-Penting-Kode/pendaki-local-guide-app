class DamageReportModel {
  final List<String> damagePhotoUrls; // List path lokal gambar bukti kerusakan fisik
  final String damageDescription;
  final int claimDepositFine; // Nominal besaran tuntutan denda klaim deposit sewa

  const DamageReportModel({
    required this.damagePhotoUrls,
    required this.damageDescription,
    required this.claimDepositFine,
  });
}