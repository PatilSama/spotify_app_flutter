import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_app/common/helpers/is_dark_mode.dart';
import 'package:spotify_app/common/widgets/appbar/app_bar.dart';
import 'package:spotify_app/core/configs/assets/app_images.dart';
import 'package:spotify_app/core/configs/assets/app_vector.dart';
import 'package:spotify_app/core/configs/theme/app_colors.dart';
import 'package:spotify_app/presentation/home/widgets/news_songs.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: SvgPicture.asset(AppVector.logo, height: 40, width: 40),
        hideBack: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _homeTopCard(),
            _tab(),
            SizedBox(
              height: 260,
              child: TabBarView(
                controller: _tabController,
                children: [NewsSongs(), Container(), Container(), Container()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _homeTopCard() {
    return SizedBox(
      height: 180,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SvgPicture.asset(AppVector.homeTopCard),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 40.0, bottom: 0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(AppImages.homeArtiest),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tab() {
    final TextStyle? bodyStyle = Theme.of(context).textTheme.bodyMedium;
    return TabBar(
      controller: _tabController,
      labelColor: context.isDarkMode ? Colors.white : Colors.black,
      isScrollable: false,
      indicatorColor: AppColors.primary,
      tabAlignment: TabAlignment.center,
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 0),
      tabs: [
        Tab(child: Text("News", style: bodyStyle)),
        Tab(child: Text("Videos", style: bodyStyle)),
        Tab(child: Text("Artists", style: bodyStyle)),
        Tab(child: Text("Podcasts", style: bodyStyle)),
      ],
    );
  }
}
