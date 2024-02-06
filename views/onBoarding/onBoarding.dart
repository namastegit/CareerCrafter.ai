import 'package:ai_story_maker/utils/text_style.dart';
import 'package:ai_story_maker/views/auth/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Discover Your Perfect Career',
      'description':
          'Make smart decisions with our revolutionary AI enabled career guidance tools and expert career counsellors',
      'image': 'assets/onBoarding0.png',
    },
    {
      'title': 'Welcome to CareerCrafter.AI',
      'description':
          'Get ready to embark on a journey of self-discovery and career exploration. CareerCrafter.AI is your trusted guide to crafting the perfect career path tailored to your unique abilities and aspirations.',
      'image': 'assets/onBoarding1.png',
    },
    {
      'title': 'Your Personalized Career Guide',
      'description':
          'Our AI-powered counselor is here to assist you in finding the career that suits you best. Through personalized assessments and expert recommendations, we\'ll help you uncover opportunities you never knew existed.',
      'image': 'assets/onBoarding2.png',
    },
    {
      'title': 'Unleash Your Potential',
      'description':
          'Take quick aptitude tests to unlock your hidden talents and interests. Discover your strengths and passions, and let CareerCrafter.AI guide you towards the career of your dreams.',
      'image': 'assets/onBoarding3.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: BackgroundImage()),
        Positioned.fill(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _onboardingData.length,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      itemBuilder: (context, index) {
                        return buildOnboardingPage(_onboardingData[index]);
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => buildDotIndicator(index),
                    ),
                  ),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      if (_currentPage == _onboardingData.length - 1) {
                        GetStorage().write('isFirstTime', false);

                        Get.to(() => const RegisterView());
                      } else {
                        setState(() {
                          _currentPage = _currentPage + 1;
                          _pageController.animateToPage(_currentPage,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.bounceIn);
                        });
                      }
                    },
                    child: Container(
                        margin: const EdgeInsets.only(bottom: 80),
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.white,
                              spreadRadius: 1,
                              blurRadius: 1,
                            ),
                          ],
                        ),
                        child: Center(
                            child: Text(
                          _currentPage == _onboardingData.length - 1
                              ? 'Get Started'
                              : 'Next',
                          style: sfBold.copyWith(
                              color: Colors.white, fontSize: 18),
                        ))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildOnboardingPage(Map<String, String> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              data['image']!,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            data['title']!,
            style: sfBold.copyWith(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            data['description']!,
            style: sfRegular.copyWith(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildDotIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: _currentPage == index ? 12 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? Theme.of(context).primaryColor
            : Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
