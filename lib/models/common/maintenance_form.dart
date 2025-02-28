class MaintenanceFormModel {
  int maintenanceFee;
  bool isWaterSelected;
  bool isElectricitySelected;
  bool isInternetSelected;
  bool isHeatingSelected;
  String? others;

  MaintenanceFormModel({
    required this.maintenanceFee,
    required this.isWaterSelected,
    required this.isElectricitySelected,
    required this.isInternetSelected,
    required this.isHeatingSelected,
    required this.others,
  });
}
