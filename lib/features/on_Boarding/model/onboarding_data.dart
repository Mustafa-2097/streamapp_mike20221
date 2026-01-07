class OnboardingData {
  final String title;
  final String subtitle;
  final String image;
  OnboardingData({required this.title, required this.subtitle, required this.image});
}

final List<OnboardingData> pages = [
  OnboardingData(
    title: "LIVE. LOUD. UNSTOPPABLE.",
    subtitle: "Stream every victory in real time. From legendary rivalries to unforgettable highlights.",
    image: "assets/images/onboarding2.png",
  ),
  OnboardingData(
    title: "ALL SPORTS IN ONE APP",
    subtitle: "Stream every victory in real time. From legendary rivalries to unforgettable highlights.",
    image: "assets/images/onboarding3.png",
  ),
];