// enum FishboneType {
//   normal,
//   antiPersonal,
//   antiTank,
//   fragmentation,
// }

enum FishboneType {
  normal,
  antiPersonal,
  antiTank,
  fragmentation,
  single,
  double,
  tripple,
  shubham,
  sarvottam,
  ashish,
  rahul,





}


enum FishboneSection {
  mineTypes,      // For normal, antiPersonal, antiTank, fragmentation
  impactTypes,    // For single, double, tripple
  contributors    // For shubham, sarvottam, ashish, rahul
}

// Create mapping from FishboneType to FishboneSection
Map<FishboneSection, List<FishboneType>> sectionMapping = {
  FishboneSection.mineTypes: [
    FishboneType.normal,
    FishboneType.antiPersonal,
    FishboneType.antiTank,
    FishboneType.fragmentation,
  ],
  FishboneSection.impactTypes: [
    FishboneType.single,
    FishboneType.double,
    FishboneType.tripple,
  ],
  FishboneSection.contributors: [
    FishboneType.shubham,
    FishboneType.sarvottam,
    FishboneType.ashish,
    FishboneType.rahul,
  ],
};

// Add section titles
Map<FishboneSection, String> sectionTitles = {
  FishboneSection.mineTypes: 'Strip',
  FishboneSection.impactTypes: 'Row',
  FishboneSection.contributors: 'Axial'
};