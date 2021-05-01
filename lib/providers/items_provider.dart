import 'package:flutter/material.dart';
import 'package:fotumania/models/item_data.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ItemProvider with ChangeNotifier {
  List<ItemData> _itemsList = [
    // ItemData(
    //   serviceId: "001",
    //   name: "Portrait Shoot",
    //   itemId: "shoottype1",
    //   imageUrl:
    //       "https://images.unsplash.com/photo-1486074051793-e41332bf18fc?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxzZWFyY2h8MzF8fGJsYWNrJTIwYW5kJTIwd2hpdGUlMjBhcnR8ZW58MHx8MHw%3D&w=1000&q=80",
    //   content: "With our finest focus capture your flattering portrait sight.",
    //   classes: [
    //     {
    //       "class": "Economy",
    //       "Price": "2000.0",
    //       "Session": "2.5 hours",
    //       "Crew": "1",
    //       "Camera": "Canon eos 700D",
    //       "carouselImages": [
    //         'https://bidunart.com/wp-content/uploads/2019/12/Portrait064a.jpg',
    //         'https://s23527.pcdn.co/wp-content/uploads/2017/09/model-portrait.jpg.optimal.jpg',
    //         'https://i0.wp.com/digital-photography-school.com/wp-content/uploads/2018/09/best-camera-settings-for-portrait-photography.jpg?fit=1500%2C894&ssl=1'
    //       ],
    //     },
    //     {
    //       "class": "Standard",
    //       "Price": "4000.0",
    //       "Session": "4 hours",
    //       "Crew": "1",
    //       "Camera": "Canon eos 5d markIII",
    //       "carouselImages": [
    //         'https://bidunart.com/wp-content/uploads/2019/12/Portrait064a.jpg',
    //         'https://s23527.pcdn.co/wp-content/uploads/2017/09/model-portrait.jpg.optimal.jpg',
    //         'https://i0.wp.com/digital-photography-school.com/wp-content/uploads/2018/09/best-camera-settings-for-portrait-photography.jpg?fit=1500%2C894&ssl=1'
    //       ],
    //     },
    //     {
    //       "class": "Premium",
    //       "Price": "8000.0",
    //       "Session": "5 hours",
    //       "Crew": "2",
    //       "Camera": "Canon eos r5",
    //       "carouselImages": [
    //         'https://bidunart.com/wp-content/uploads/2019/12/Portrait064a.jpg',
    //         'https://s23527.pcdn.co/wp-content/uploads/2017/09/model-portrait.jpg.optimal.jpg',
    //         'https://i0.wp.com/digital-photography-school.com/wp-content/uploads/2018/09/best-camera-settings-for-portrait-photography.jpg?fit=1500%2C894&ssl=1'
    //       ],
    //     },
    //   ],
    //   hasClasses: true,
    //   needDate: true,
    //   needImage: true,
    //   needLocation: true,
    // ),
    // ItemData(
    //   serviceId: "001",
    //   name: "Couple Shoot",
    //   itemId: "shoottype2",
    //   imageUrl:
    //       "https://i.pinimg.com/736x/bb/b1/b6/bbb1b65c780df5d79a7b3a0898d7fd3b.jpg",
    //   content:
    //       "Add drama to your romance! Because every love story is worth watching",
    //   classes: const [
    //     {
    //       "class": "Economy",
    //       "Price": "2000.0",
    //       "Session": "2.5 hours",
    //       "Crew": "1",
    //       "Camera": "Canon eos 700D",
    //       "carouselImages": [
    //         'https://i1.wp.com/www.snapscue.com/xovirdee/2020/01/Ramya-Satish-Post-Wedding-008.jpg?fit=2048%2C1365&ssl=1',
    //       ],
    //     },
    //     {
    //       "class": "Standard",
    //       "Price": "4000.0",
    //       "Session": "4 hours",
    //       "Crew": "1",
    //       "Camera": "Canon eos 5d markIII",
    //       "carouselImages": [
    //         'https://i1.wp.com/www.snapscue.com/xovirdee/2020/01/Ramya-Satish-Post-Wedding-008.jpg?fit=2048%2C1365&ssl=1',
    //       ],
    //     },
    //     {
    //       "class": "Premium",
    //       "Price": "8000.0",
    //       "Session": "5 hours",
    //       "Crew": "2",
    //       "Camera": "Canon eos r5",
    //       "carouselImages": [
    //         'https://i1.wp.com/www.snapscue.com/xovirdee/2020/01/Ramya-Satish-Post-Wedding-008.jpg?fit=2048%2C1365&ssl=1',
    //       ],
    //     },
    //   ],
    // ),
    // ItemData(
    //   serviceId: "001",
    //   name: "Kids Shoot",
    //   itemId: "shoottype3",
    //   imageUrl:
    //       "https://static.wixstatic.com/media/8df3c2_4ae0331c51e244eeadb003db41916121~mv2_d_2048_1365_s_2.jpg",
    //   content:
    //       "Make your kid everything they want. firstly, make them face of the cuteness and charm With customised photo shoots",
    //   classes: const [
    //     {
    //       "class": "Economy",
    //       "Price": "2000.0",
    //       "Session": "2.5 hours",
    //       "Crew": "1",
    //       "Camera": "Canon eos 700D",
    //       "carouselImages": [
    //         'https://5.imimg.com/data5/MN/AV/MY-13499704/bf1p4818-500x500.jpg',
    //       ],
    //     },
    //     {
    //       "class": "Standard",
    //       "Price": "4000.0",
    //       "Session": "4 hours",
    //       "Crew": "1",
    //       "Camera": "Canon eos 5d markIII",
    //       "carouselImages": [
    //         'https://5.imimg.com/data5/MN/AV/MY-13499704/bf1p4818-500x500.jpg',
    //       ],
    //     },
    //     {
    //       "class": "Premium",
    //       "Price": "8000.0",
    //       "Session": "5 hours",
    //       "Crew": "2",
    //       "Camera": "Canon eos r5",
    //       "carouselImages": [
    //         'https://5.imimg.com/data5/MN/AV/MY-13499704/bf1p4818-500x500.jpg',
    //       ],
    //     },
    //   ],
    // ),
    // ItemData(
    //   serviceId: "001",
    //   name: "Model Shoot",
    //   itemId: "shoottype4",
    //   imageUrl: "https://wallpapercave.com/wp/wp5940129.jpg",
    //   content:
    //       "Your portfolio speaks for you and we are here to make it speak louder with our touch.",
    //   classes: const [
    //     {
    //       "class": "Economy",
    //       "Price": "2000.0",
    //       "Session": "2.5 hours",
    //       "Crew": "1",
    //       "Camera": "Canon eos 700D",
    //       "carouselImages": [
    //         'https://i.ytimg.com/vi/VyiKSfMaAW8/maxresdefault.jpg',
    //         'https://expertphotography.com/wp-content/uploads/2020/06/find-models-13.jpg',
    //       ],
    //     },
    //     {
    //       "class": "Standard",
    //       "Price": "4000.0",
    //       "Session": "4 hours",
    //       "Crew": "1",
    //       "Camera": "Canon eos 5d markIII",
    //       "carouselImages": [
    //         'https://i.ytimg.com/vi/VyiKSfMaAW8/maxresdefault.jpg',
    //         'https://expertphotography.com/wp-content/uploads/2020/06/find-models-13.jpg',
    //       ],
    //     },
    //     {
    //       "class": "Premium",
    //       "Price": "8000.0",
    //       "Session": "5 hours",
    //       "Crew": "2",
    //       "Camera": "Canon eos r5",
    //       "carouselImages": [
    //         'https://i.ytimg.com/vi/VyiKSfMaAW8/maxresdefault.jpg',
    //         'https://expertphotography.com/wp-content/uploads/2020/06/find-models-13.jpg',
    //       ],
    //     },
    //   ],
    // ),
    // ItemData(
    //   serviceId: "001",
    //   name: "Maternity Shoot",
    //   itemId: "shoottype5",
    //   imageUrl:
    //       "https://i.pinimg.com/474x/f3/e9/c8/f3e9c85e7c0ad87e557045061f2e8124.jpg",
    //   content: "MOM to be, cherish the moment you please.",
    //   classes: const [
    //     {
    //       "class": "Economy",
    //       "Price": "2000.0",
    //       "Session": "2.5 hours",
    //       "Crew": "1",
    //       "Camera": "Canon eos 700D",
    //       "carouselImages": [
    //         'https://www.golokaso.com/wp-content/uploads/2020/01/lokasoapp_80091129_552017818728715_3309969870849086585_n.jpg',
    //       ],
    //     },
    //     {
    //       "class": "Standard",
    //       "Price": "4000.0",
    //       "Session": "4 hours",
    //       "Crew": "1",
    //       "Camera": "Canon eos 5d markIII",
    //       "carouselImages": [
    //         'https://www.golokaso.com/wp-content/uploads/2020/01/lokasoapp_80091129_552017818728715_3309969870849086585_n.jpg',
    //       ],
    //     },
    //     {
    //       "class": "Premium",
    //       "Price": "8000.0",
    //       "Session": "5 hours",
    //       "Crew": "2",
    //       "Camera": "Canon eos r5",
    //       "carouselImages": [
    //         'https://www.golokaso.com/wp-content/uploads/2020/01/lokasoapp_80091129_552017818728715_3309969870849086585_n.jpg',
    //       ],
    //     },
    //   ],
    // ),
    // ItemData(
    //   serviceId: "001",
    //   name: "Newborn Shoot",
    //   itemId: "shoottype6",
    //   imageUrl:
    //       "https://i.pinimg.com/originals/38/c7/c5/38c7c5b726d793a478e1165f7c55ff5c.jpg",
    //   content:
    //       "You cannot pause their growth but you can capture the moment they hold let us together capture their innocence in a go",
    //   classes: const [
    //     {
    //       "class": "Economy",
    //       "Price": "2000.0",
    //       "Session": "2.5 hours",
    //       "Crew": "1",
    //       "Camera": "Canon eos 700D",
    //       "carouselImages": [
    //         'https://i2.wp.com/www.rebeccadanzenbaker.com/wp-content/uploads/2019/05/mom-wearing-off-white-lace-dress-to-newborn-photography-session.jpg?fit=1690%2C1127&ssl=1',
    //       ],
    //     },
    //     {
    //       "class": "Standard",
    //       "Price": "4000.0",
    //       "Session": "4 hours",
    //       "Crew": "1",
    //       "Camera": "Canon eos 5d markIII",
    //       "carouselImages": [
    //         'https://i2.wp.com/www.rebeccadanzenbaker.com/wp-content/uploads/2019/05/mom-wearing-off-white-lace-dress-to-newborn-photography-session.jpg?fit=1690%2C1127&ssl=1',
    //       ],
    //     },
    //     {
    //       "class": "Premium",
    //       "Price": "8000.0",
    //       "Session": "5 hours",
    //       "Crew": "2",
    //       "Camera": "Canon eos r5",
    //       "carouselImages": [
    //         'https://i2.wp.com/www.rebeccadanzenbaker.com/wp-content/uploads/2019/05/mom-wearing-off-white-lace-dress-to-newborn-photography-session.jpg?fit=1690%2C1127&ssl=1',
    //       ],
    //     },
    //   ],
    // ),
    // ItemData(
    //   serviceId: "002",
    //   name: "Wedding Package",
    //   itemId: "packagetype1",
    //   imageUrl:
    //       "https://i.pinimg.com/originals/59/95/e5/5995e5e81c0764fef848eaaaa917c0f1.jpg",
    //   content:
    //       "An emotion you carry for a lifetime. Every vow you take we capture with grace. We let you see What you feel in every frame.",
    //   classes: [
    //     {
    //       "class": "Economy",
    //       "Price": "2000.0",
    //       "Session": "2.5 hours",
    //       "Crew": "1",
    //       "Camera": "Canon eos 700D",
    //       "carouselImages": [
    //         'https://www.dulhaniyaa.com/assets/portfolio/8741/main/f3411198cb172b11e257bd522288dce9.jpg',
    //       ],
    //     },
    //     {
    //       "class": "Standard",
    //       "Price": "4000.0",
    //       "Session": "4 hours",
    //       "Crew": "1",
    //       "Camera": "Canon eos 5d markIII",
    //       "carouselImages": [
    //         'https://www.dulhaniyaa.com/assets/portfolio/8741/main/f3411198cb172b11e257bd522288dce9.jpg',
    //       ],
    //     },
    //     {
    //       "class": "Premium",
    //       "Price": "8000.0",
    //       "Session": "5 hours",
    //       "Crew": "2",
    //       "Camera": "Canon eos r5",
    //       "carouselImages": [
    //         'https://www.dulhaniyaa.com/assets/portfolio/8741/main/f3411198cb172b11e257bd522288dce9.jpg',
    //       ],
    //     },
    //   ],
    // ),
    // ItemData(
    //   serviceId: "002",
    //   name: "Birthday Package",
    //   itemId: "packagetype2",
    //   imageUrl:
    //       "https://www.tkphotographychicago.com/wp-content/uploads/2020/01/Smash-Cake-Minis-6429-2-scaled-1170x780.jpg",
    //   content:
    //       "Wish your favorite one a happy birthday in a very photogenic way by clicking with us the perfect stills and purest candids. Making their birthday party a blast of the day",
    //   classes: [
    //     {
    //       "class": "Economy",
    //       "Price": "2000.0",
    //       "Session": "2.5 hours",
    //       "Crew": "1",
    //       "Camera": "Canon eos 700D",
    //       "carouselImages": [
    //         'https://editaphotography.in/wp-content/uploads/2019/07/Turning_ONE_baby_photo_shoot_Pune897.jpg',
    //       ],
    //     },
    //     {
    //       "class": "Standard",
    //       "Price": "4000.0",
    //       "Session": "4 hours",
    //       "Crew": "1",
    //       "Camera": "Canon eos 5d markIII",
    //       "carouselImages": [
    //         'https://editaphotography.in/wp-content/uploads/2019/07/Turning_ONE_baby_photo_shoot_Pune897.jpg',
    //       ],
    //     },
    //     {
    //       "class": "Premium",
    //       "Price": "8000.0",
    //       "Session": "5 hours",
    //       "Crew": "2",
    //       "Camera": "Canon eos r5",
    //       "carouselImages": [
    //         'https://editaphotography.in/wp-content/uploads/2019/07/Turning_ONE_baby_photo_shoot_Pune897.jpg',
    //       ],
    //     },
    //   ],
    // ),
    // ItemData(
    //   serviceId: "002",
    //   name: "Event Package",
    //   itemId: "packagetype3",
    //   imageUrl:
    //       "https://i.pinimg.com/originals/87/c2/89/87c289ace98db2839ddb29979c702be2.jpg",
    //   content: "Event Package Content",
    //   classes: [
    //     {
    //       "class": "Economy",
    //       "Price": "2000.0",
    //       "Session": "2.5 hours",
    //       "Crew": "1",
    //       "Camera": "Canon eos 700D",
    //       "carouselImages": [
    //         'https://i.pinimg.com/originals/65/43/76/654376e2c94c69757a7f7e58c8ad7c62.jpg',
    //         'https://3.imimg.com/data3/WR/RY/MY-15555602/event-photography-service-500x500.jpg',
    //         'https://lh6.googleusercontent.com/VI1fbw7MVaQg3UthPHe0z37V67k5ll2_ieGSEOK9qT7D3DpUR7njMGu4Ba-lnA-a_lhUWYKXd6KSzS8B6vtTRdBtLkfBX-h1Lt1vMvwoCZ88iDKPecCcdF1elKylGOYGnNiPhd3G',
    //       ],
    //     },
    //     {
    //       "class": "Standard",
    //       "Price": "4000.0",
    //       "Session": "4 hours",
    //       "Crew": "1",
    //       "Camera": "Canon eos 5d markIII",
    //       "carouselImages": [
    //         'https://i.pinimg.com/originals/65/43/76/654376e2c94c69757a7f7e58c8ad7c62.jpg',
    //         'https://3.imimg.com/data3/WR/RY/MY-15555602/event-photography-service-500x500.jpg',
    //         'https://lh6.googleusercontent.com/VI1fbw7MVaQg3UthPHe0z37V67k5ll2_ieGSEOK9qT7D3DpUR7njMGu4Ba-lnA-a_lhUWYKXd6KSzS8B6vtTRdBtLkfBX-h1Lt1vMvwoCZ88iDKPecCcdF1elKylGOYGnNiPhd3G',
    //       ],
    //     },
    //     {
    //       "class": "Premium",
    //       "Price": "8000.0",
    //       "Session": "5 hours",
    //       "Crew": "2",
    //       "Camera": "Canon eos r5",
    //       "carouselImages": [
    //         'https://i.pinimg.com/originals/65/43/76/654376e2c94c69757a7f7e58c8ad7c62.jpg',
    //         'https://3.imimg.com/data3/WR/RY/MY-15555602/event-photography-service-500x500.jpg',
    //         'https://lh6.googleusercontent.com/VI1fbw7MVaQg3UthPHe0z37V67k5ll2_ieGSEOK9qT7D3DpUR7njMGu4Ba-lnA-a_lhUWYKXd6KSzS8B6vtTRdBtLkfBX-h1Lt1vMvwoCZ88iDKPecCcdF1elKylGOYGnNiPhd3G',
    //       ],
    //     },
    //   ],
    // ),
    // ItemData(
    //     serviceId: "003",
    //     name: "Posters",
    //     itemId: "printtype1",
    //     imageUrl:
    //         "https://images.template.net/wp-content/uploads/2017/01/12143529/Minimalist-Batman-Poster-Design.jpg",
    //     content: "Posters Content",
    //     classes: [
    //       {
    //         "Price": "Rs 99.00",
    //         "carouselImages": [
    //           'https://i.pinimg.com/originals/6d/63/49/6d6349cd735a710026e6d669b176d8e4.jpg',
    //         ],
    //       }
    //     ]),
    // ItemData(
    //     serviceId: "003",
    //     name: "Polaroids",
    //     itemId: "printtype2",
    //     imageUrl:
    //         "https://media-cdn.tripadvisor.com/media/photo-s/0b/3a/64/73/polaroids.jpg",
    //     content: "Polaroids Content",
    //     classes: [
    //       {
    //         "Price": "Rs 30.00 per Card",
    //         "carouselImages": [
    //           'https://www.endlessdistances.com/wp-content/uploads/2018/08/a8cfc5bd-ca67-4689-b5ee-429251451817.jpg',
    //           'https://i.pinimg.com/originals/09/d7/de/09d7de3f421f4ebd25f6d04b18187807.jpg',
    //         ],
    //       }
    //     ]),
    // ItemData(
    //     serviceId: "003",
    //     name: "Photo Strips",
    //     itemId: "printtype3",
    //     imageUrl:
    //         "https://www.socialprintstudio.com/img/products/photo-strips/inspiration/1--@jennyrwilde.jpg",
    //     content: "Photo Strips Content",
    //     hasClasses: false,
    //     needLocation: true,
    //     needImage: true,
    //     classes: [
    //       {
    //         "class": "Cards",
    //         "Price": "Rs 100 per Strip",
    //         "carouselImages": [
    //           'https://www.socialprintstudio.com/img/products/photo-strips/slider/photo-strips-slide-4.jpg',
    //           'https://www.socialprintstudio.com/img/products/photo-strips/slider/photo-strips-slide-1.jpg',
    //         ],
    //       }
    //     ]),
    // ItemData(
    //     serviceId: "003",
    //     name: "Photo Cards",
    //     itemId: "printtype4",
    //     imageUrl:
    //         "https://www.averyproducts.com.au/sites/avery.au/files/styles/crop_1_1_ratio_style/public/2020-10/weprint-cards-cards-appl1.jpg?itok=ruyfI_Bo",
    //     content: "Photo Card Content",
    //     classes: [
    //       {
    //         "Price": "Rs 1000",
    //         "carouselImages": [
    //           'https://cdn.thewirecutter.com/wp-content/uploads/2019/11/holidayphotocards-lowres-5986-630x420.jpg',
    //         ],
    //       }
    //     ]),
    // ItemData(
    //     serviceId: "005",
    //     name: "Portrait Sketch",
    //     itemId: "arttype1",
    //     imageUrl:
    //         "https://scontent-hkt1-1.cdninstagram.com/v/t51.2885-15/e35/p1080x1080/140317018_246987853498292_3833711502514381965_n.jpg?tp=1&_nc_ht=scontent-hkt1-1.cdninstagram.com&_nc_cat=108&_nc_ohc=c9HgKcuMk_4AX-4TD9l&oh=8b19414aca9ac36bf1ac575efae69166&oe=606F6194",
    //     content: "Portrait Sketch Content",
    //     classes: [
    //       {
    //         "Price": "Rs 1000",
    //         "carouselImages": [
    //           'https://www.stonedsanta.in/wp-content/uploads/2019/07/pirl-portrait.jpg',
    //           'https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/144737557/original/6fa1116c05395f571c51bf41643717537c8f7c00/draw-amazing-realistic-pencil-portrait-from-a-photo.jpg',
    //         ],
    //       }
    //     ]),
    // ItemData(
    //   serviceId: "005",
    //   name: "Vector Art",
    //   itemId: "arttype2",
    //   imageUrl:
    //       "https://scontent-hkt1-1.cdninstagram.com/v/t51.2885-15/e35/s1080x1080/118825470_3239437502759223_2909240561077762557_n.jpg?tp=1&_nc_ht=scontent-hkt1-1.cdninstagram.com&_nc_cat=103&_nc_ohc=fE3qXGTmiD4AX-hR7wA&oh=de2d0d2340a9a8332c2063e139a6f7c0&oe=606E993B",
    //   content: "Vector Art Content",
    //   classes: [
    //     {
    //       "Price": "Rs 1000",
    //       "carouselImages": [
    //         'https://i.pinimg.com/originals/ab/82/4f/ab824f73d3d56c2f915a4eb4468158ef.png'
    //       ],
    //     }
    //   ],
    // ),
    // ItemData(
    //   serviceId: "005",
    //   name: "Scribble",
    //   itemId: "arttype3",
    //   imageUrl:
    //       "https://scontent-hkt1-1.cdninstagram.com/v/t51.2885-15/sh0.08/e35/s640x640/54732143_308848249779176_9169113405298060209_n.jpg?tp=1&_nc_ht=scontent-hkt1-1.cdninstagram.com&_nc_cat=108&_nc_ohc=XZgyE8jqPtkAX8xE7lR&oh=5220ec9787483894f6e8ef13dcd65536&oe=606E0670",
    //   content: "Scribble Content",
    //   classes: [
    //     {
    //       "Price": "Rs 1000",
    //       "carouselImages": [
    //         'https://i.redd.it/klp85mz7wyr41.jpg',
    //       ],
    //     }
    //   ],
    // ),
    // ItemData(
    //   serviceId: "004",
    //   name: "Photo Frames",
    //   itemId: "producttype1",
    //   imageUrl:
    //       "https://rukminim1.flixcart.com/image/612/612/j5shoy80/normal-photo-frame/b/s/r/art-street-black-boulevard-set-of-9-individual-photo-frame-original-imaewefhdgej32as.jpeg?q=70",
    //   content: "Photo Frames Content",
    //   classes: [
    //     {
    //       "Price": "Rs 1000",
    //       "carouselImages": [
    //         'https://i.pinimg.com/originals/e2/76/e7/e276e7bc0d85e46397ec12bad8bd4ca2.jpg',
    //         'https://www.homestratosphere.com/wp-content/uploads/2018/08/wall-picture-frames-081818.jpg',
    //       ],
    //     }
    //   ],
    // ),
    // ItemData(
    //   serviceId: "004",
    //   name: "Photo Books",
    //   itemId: "producttype2",
    //   imageUrl:
    //       "https://www.pikbuk.in/blog/wp-content/uploads/2019/10/Website-Blog-7.jpg",
    //   content: "Photo Books Content",
    //   classes: [
    //     {
    //       "Price": "Rs 1000",
    //       "carouselImages": [
    //         'https://cdn.mos.cms.futurecdn.net/8h3hHzLFA3xE9WPpDsAyVa.jpg',
    //         'https://www.shutterfly.com/ideas/wp-content/uploads/2017/06/how-to-make-instagram-photo-book4.jpg',
    //       ],
    //     }
    //   ],
    // ),
  ];

  List<ItemData> get itemsList {
    return [..._itemsList];
  }

  Future<void> fetchItemsFromServer() async {
    Uri url = Uri.parse(
        "https://fotumania-33638-default-rtdb.firebaseio.com/items.json");
    try {
      final response = await http.get(url);
      final items = json.decode(response.body) as Map<String, dynamic>;
      if (items == null) {
        return;
      }
      List<ItemData> loadedData = [];
      items.forEach(
        (key, value) {
          loadedData.add(
            ItemData(
              itemId: key,
              content: items[key]['content'],
              classes: items[key]['classes'],
              imageUrl: items[key]['imageUrl'],
              name: items[key]['name'],
              serviceId: items[key]['serviceId'],
              hasClasses: items[key]['hasClasses'],
              needDate: items[key]['needDate'],
              needImage: items[key]['needImage'],
              needLocation: items[key]['needLocation'],
            ),
          );
        },
      );
      _itemsList = loadedData;
      notifyListeners();
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> addItemToService({
    String serviceId,
    String name,
    List<Map<String, dynamic>> classes,
    String imageUrl,
    String content,
    bool needDate,
    bool needLocation,
    bool needImage,
    bool hasClasses,
  }) async {
    try {
      Uri url = Uri.parse(
          "https://fotumania-33638-default-rtdb.firebaseio.com/items.json");
      final response = await http.post(
        url,
        body: json.encode(
          {
            'serviceId': serviceId,
            'name': name,
            'imageUrl': imageUrl,
            'content': content,
            'classes': classes,
            'needDate': needDate,
            'needLocation': needLocation,
            'needImage': needImage,
            'hasClasses': hasClasses,
          },
        ),
      );
      ItemData item = ItemData(
        serviceId: serviceId,
        itemId: json.decode(response.body)['name'],
        name: name,
        imageUrl: imageUrl,
        content: content,
        classes: classes,
      );
      _itemsList.add(item);

      notifyListeners();
    } catch (error) {
      throw Exception(error);
    }
  }

  List<ItemData> getItemsOfService(String serviceId) {
    return itemsList
        .where((element) => element.serviceId == serviceId)
        .toList();
  }

  Future<void> editItem({
    String id,
    String name,
    String imageUrl,
    String content,
    List<Map<String, dynamic>> classes,
    bool needLocation,
    bool needDate,
    bool needImage,
    bool hasClasses,
  }) async {
    final itemInd = _itemsList.indexWhere((item) => item.itemId == id);
    Uri url = Uri.parse(
        "https://fotumania-33638-default-rtdb.firebaseio.com/items/$id.json");
    try {
      final response = await http.patch(
        url,
        body: json.encode(
          {
            "name": name,
            "imageUrl": imageUrl,
            "content": content,
            "classes": classes,
            'needDate': needDate,
            'needLocation': needLocation,
            'needImage': needImage,
            'hasClasses': hasClasses,
          },
        ),
      );
      if (response.statusCode >= 400) throw Exception("Something went wrong!");

      _itemsList[itemInd].name = name;
      _itemsList[itemInd].imageUrl = imageUrl;
      _itemsList[itemInd].content = content;
      _itemsList[itemInd].classes = classes;

      notifyListeners();
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> removeClassFromItem(String itemId, int classIndex) async {
    final index = _itemsList.indexWhere((element) => element.itemId == itemId);
    Uri url = Uri.parse(
        "https://fotumania-33638-default-rtdb.firebaseio.com/items/${_itemsList[index].itemId}/classes/$classIndex.json");
    try {
      final response = await http.delete(url);
      if (response.statusCode >= 400) throw Exception("Error");
    } catch (error) {
      throw Exception(error);
    }
    _itemsList[index].classes.removeAt(classIndex);
    notifyListeners();
  }
}
