class Payload {
  String? title;
  String? thumbnailUrl;
  VideoDimension? videoDimension;
  List<Scenes>? scenes;

  Payload({this.title, this.thumbnailUrl, this.videoDimension, this.scenes});

  Payload.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    thumbnailUrl = json['thumbnailUrl'];
    videoDimension = json['videoDimension'] != null
        ? new VideoDimension.fromJson(json['videoDimension'])
        : null;
    if (json['scenes'] != null) {
      scenes = <Scenes>[];
      json['scenes'].forEach((v) {
        scenes!.add(new Scenes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['thumbnailUrl'] = this.thumbnailUrl;
    if (this.videoDimension != null) {
      data['videoDimension'] = this.videoDimension!.toJson();
    }
    if (this.scenes != null) {
      data['scenes'] = this.scenes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VideoDimension {
  int? height;
  int? width;

  VideoDimension({this.height, this.width});

  VideoDimension.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['height'] = this.height;
    data['width'] = this.width;
    return data;
  }
}

class Scenes {
  List<Elements>? elements;

  Scenes({this.elements});

  Scenes.fromJson(Map<String, dynamic> json) {
    if (json['elements'] != null) {
      elements = <Elements>[];
      json['elements'].forEach((v) {
        elements!.add(new Elements.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.elements != null) {
      data['elements'] = this.elements!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Elements {
  Style? style;
  Asset? asset;

  Elements({this.style, this.asset});

  Elements.fromJson(Map<String, dynamic> json) {
    style = json['style'] != null ? new Style.fromJson(json['style']) : null;
    asset = json['asset'] != null ? new Asset.fromJson(json['asset']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.style != null) {
      data['style'] = this.style!.toJson();
    }
    if (this.asset != null) {
      data['asset'] = this.asset!.toJson();
    }
    return data;
  }
}

class Style {
  String? height;
  String? width;
  String? position;
  int? zIndex;
  String? bottom;
  String? objectFit;
  String? left;

  Style(
      {this.height,
      this.width,
      this.position,
      this.zIndex,
      this.bottom = "50%",
      this.objectFit = "100%",
      this.left = "50%"});

  Style.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    width = json['width'];
    position = json['position'];
    zIndex = json['zIndex'];
    bottom = json['bottom'];
    objectFit = json['objectFit'];
    left = json['left'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['height'] = this.height;
    data['width'] = this.width;
    data['position'] = this.position;
    data['zIndex'] = this.zIndex;
    data['bottom'] = this.bottom;
    data['objectFit'] = this.objectFit;
    data['left'] = this.left;
    return data;
  }
}

class Asset {
  String? kind;
  String? use;
  String? url;
  SpokespersonVideo? spokespersonVideo;

  Asset({this.kind, this.use = "", this.url, this.spokespersonVideo});

  Asset.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    use = json['use'];
    url = json['url'];
    spokespersonVideo = json['spokespersonVideo'] != null
        ? new SpokespersonVideo.fromJson(json['spokespersonVideo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kind'] = this.kind;
    data['use'] = this.use;
    data['url'] = this.url;
    if (this.spokespersonVideo != null) {
      data['spokespersonVideo'] = this.spokespersonVideo!.toJson();
    }
    return data;
  }
}

class SpokespersonVideo {
  String? model;
  String? voiceId;
  OutputParams? outputParams;
  String? gender;
  String? transcript;
  String? transcriptType;

  SpokespersonVideo(
      {this.model,
      this.voiceId,
      this.outputParams,
      this.gender,
      this.transcript,
      this.transcriptType = "ssml_limited"});

  SpokespersonVideo.fromJson(Map<String, dynamic> json) {
    model = json['model'];
    voiceId = json['voiceId'];
    outputParams = json['output_params'] != null
        ? new OutputParams.fromJson(json['output_params'])
        : null;
    gender = json['gender'];
    transcript = json['transcript'];
    transcriptType = json['transcript_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['model'] = this.model;
    data['voiceId'] = this.voiceId;
    if (this.outputParams != null) {
      data['output_params'] = this.outputParams!.toJson();
    }
    data['gender'] = this.gender;
    data['transcript'] = this.transcript;
    data['transcript_type'] = this.transcriptType;
    return data;
  }
}

class OutputParams {
  Video? video;

  OutputParams({this.video});

  OutputParams.fromJson(Map<String, dynamic> json) {
    video = json['video'] != null ? new Video.fromJson(json['video']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.video != null) {
      data['video'] = this.video!.toJson();
    }
    return data;
  }
}

class Video {
  Crop? crop;
  VideoDimension? resolution;
  Background? background;

  Video({this.crop, this.resolution, this.background});

  Video.fromJson(Map<String, dynamic> json) {
    crop = json['crop'] != null ? new Crop.fromJson(json['crop']) : null;
    resolution = json['resolution'] != null
        ? new VideoDimension.fromJson(json['resolution'])
        : null;
    background = json['background'] != null
        ? new Background.fromJson(json['background'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.crop != null) {
      data['crop'] = this.crop!.toJson();
    }
    if (this.resolution != null) {
      data['resolution'] = this.resolution!.toJson();
    }
    if (this.background != null) {
      data['background'] = this.background!.toJson();
    }
    return data;
  }
}

class Crop {
  String? preset;

  Crop({this.preset});

  Crop.fromJson(Map<String, dynamic> json) {
    preset = json['preset'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['preset'] = this.preset;
    return data;
  }
}

class Background {
  int? alpha;

  Background({this.alpha});

  Background.fromJson(Map<String, dynamic> json) {
    alpha = json['alpha'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alpha'] = this.alpha;
    return data;
  }
}
