import 'package:flutter/material.dart';
import 'package:herogame_case/components/custum_input.dart';
import 'package:herogame_case/components/layout.dart';
import 'package:herogame_case/manager/firebase.dart';
import 'package:herogame_case/models/user_credentials.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CredentialModel? userCredential;
  CredentialModel? dummyUserCredential;
  final TextEditingController _hobbyController = TextEditingController();
  bool hasChanges = false;
  bool isLoading = false;

  void getUserCredential() async {
    setState(() => isLoading = true);
    final userCredential = await FirebaseManager().getProfile();
    setState(() {
      this.userCredential = userCredential;
      dummyUserCredential = userCredential;
      isLoading = false;
    });
  }

  void saveChanges() async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseManager().updateProfile(userCredential!);
      setState(() {
        dummyUserCredential = userCredential;
        hasChanges = false;
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Değişiklikler kaydedildi"),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Bir hata oluştu ${e.toString()}"),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getUserCredential();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Layout(
      noPop: true,
      child: Container(
        height: size.height,
        width: size.width,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            const Divider(),
            Text("Yeni Hobiler Ekle",
                style: Theme.of(context).textTheme.titleLarge),
            Row(
              children: [
                Expanded(
                    child: CustomInput(
                        controller: _hobbyController, label: "Hobi Ekle")),
                IconButton(
                  onPressed: () {
                    setState(() {
                      userCredential?.hobbies.add(_hobbyController.text);
                      hasChanges = true;
                      _hobbyController.clear();
                    });
                  },
                  icon: const Icon(Icons.add),
                ),
                const SizedBox(width: 12),
              ],
            ),
            const Divider(),
            SizedBox(height: size.height * 0.01),
            Text("Hobilerim", style: Theme.of(context).textTheme.titleLarge),
            if (hasChanges)
              SizedBox(
                width: size.width * 0.9,
                height: size.height * 0.05,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          getUserCredential();
                          hasChanges = false;
                        });
                      },
                      child: const Text("İptal"),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: saveChanges,
                      child: const Text("Değişiklikleri Kaydet"),
                    ),
                  ],
                ),
              )
            else
              SizedBox(
                width: size.width * 0.9,
                height: size.height * 0.05,
              ),
            Expanded(
              child: !isLoading
                  ? ListView.builder(
                      itemBuilder: (context, index) {
                        return ListTile(
                          title:
                              Text(dummyUserCredential?.hobbies[index] ?? ""),
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                userCredential?.hobbies.removeAt(index);
                                hasChanges = true;
                              });
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        );
                      },
                      itemCount: dummyUserCredential?.hobbies.length ?? 0,
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
