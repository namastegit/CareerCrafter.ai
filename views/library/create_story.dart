import 'package:ai_story_maker/controllers/auth_controller.dart';
import 'package:ai_story_maker/controllers/firebase_controller.dart';
import 'package:ai_story_maker/controllers/stable_diffusion_controller.dart';
import 'package:ai_story_maker/model/brand_data.dart';
import 'package:ai_story_maker/views/auth/forgot_password.dart';
import 'package:ai_story_maker/views/brand/add_brand.dart';
import 'package:ai_story_maker/views/widgets/app_button.dart';
import 'package:ai_story_maker/views/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../../utils/text_style.dart';

class CreateStory extends StatefulWidget {
  const CreateStory({super.key});

  @override
  State<CreateStory> createState() => _CreateStoryState();
}

class _CreateStoryState extends State<CreateStory> {
  final TextEditingController _additionalController = TextEditingController();
  final _focusAdditional = FocusNode();
  String? _errorAdditional;
  final TextEditingController _descriptionController = TextEditingController();
  final _focusDescription = FocusNode();
  String? _errorDescription;

  final modelIds = [
    "absolutereality_v181.safetensors [3d9d4d2b]",

    "childrensStories_v13D.safetensors [9dfaabcb]",

    "cyberrealistic_v33.safetensors [82b0d085]",
    "deliberate_v2.safetensors [10ec4b29]",
    "dreamlike-anime-1.0.safetensors [4520e090]",
    "dreamlike-diffusion-1.0.safetensors [5c9fd6e0]",
    "dreamlike-photoreal-2.0.safetensors [fdcf65e7]",

    "dreamshaper_8.safetensors [9d40847d]",
    "edgeOfRealism_eorV20.safetensors [3ed5de15]",

    "elldreths-vivid-mix.safetensors [342d9d26]",
    "epicrealism_naturalSinRC1VAE.safetensors [90a4c676]",
    "ICantBelieveItsNotPhotography_seco.safetensors [4e7a3dfd]",

    "portraitplus_V1.0.safetensors [1400e684]",

    "Realistic_Vision_V5.0.safetensors [614d1063]",
    "redshift_diffusion-V10.safetensors [1400e684]",

    "rundiffusionFX25D_v10.safetensors [cd12b0ee]",

    "shoninsBeautiful_v10.safetensors [25d8c546]",

    "timeless-1.0.ckpt [7c4971d4]",
    "toonyou_beta6.safetensors [980f6b15]"

    // Add all the other model IDs here
  ];

  List<String> storyCategories = [
    "Linkedin Post",
    "Instagram Post",
    "Facebook Post",
    "Blog Post Image",
    "Brand Promotion Thumbnail",
    "Youtube Thumbnail",
    "Product Mockup",
  ];

  List<String> demography = [
    "Rajasthan",
    "Kerela",
    "Mexico",
    "Japan",
    "Arab",
    "Africa",
  ];

  List<String> sizes = ["portrait", "landscape", "square"];

  String? type;
  String? demographyS;
  String? size = "landscape";
  ImageModel? _selectedModel;

  List<ImageModel> imageList = [];

  @override
  void initState() {
    imageList = [
      ImageModel(
          name: "RevAnimated",
          modelId: "analog-diffusion-1.0.ckpt [9ca13f02]",
          image:
              "https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/7ba1569e-966a-4bec-765f-2bfece305300/width=1536/00006-1307711212.jpeg",
          optimizer:
              "((best quality)), ((masterpiece)), (detailed), (incredibly detailed:1.1), (complex details:1.2), (, mosaic, (photorealistic:1.2),with [high-resolution] captured in [natural light]. "),
      ImageModel(
          name: "Absolute Reality",
          modelId: "absolutereality_v181.safetensors [3d9d4d2b]",
          image:
              "https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/da6ea95b-9bf2-43a6-9aa4-e4181e7586ae/width=1536/26072202-3743294425-photo%20of%20a%20supercar,%208k%20uhd,%20high%20quality,%20road,%20sunset,%20motion%20blur,%20depth%20blur,%20cinematic,%20filmic%20image%204k,%208k%20with%20[George%20Mi.jpeg",
          optimizer:
              "8k uhd, high quality,cinematic, filmic image 4k, 8k with [George Miller's Mad Max style] ,[ultra-realistic], with [high-resolution] captured in [natural light]. The lighting should create [soft shadows] and showcase the [raw] and [vibrant colors], volumetric dtx, depth blur, blurry background, bokeh, (motion blur:1.001)"),
      // ImageModel(name: "Toon Anime",modelId: "childrensStories_v13D.safetensors [9dfaabcb]",image: "https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/2b44de68-cea1-429c-83a8-f4abf2033727/width=1024/preview.jpeg",optimizer: "(masterpiece:1.2) (illustration:1.2) (best quality:1.2) (detailed) (intricate) (8k) (cinematic lighting) (sharp focus)"),
      ImageModel(
          name: "CyberRealistic",
          modelId: "cyberrealistic_v33.safetensors [82b0d085]",
          image:
              "https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/5baf677d-04af-4d33-8ed6-ec63c9eacfa4/width=1536/3.38.jpeg",
          optimizer:
              "8k uhd, high quality,cinematic, filmic image 4k, 8k with [George Miller's Mad Max style] ,[ultra-realistic], with [high-resolution] captured in [natural light]. The lighting should create [soft shadows] and showcase the [raw] and [vibrant colors], volumetric dtx, depth blur, blurry background, bokeh, (motion blur:1.001)"),
      ImageModel(
          name: "Photography",
          modelId: "ICantBelieveItsNotPhotography_seco.safetensors [4e7a3dfd]",
          image:
              "https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/f8f23a38-ce0f-43f0-88b3-8bcfc81a6ac0/width=2880/00006-1801127420.jpeg",
          optimizer:
              "award winning professional photography epic scene:1.3), ultra detailed character with perfect face, detailed skin,(ultrasharp:1.3),(masterpiece:1.1),best quality,(photorealistic:1.2), 4k perfect quality, by Ralph Gibson, Split Lighting, dutch angle,  Magnificent, Imperceptible detail, Intricately designed, (perfect quality face:1.2) hyper-detailed complex, insanely detailed, detailed clothes, detailed skin, detailed body,"),
    ];

    final randomImage = imageList[0];
    _selectedModel = randomImage;
    setState(() {});

    SchedulerBinding.instance.addPostFrameCallback((_) {
      firebaseController.getAllBrand();
    });

    super.initState();
  }

  final StableDiffusionController _stableDiffusionController =
      Get.put(StableDiffusionController());
  @override
  void dispose() {
    _stableDiffusionController.setFinalLoadin(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FirebaseController>(
        init: FirebaseController(),
        builder: (controller) {
          return Stack(
            children: [
              Positioned.fill(
                child: Scaffold(
                  appBar: appBarWidget(context, "Define Your Story"),
                  body: SingleChildScrollView(
                      child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Select Brand",
                            style: sfBold.copyWith(
                                color: Colors.black, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            constraints: const BoxConstraints(maxHeight: 200),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.0001),
                                    spreadRadius: 1,
                                    blurRadius: 10)
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<Branddata>(
                                    value: controller.selectedBrand,
                                    isDense: true,
                                    style: sfBold.copyWith(color: Colors.black),
                                    onChanged: (Branddata? newValue) {
                                      controller.setSelectedBrand(newValue!);
                                    },
                                    items: <Branddata>[
                                      ...controller.brandData.toSet()
                                    ]
                                        .map<DropdownMenuItem<Branddata>>(
                                          (Branddata value) =>
                                              DropdownMenuItem<Branddata>(
                                            value: value,
                                            child: Text(
                                              value.name ?? '',
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    decoration: InputDecoration(
                                      hintText: "Select Brand's Name",
                                      hintStyle: sfSemiBold.copyWith(
                                          color: Colors.grey, fontSize: 18),
                                      prefixIcon: const Icon(
                                        Icons.generating_tokens,
                                        size: 30,
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide.none),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Get.to(
                                        () => const StudentManagementScreen());
                                  },
                                  child: const Text("Add Brand"))
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Select Image Type",
                            style: sfBold.copyWith(
                                color: Colors.black, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            constraints: const BoxConstraints(maxHeight: 200),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.0001),
                                    spreadRadius: 1,
                                    blurRadius: 10)
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: type,
                                    isDense: true,
                                    style: sfBold.copyWith(color: Colors.black),
                                    onChanged: (String? newValue) {
                                      type = newValue;
                                      setState(() {});
                                    },
                                    items: <String>[...storyCategories]
                                        .map<DropdownMenuItem<String>>(
                                          (String value) =>
                                              DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    decoration: InputDecoration(
                                      hintText: "Select Category",
                                      hintStyle: sfSemiBold.copyWith(
                                          color: Colors.grey, fontSize: 18),
                                      prefixIcon: const Icon(
                                        Icons.generating_tokens,
                                        size: 30,
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide.none),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Select Demography",
                            style: sfBold.copyWith(
                                color: Colors.black, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            constraints: const BoxConstraints(maxHeight: 200),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.0001),
                                    spreadRadius: 1,
                                    blurRadius: 10)
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: demographyS,
                                    isDense: true,
                                    style: sfBold.copyWith(color: Colors.black),
                                    onChanged: (String? newValue) {
                                      demographyS = newValue;
                                      setState(() {});
                                    },
                                    items: <String>[...demography]
                                        .map<DropdownMenuItem<String>>(
                                          (String value) =>
                                              DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    decoration: InputDecoration(
                                      hintText: "Select Demography",
                                      hintStyle: sfSemiBold.copyWith(
                                          color: Colors.grey, fontSize: 18),
                                      prefixIcon: const Icon(
                                        Icons.generating_tokens,
                                        size: 30,
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide.none),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Reference Image Link",
                            style: sfBold.copyWith(
                                color: Colors.black, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          MyTextField(
                            controller: _descriptionController,
                            focusNode: _focusDescription,
                            errorText: _errorDescription,
                            inputAction: TextInputAction.next,
                            icon: Icons.store_mall_directory,
                            hintText: "Reference Image Link",
                            inputType: TextInputType.text,
                            isEnabled: true,
                            fillColor: Colors.white,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Description",
                            style: sfBold.copyWith(
                                color: Colors.black, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          MyTextField(
                            controller: _additionalController,
                            focusNode: _focusAdditional,
                            errorText: _errorAdditional,
                            inputAction: TextInputAction.next,
                            icon: Icons.store_mall_directory,
                            hintText: "Brief Description of the Post",
                            inputType: TextInputType.text,
                            isEnabled: true,
                            fillColor: Colors.white,
                          ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Text(
                          //   "Example:\nThe Monster learns to make Friends\nAdventure of Children Park\nThe Legends of School",
                          //   style: sfLight.copyWith(color: Colors.white),
                          // ),
                          const SizedBox(
                            height: 20,
                          ),
                          // Text(
                          //   "Select Model",
                          //   style: sfBold.copyWith(
                          //       color: Colors.black, fontSize: 18),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // SizedBox(
                          //   height: 150,
                          //   child: GridView.builder(
                          //     itemCount: imageList.length,
                          //     shrinkWrap: true,
                          //     scrollDirection: Axis.horizontal,
                          //     gridDelegate:
                          //         const SliverGridDelegateWithFixedCrossAxisCount(
                          //       crossAxisCount: 1,
                          //       mainAxisSpacing: 8,
                          //       crossAxisSpacing: 0,
                          //       childAspectRatio: 1,
                          //     ),
                          //     itemBuilder: (context, index) {
                          //       return InkWell(
                          //         onTap: () {
                          //           _selectedModel = imageList[index];
                          //           setState(() {});
                          //         },
                          //         child: Container(
                          //           clipBehavior: Clip.antiAlias,
                          //           margin: const EdgeInsets.all(8),
                          //           decoration: BoxDecoration(
                          //             color: Colors.white,
                          //             border: Border.all(
                          //                 color: _selectedModel == imageList[index]
                          //                     ? Colors.black
                          //                     : Colors.transparent,
                          //                 width: 2),
                          //             borderRadius: BorderRadius.circular(10),
                          //           ),
                          //           child: Column(
                          //             children: [
                          //               Container(
                          //                 clipBehavior: Clip.antiAlias,
                          //                 margin: const EdgeInsets.all(8),
                          //                 decoration: BoxDecoration(
                          //                   color: Colors.white,
                          //                   borderRadius:
                          //                       BorderRadius.circular(10),
                          //                 ),
                          //                 child: Image.network(
                          //                  imageList[index].image!,
                          //                   width: 100,
                          //                   height: 100,
                          //                   fit: BoxFit.fill,
                          //                 ),
                          //               ),
                          //               Text(
                          //                 imageList[index].name!,
                          //                 style: sfBold.copyWith(
                          //                   fontSize: 12,
                          //                   color: Colors.black,
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       );
                          //     },
                          //   ),
                          // ),
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          Text(
                            "Select Image Size",
                            style: sfBold.copyWith(
                                color: Colors.black, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 150,
                            child: GridView.builder(
                              itemCount: sizes.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 0,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    size = sizes[index];
                                    setState(() {});
                                  },
                                  child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    margin: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: size == sizes[index]
                                              ? Colors.black
                                              : Colors.transparent,
                                          width: 2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          clipBehavior: Clip.antiAlias,
                                          margin: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Image.asset(
                                            "assets/app_logo.png",
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Text(
                                          sizes[index].capitalizeFirst!,
                                          style: sfBold.copyWith(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ]),
                  )),
                  bottomNavigationBar: GetBuilder<StableDiffusionController>(
                      init: StableDiffusionController(),
                      builder: (stableDiffusionController) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 10),
                          child: AppButton(
                            isLoading: stableDiffusionController.isFinalLoading,
                            title: "Start the Magic",
                            onTap: () async {
                              stableDiffusionController.setFinalLoadin(true);
                              await stableDiffusionController
                                  .generateImageViaImage(
                                      data: controller.selectedBrand,
                                      imageURL: _descriptionController.text,
                                      type: type,
                                      description: _additionalController.text,
                                      model: _selectedModel!,
                                      size: size,
                                      demography: demographyS);
                            },
                          ),
                        );
                      }),
                ),
              ),
            ],
          );
        });
  }
}

class ImageModel {
  final String? modelId;
  final String? name;
  final String? image;
  final String? optimizer;

  ImageModel({this.modelId, this.name, this.image, this.optimizer});
}
