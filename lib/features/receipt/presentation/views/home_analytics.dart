import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/shared_ctrl.dart';
import '../../../../shared/shared_models.dart';
import '../widgets/pie_chart.dart';

final _ctrl = Get.find<SharedCtrl>();

class HomeAnalytics extends StatelessWidget {
  const HomeAnalytics({super.key});

  @override
  Widget build(BuildContext context) {
    // fetch sales data
    _ctrl.getSales();

    return Column(
      children: [
        const WeekView(),
        const SizedBox(height: 10),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.25,
          ),
          child: Obx(
            () => _ctrl.isProcessingRequest.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : PageView(
                    onPageChanged: (i) => _ctrl.swipeToPage(i),
                    controller:
                        PageController(initialPage: _ctrl.pageIndex.value),
                    padEnds: false,
                    children: [
                      RallyPieChart(
                        heroLabel: 'Watu',
                        heroAmount: _ctrl.watuTotalSalesInAmount,
                        wholeAmount: _ctrl.totalWatWeeklySales,
                        segments: buildSegmentsFromAccountItems(
                          _ctrl.dailyNumberOfSalesWatu,
                        ),
                      ),
                      RallyPieChart(
                        heroLabel: 'M-Kopa',
                        heroAmount: _ctrl.totalMkopaWeeklySales,
                        wholeAmount: _ctrl.totalMkopaWeeklySales,
                        segments: buildSegmentsFromAccountItems(
                          _ctrl.dailyNumberOfSalesMkopa,
                        ),
                      ),
                      RallyPieChart(
                        heroLabel: 'Onfon',
                        heroAmount: _ctrl.totalOnfonWeeklySales,
                        wholeAmount: _ctrl.totalOnfonWeeklySales,
                        segments: buildSegmentsFromAccountItems(
                          _ctrl.dailyNumberOfSalesOnfon,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        OrganisationButtons(onPressed: (_) {}),
      ],
    );
  }
}

class OrganisationButtons extends StatelessWidget {
  final Function(int) onPressed;

  const OrganisationButtons({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final color1 = color.inverseSurface;
    final color2 = color.primary.withOpacity(0.3);
    final font = Theme.of(context).textTheme.bodyMedium;
    final font1 = font!.copyWith(
      fontWeight: FontWeight.w700,
      color: color1,
    );

    final font2 = font.copyWith(
      fontWeight: FontWeight.w700,
      color: color2,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 15),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Spacer(),
            Text(
              'Watu',
              style: _ctrl.pageIndex.value == 0 ? font1 : font2,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'M-Kopa',
              style: _ctrl.pageIndex.value == 1 ? font1 : font2,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Onfon',
              style: _ctrl.pageIndex.value == 2 ? font1 : font2,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class WeekView extends StatelessWidget {
  const WeekView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          WeekDayTile(day: 'Mon', color: ChartColors.salesColors[0]),
          WeekDayTile(day: 'Tue', color: ChartColors.salesColors[1]),
          WeekDayTile(day: 'Wed', color: ChartColors.salesColors[2]),
          WeekDayTile(day: 'Thu', color: ChartColors.salesColors[3]),
          WeekDayTile(day: 'Fri', color: ChartColors.salesColors[4]),
          WeekDayTile(day: 'Sat', color: ChartColors.salesColors[5]),
          WeekDayTile(day: 'Sun', color: ChartColors.salesColors[6]),
        ],
      ),
    );
  }
}

class WeekDayTile extends StatelessWidget {
  final String day;
  final Color color;
  const WeekDayTile({super.key, required this.day, required this.color});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CircleAvatar(
      radius: 22,
      backgroundColor:
          dayOfTheWeek(day) ? color.withOpacity(0.5) : colorScheme.surfaceDim,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: colorScheme.surface,
        child: Center(
          child: Text(
            day,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }

  // return a boolean if today is greater than or equal to the day of the week
  bool dayOfTheWeek(String day) {
    final today = DateTime.now().weekday;
    final daysOfWeek = {
      'Mon': 1,
      'Tue': 2,
      'Wed': 3,
      'Thu': 4,
      'Fri': 5,
      'Sat': 6,
      'Sun': 7,
    };

    return today >= daysOfWeek[day]!;
  }
}
