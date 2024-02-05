import 'package:flutter/material.dart';
import 'package:herogame_case/components/settings.dart';

class Layout extends StatefulWidget {
  final Widget child;
  final bool noPop;
  final Widget? floatingActionButton;
  const Layout({
    super.key,
    required this.child,
    this.noPop = false,
    this.floatingActionButton,
  });

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      floatingActionButton: widget.floatingActionButton,
      body: Column(
        children: [
          SizedBox(height: topPadding + 24),
          SizedBox(
              height: 40,
              child: Row(
                children: [
                  if (!widget.noPop)
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Material(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).colorScheme.surface,
                        child: InkWell(
                          customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          onTap: () => Navigator.pop(context),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.arrow_back,
                                color: Theme.of(context).colorScheme.onSurface),
                          ),
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 24),
                  const Spacer(),
                  Text("Case App",
                      style: Theme.of(context).textTheme.titleLarge),
                  const Spacer(),
                  InkWell(
                    onTap: () => showDialog(
                        context: context,
                        builder: (context) => const SettingsPopup()),
                    child: Icon(Icons.settings,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  const SizedBox(width: 24),
                ],
              )),
          Expanded(child: SingleChildScrollView(child: widget.child)),
        ],
      ),
    );
  }
}
