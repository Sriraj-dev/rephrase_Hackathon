import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rephrase_example/objects/payload.dart';

class ApiServices{
  String baseUrl = "https://personalized-brand.api.rephrase.ai/v2/campaign";

  
  String bearer_token = "Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkhNcHdjdFl4YWlRdWg4Y0M0ejN0UCJ9.eyJpc3MiOiJodHRwczovL2F1dGgucmVwaHJhc2UuYWkvIiwic3ViIjoiZ29vZ2xlLW9hdXRoMnwxMDUzNDY4MzI5NzM3MzkwNjczMzUiLCJhdWQiOlsiaHR0cHM6Ly9kaXkucmVwaHJhc2UuYWkvYXV0aDAiLCJodHRwczovL3JlcGhyYXNlYWktcHJvZC51cy5hdXRoMC5jb20vdXNlcmluZm8iXSwiaWF0IjoxNjc5NzQ3ODc2LCJleHAiOjE2Nzk4MzQyNzYsImF6cCI6IjNLVTVqdkVxV0pCQ1VLblBYMjZvbmFTUHkzakozMEo0Iiwic2NvcGUiOiJvcGVuaWQgZW1haWwgcHJvZmlsZSByZWFkOnJlcGhyYXNlLmFpIGFsbDpkaXkgcmVhZDpyZXBocmFzZS5haSJ9.A_wvc7qZPlWNpZdNJO4NcABoLbc8G_6FrOVb2A_2bElFEJnUtD9ihR8DGRN7V4fGKqe_HdaNFZ65bajt6lUpmyPL1sW7eFlBLkut80DZj0ytiz9KK-Ml1lJWELoyjFe5zPS9EHiX_hcVNiEM1BhBKR0Ly14Q2LHVICtL3zCzQWNOYAeSk6JKmjqD8cIjcmHGJZJPnl05F9Niy2rDrfJaoUSf3UfsKM3xRF8urcvDTMLN5aZafp69jiRlLtLTmNN8WPljpgLWAtrmX0DSt-JpdExI6ZxMa1f2Uv1hhdADknDvtfB3PLYq5FzfZSaZCouGUaEw860qLQnHMUgRa7ch0A";

  Future<String> createCampaign(String voiceText,String bgImage)async{
    String url = "$baseUrl/create";
    VideoDimension videoDimension = VideoDimension(
      height: 1920,
      width: 1080,
    );

    SpokespersonVideo spokespersonVideo = SpokespersonVideo(
      model: "danielle_pettee_look_2_nt_aug_2022",
      voiceId: "7bc739a4-7abc-46db-bc75-e24b6f899fa9__005",
      gender: "female",
      transcript: "<speak>$voiceText</speak>",
      transcriptType: "ssml_limited",
      outputParams: OutputParams(
        video: Video(
          crop: Crop(preset: "MS"),
          resolution: VideoDimension(
            height: 720,
            width: 1280,
          )
        )
      )
    );

    List<Elements> elements = [
      Elements(
        style: Style(
          height: "100%",
          width: "100%",
          position: "absolute",
          zIndex:1
        ),
        asset: Asset(
          kind: "Image",
          use: "Background",
          url: bgImage
        ),
      ),

      Elements(
        style: Style(
          left: "-9.259259259259252em",
          objectFit: "cover",
          bottom: "0em",
            height: "66.666em", width: "118.518518em", position: "absolute", zIndex: 2),
        asset: Asset(
          kind: "Spokesperson", 
          spokespersonVideo: spokespersonVideo
          ),
      ),
    ];

    List<Scenes> scenes = [
      Scenes(
        elements: elements
      )
    ];

    Payload payload = Payload(
      title: "Video Resume",
      thumbnailUrl: "https://rephrase-assets.s3.ap-south-1.amazonaws.com/template_thumbnails/cold_reachout_1.png",
      videoDimension: videoDimension,
      scenes: scenes
    );

    Map<String,dynamic> payloadJson = payload.toJson();
    dynamic responseJson;
    try{
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(payloadJson),
        headers: {
        //"Content-Type": "application/json",
        "content-type": "application/json",
        "accept": "application/json",
        "Authorization": bearer_token,
        }
      );

      responseJson = json.decode(response.body);
    }catch(e){
      print(e);
    }

    String campaign_id = responseJson['campaign_id'];
    String message = responseJson['message'];
    //Display this message to the user;

    print("campaign_id is -> $campaign_id \nMessage is -> $message");
    return campaign_id;
  }

  Future<bool> exportCampaign(String campaign_id)async{

    dynamic responseJson;
    String url = "$baseUrl/$campaign_id/export";
    try{
      final response = await http.post(
        Uri.parse(url),
        headers: {
        //"Content-Type": "application/json",
        "content-type": "application/json",
        "accept": "application/json",
        "Authorization": bearer_token,
        }
      );

      print("\n\n$response \n\n");

      if(response.statusCode == 200 || response.statusCode == 202){
        return true;
      }
    }catch(e){
      print(e);
    }
    return false;
  }

    Future<String> getCampaign(String campaign_id) async {
    dynamic responseJson;
    String url = "$baseUrl/$campaign_id";
    try {
      final response = await http.get(Uri.parse(url), headers: {
        //"Content-Type": "application/json",
        "content-type": "application/json",
        "accept": "application/json",
        "Authorization": bearer_token,
      });

      if (response.statusCode == 200 || response.statusCode == 202) {
        responseJson = json.decode(response.body);

        print("Response on getting the Campaign -> \n$responseJson");

        if(responseJson['status'] == "complete")
        return responseJson['video_url'];
        else {
          print("Will get the response again after 30 seconds!!");
          await Future.delayed(const Duration(seconds: 30));
          return getCampaign(campaign_id);
        }
      }
    } catch (e) {
      print(e);
    }
    return "error";
  }

}