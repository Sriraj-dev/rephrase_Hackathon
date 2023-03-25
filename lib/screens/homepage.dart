import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tesseract_ocr/android_ios.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rephrase_example/services/api_services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class Controller extends GetxController{
  RxString resume_status = "".obs;
  RxString video_status = "".obs;

  changeResumeStatus(String temp){
    resume_status.value = temp;
  }
  changeVideoStatus(String temp){
    video_status.value = temp;
  }
}

class _HomePageState extends State<HomePage> {

  //Using GetX update the screen while loading!

  XFile? resume;
  String voiceText = "";
  String extractedText = "";

  Controller loadingController = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(
              (){
                return ElevatedButton.icon(
                  onPressed: (){
                    if(loadingController.resume_status == "uploaded")
                    startACampaign();
                    else{
                      Flushbar(animationDuration: Duration(seconds: 1),title: "Please Upload your resume!",
                      backgroundColor: Colors.redAccent,);
                    }
                  }, 
                  icon: (loadingController.video_status == "")?const Icon(Icons.celebration_outlined):CircularProgressIndicator(color: Colors.white,), 
                  label: (loadingController.video_status == "")?const Text("Create Video Resume!!"):
                  (loadingController.video_status == "processing")?const Text("Processing!"):
                  (loadingController.video_status == "generating")?const Text("Generating the Video !!"):const Text("Generating the Video !!")
                );
              }
            ),

            Obx((){
              return ElevatedButton.icon(
                onPressed: () async{
                  loadingController.changeResumeStatus("uploading");
                  resume = await ImagePicker().pickImage(source: ImageSource.gallery,);
                  if(resume!=null){
                    
                    extractedText =
                      await FlutterTesseractOcr.extractText(resume!.path);
                      print("\n\n The Extracted test is -> $extractedText \n\n");

                      //prompt the User that resume uploaded Successfully!!;
                      loadingController.changeResumeStatus("uploaded");
                      return ;
                  }
                  loadingController.changeResumeStatus("");
                },
                icon: (loadingController.resume_status != "uploading")?const Icon(Icons.celebration_outlined):CircularProgressIndicator(color: Colors.white,),
                label: (loadingController.resume_status == "")?const Text("Upload Resume !!"):
                (loadingController.resume_status == "uploading")?const Text("Uploading your resume!"):
                (loadingController.resume_status == "uploaded")?const Text("Successfully uploaded!!"):const Text("Upload Resume !!"),
            );
            })
          ],
        ),
      ),
    );
  }

  

  void startACampaign()async{

    loadingController.changeVideoStatus("processing");
    print("Creating a Campaign!!!\n\n");
    String campaign_id = await ApiServices().createCampaign(
      "Hello , This is Sriraj ,currently Pursuing electrical engineering from IIT BHU. Im Proficient inn programming languages like C, C++,C#,Dart , Python etc.\n Apart from that Iam very much interested in app development,gamedevelopment and have developed quite a good projects and deployed some of them. Other than that i also do have strong backround in DSA and competetive programming. Looking forward to meet you in person and would be glad to work with you!", 
      "https://rephrase-assets.s3.ap-south-1.amazonaws.com/media/panel_defaults/background/image/blue_1.webp"
    );

    //Notify the user that campaign is created and the video is being generated!!
    //show a interactive loading symbol.
    loadingController.changeResumeStatus("generating");
    print("Campaign Created Successfully\n");
    bool isExported = await ApiServices().exportCampaign(campaign_id);
    if(isExported){
      print("Waiting for the video to get processed!!\n\n");
      //prompt the user regarding this!!
      await Future.delayed(Duration(seconds: 60));
      print("Getting the campaign!!\n\n");
      String video_url = await ApiServices().getCampaign(campaign_id);
      if(video_url != "error"){
        //Got the video Url-> prompt the user regarding this!!
        print("Video Url : $video_url \n\n");
        try{
          launchUrlString(video_url);
        }catch(e){
          print("Error in launching the video -> $e");
        }
      }else{
        print("An error occured while rendering the video !! Try Again!!");
      }
    }else{
      print("An error occured while exporting the video!!");
      //Prompt the user that error occured and ask him to retry!!
      showFlushbar(
        context: context,
        flushbar: Flushbar(title: "An Error Occurred! Try again", backgroundColor: Colors.redAccent,)
      );
      loadingController.changeVideoStatus("");
    }
  }
}