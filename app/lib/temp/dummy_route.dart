//
// import 'package:angkot/temp/route.dart';
// import 'package:latlong2/latlong.dart';
//
// RoleRoute createDummyRoute() {
//
//   List<LineRoute> sharedTaxiRoute = [
//     LineRoute(
//       name: "Jl Danau Aji - Jl Belida",
//       center: LatLng(-0.44749297865279936, 116.99260067457811),
//       lines: [
//         Lines(
//           name: "Jl Pesut",
//           points: [
//             LatLng(-0.44749297865279936, 116.99260067457811),
//             LatLng(-0.4281416449081232, 116.98340776031833),
//           ],
//         ),
//         Lines(
//           name: "Jl A Moh Alimuddin",
//           points: [
//             LatLng(-0.4281416449081232, 116.98340776031833),
//             LatLng(-0.4254133801206758, 116.98489089881176),
//             LatLng(-0.423240284864, 116.98297947435951),
//           ],
//         ),
//         Lines(
//           name: "Jl Danau Aji",
//           points: [
//             LatLng(-0.423240284864, 116.98297947435951),
//             LatLng(-0.42324346815497627, 116.98297617034959),
//             LatLng(-0.42203853440060596, 116.98725141901774),
//             LatLng(-0.4205272612453894, 116.98821811531069),
//           ],
//         ),
//         Lines(
//           name: "Jl Imam Bonjol",
//           points: [
//             LatLng(-0.4205272612453894, 116.98821811531069),
//             LatLng(-0.42012561653525576, 116.98913715759198),
//             LatLng(-0.4191589461457485, 116.99169005289544),
//           ],
//         ),
//         Lines(
//           name: "Jl K.H Ahmad Muksin",
//           points: [
//             LatLng(-0.4191589461457485, 116.99169005289544),
//             LatLng(-0.41921340645255256, 116.99175813010352),
//             LatLng(-0.4233014330690566, 116.99255211421088),
//             LatLng(-0.42421307440205824, 116.99321302965438),
//             LatLng(-0.4299336687503746, 116.99492841062708),
//             LatLng(-0.4340572259916386, 116.99614523259514),
//           ],
//         ),
//         Lines(
//           name: "Jl Robert Wolter",
//           points: [
//             LatLng(-0.4340572259916386, 116.99614523259514),
//             LatLng(-0.43780744198603927, 116.99766310085833),
//             LatLng(-0.44238290764084554, 117.00030962827937),
//             LatLng(-0.4434018809507718, 117.00045146833884),
//             LatLng(-0.44409442408778543, 117.0003787699933),
//             LatLng(-0.44451443142754554, 117.00016059672933),
//             LatLng(-0.44600596771721074, 117.0003570924018),
//             LatLng(-0.44646321229480534, 117.0005096426538),
//             LatLng(-0.44720756082822155, 117.00096863606188),
//             LatLng(-0.4486301396419863, 117.00101866796807),
//             LatLng(-0.44996083633452966, 117.00110592944966),
//             LatLng(-0.4510297564288722, 117.0012295498837),
//           ],
//         ),
//         Lines(
//           name: "Jl Belida",
//           points: [
//             LatLng(-0.4510297564288722, 117.0012295498837),
//             LatLng(-0.4511663796689977, 116.99747103549878),
//             LatLng(-0.45046257436029397, 116.99575389184231),
//             LatLng(-0.4506728685036557, 116.99404853676937),
//             LatLng(-0.44749297865279936, 116.99260067457811),
//           ],
//         ),
//       ],
//     ),
//     LineRoute(
//       name: "Jl Gunung Kombeng - Jl Patin",
//       center: LatLng(-0.42336344248859076, 116.98222990581105),
//       lines: [
//         Lines(
//           name: "Jl Gunung Kombeng",
//           points: [
//             LatLng(-0.42336344248859076, 116.98222990581105),
//             LatLng(-0.42224875755762575, 116.98060324718655),
//           ],
//         ),
//         Lines(
//           name: "Jl Gunung Payang",
//           points: [
//             LatLng(-0.42224875755762575, 116.98060324718655),
//             LatLng(-0.4212868256035323, 116.97938944607766),
//           ],
//         ),
//         Lines(
//           name: "Jl Gunung Semeru",
//           points: [
//             LatLng(-0.4212868256035323, 116.97938944607766),
//             LatLng(-0.4206973845891553, 116.97976458368021),
//             LatLng(-0.4202787490639256, 116.9798993165839),
//             LatLng(-0.41951203895774003, 116.98019662032293),
//           ],
//         ),
//         Lines(
//           name: "Jl Kartini",
//           points: [
//             LatLng(-0.41951203895774003, 116.98019662032293),
//             LatLng(-0.41942989143887505, 116.9802122678879),
//             LatLng(-0.4182218567444502, 116.98032464737543),
//             LatLng(-0.41781503088375666, 116.98043613627863),
//             LatLng(-0.4174590582304248, 116.98063564273517),
//             LatLng(-0.41720674793632023, 116.98086448837768),
//             LatLng(-0.41694270227085695, 116.98119113130339),
//             LatLng(-0.41599522970302044, 116.98270448804927),
//             LatLng(-0.4151504529642239, 116.98415737905397),
//             LatLng(-0.4150035352554189, 116.98471241606379),
//             LatLng(-0.4145464579247605, 116.98722232607322),
//             LatLng(-0.4146172201718869, 116.98763604604508),
//             LatLng(-0.41467430101062946, 116.98850545390445),
//           ],
//         ),
//         Lines(
//           name: "Jl S Parman",
//           points: [
//             LatLng(-0.41467430101062946, 116.98850545390445),
//             LatLng(-0.4148082214373324, 116.98928265183875),
//             LatLng(-0.4149520212417931, 116.98967015306515),
//             LatLng(-0.41511009124757137, 116.99000715838636),
//             LatLng(-0.4152626727163905, 116.99023878093166),
//             LatLng(-0.41552063417239565, 116.99052419260435),
//             LatLng(-0.4154964845923153, 116.99060981610424),
//             LatLng(-0.41553490438303864, 116.99068665770842),
//             LatLng(-0.41561284167219775, 116.99069543960604),
//             LatLng(-0.4156723363382611, 116.99067966876403),
//           ],
//         ),
//         Lines(
//           name: "Jl Jendral Sudirman",
//           points: [
//             LatLng(-0.4156723363382611, 116.99067966876403),
//             LatLng(-0.4165037234207385, 116.99105244093158),
//             LatLng(-0.41700242030661405, 116.99128072370993),
//             LatLng(-0.4178057002162341, 116.99151965641182),
//             LatLng(-0.41913540963965606, 116.99179325436224),
//           ],
//         ),
//         Lines(
//           name: "Jl K.H Ahmad Muksin",
//           points: [
//             LatLng(-0.41913540963965606, 116.99179325436224),
//             LatLng(-0.4192148391760028, 116.99180502201618),
//             LatLng(-0.4208740337941897, 116.99210509718992),
//             LatLng(-0.42295391020347645, 116.99254050038405),
//             LatLng(-0.4236246481775316, 116.99279350494096),
//             LatLng(-0.4243954083911711, 116.99329363023281),
//             LatLng(-0.42453955820162914, 116.99330539788544),
//             LatLng(-0.4250279024303737, 116.99349073843261),
//             LatLng(-0.42583102265824857, 116.99369373046318),
//             LatLng(-0.4272695784668446, 116.9941232498293),
//             LatLng(-0.4295053702139703, 116.99475870313984),
//             LatLng(-0.429984888621698, 116.99493815986158),
//             LatLng(-0.43024082787671114, 116.99497640473693),
//             LatLng(-0.43229128347246926, 116.9956059742198),
//             LatLng(-0.4343240875527289, 116.99627673049118),
//             LatLng(-0.43590384953103467, 116.99688864849111),
//             LatLng(-0.43780132855422993, 116.99768884895661),
//           ],
//         ),
//         Lines(
//           name: "Jl Patin",
//           points: [
//             LatLng(-0.43780132855422993, 116.99768884895661),
//             LatLng(-0.4386485748564257, 116.99567069630758),
//             LatLng(-0.43929354394063863, 116.9940601221181),
//             LatLng(-0.44020256842946587, 116.99337171436375),
//             LatLng(-0.4404084962874124, 116.99313930319802),
//           ],
//         ),
//         Lines(
//           name: "Jl Pesut",
//           points: [
//             LatLng(-0.4404084962874124, 116.99313930319802),
//             LatLng(-0.44186764210820423, 116.99012972571315),
//             LatLng(-0.43946122807887805, 116.98895884415666),
//             LatLng(-0.4355132953006262, 116.98697305256577),
//             LatLng(-0.4318939653905594, 116.9851635271022),
//             LatLng(-0.4311908680229351, 116.98485168427548),
//             LatLng(-0.4290109715620947, 116.98375435055017),
//           ],
//         ),
//         Lines(
//           name: "Jl A Moh Alimudin",
//           points: [
//             LatLng(-0.4290109715620947, 116.98375435055017),
//             LatLng(-0.4283843615312672, 116.98334836648965),
//             LatLng(-0.42796073781204585, 116.9834219143273),
//             LatLng(-0.4270458282035323, 116.98401029702435),
//             LatLng(-0.4260750236634417, 116.98473989156598),
//             LatLng(-0.4252879411855064, 116.9848832379556),
//             LatLng(-0.4241080451136707, 116.98401481056608),
//             LatLng(-0.423218175410327, 116.98295819038366),
//             LatLng(-0.42336344248859076, 116.98222990581105),
//           ],
//         ),
//       ],
//     ),
//     LineRoute(
//       name: "Jl Lais - Jl A.P Mangkunegoro",
//       center: LatLng(-0.4458100880297458, 116.99575065141954),
//       lines: [
//         Lines(
//           name: "Jl Lais",
//           points: [
//             LatLng(-0.4458100880297458, 116.99575065141954),
//             LatLng(-0.44506058177818825, 116.99525801749317),
//             LatLng(-0.4442899200320154, 116.9944933771036),
//             LatLng(-0.4436539397977803, 116.99374487373773),
//             LatLng(-0.44300953260615844, 116.99304753645643),
//             LatLng(-0.4425333495780358, 116.9925726958933),
//             LatLng(-0.4423664820163722, 116.99248722459149),
//             LatLng(-0.44106526729181605, 116.99181034807192),
//           ],
//         ),
//         Lines(
//           name: "Jl Patin",
//           points: [
//             LatLng(-0.44106526729181605, 116.99181034807192),
//             LatLng(-0.44106964121993875, 116.99176660735165),
//             LatLng(-0.44143049149330676, 116.99105800760054),
//           ],
//         ),
//         Lines(
//           name: "Jl Biawan",
//           points: [
//             LatLng(-0.44143049149330676, 116.99105800760054),
//             LatLng(-0.44139515190108314, 116.99104506342073),
//             LatLng(-0.44052031519396717, 116.9906133706252),
//             LatLng(-0.43914900285564656, 116.98991230113992),
//           ],
//         ),
//         Lines(
//           name: "Jl Jelawat",
//           points: [
//             LatLng(-0.43914900285564656, 116.98991230113992),
//             LatLng(-0.43867407333816794, 116.99064314999748),
//             LatLng(-0.438518171878972, 116.99081123618748),
//             LatLng(-0.43815034185312735, 116.99104022316988),
//             LatLng(-0.4379043098314497, 116.99107919967625),
//             LatLng(-0.43631119145736075, 116.9915030691962),
//             LatLng(-0.43435024251624943, 116.99199271157089),
//             LatLng(-0.4329203328582075, 116.99231670379018),
//             LatLng(-0.43295012245923975, 116.99259134052335),
//           ],
//         ),
//         Lines(
//           name: "Jl Seluang",
//           points: [
//             LatLng(-0.43295012245923975, 116.99259134052335),
//             LatLng(-0.43290114999664464, 116.99259950282145),
//             LatLng(-0.43069738924365475, 116.9931096471265),
//             LatLng(-0.43060760637614115, 116.99341165254496),
//             LatLng(-0.4304744681880077, 116.99392259002065),
//             LatLng(-0.43021773636657873, 116.99497479933696),
//           ],
//         ),
//         Lines(
//           name: "Jl KH Ahmad Muksin",
//           points: [
//             LatLng(-0.43021773636657873, 116.99497479933696),
//             LatLng(-0.43021009388439124, 116.99497018325654),
//             LatLng(-0.4311963416392125, 116.99526509901732),
//             LatLng(-0.4323179566028494, 116.99559385756339),
//             LatLng(-0.43407176438489664, 116.99616716736995),
//             LatLng(-0.4361789506737354, 116.99699277190577),
//             LatLng(-0.43783459926395163, 116.99771024049365),
//             LatLng(-0.4385914670785504, 116.99812022253126),
//             LatLng(-0.44001847803559313, 116.99883769111882),
//             LatLng(-0.44057036064715377, 116.99914517765566),
//             LatLng(-0.4423758049014719, 117.00031993392392),
//             LatLng(-0.44314844031898276, 117.00042242942574),
//             LatLng(-0.4436214823673661, 117.00041454515224),
//             LatLng(-0.44409452437502556, 117.00035935525986),
//             LatLng(-0.44445718989374583, 117.00017013277164),
//           ],
//         ),
//         Lines(
//           name: "Jl Jemb Kutai Kartanegara",
//           points: [
//             LatLng(-0.44445718989374583, 117.00017013277164),
//             LatLng(-0.4445807825876328, 117.00014744293055),
//             LatLng(-0.4445965708795315, 117.00015434933904),
//             LatLng(-0.44462229284820265, 116.99992284465381),
//             LatLng(-0.44465030171376607, 116.99956415467625),
//             LatLng(-0.44476026896883847, 116.99919132762896),
//             LatLng(-0.44501652299707634, 116.99883753243911),
//             LatLng(-0.4451457618597238, 116.99862482039225),
//             LatLng(-0.4451457618597238, 116.99842826369071),
//             LatLng(-0.44487112927388334, 116.99810784934168),
//             LatLng(-0.44481458726797246, 116.99779551265794),
//           ],
//         ),
//         Lines(
//           name: "Jl A.P Mangkunegoro",
//           points: [
//             LatLng(-0.44481458726797246, 116.99779551265794),
//             LatLng(-0.44481189479155625, 116.9977147359313),
//             LatLng(-0.44497613585375934, 116.99738624389433),
//             LatLng(-0.4453800073032905, 116.99648154453861),
//             LatLng(-0.44579464862848756, 116.99579494235694),
//             LatLng(-0.44581618843681475, 116.99575724655116),
//           ],
//         ),
//       ],
//     ),
//   ];
//
//   List<LineRoute> busRoute = [
//     LineRoute(
//       name: "Jl Danau Aji - Jl Belida",
//       center: LatLng(-0.45103202199676123, 117.00120411771347),
//       lines: [
//         Lines(
//           name: "Jl Belida",
//           points: [
//             LatLng(-0.45103202199676123, 117.00120411771347),
//             LatLng(-0.45105714367415733, 117.00056977569241),
//             LatLng(-0.45109105793866183, 116.99966536725859),
//             LatLng(-0.45111366744831455, 116.99909885586102),
//             LatLng(-0.4511563742995712, 116.99816806885185),
//             LatLng(-0.4511739594733808, 116.9976869738122),
//             LatLng(-0.45116014254990777, 116.99747845741939),
//             LatLng(-0.4510521193362914, 116.9971367920146),
//             LatLng(-0.4508034147216133, 116.9965489265345),
//             LatLng(-0.4505961608657262, 116.99608918557786),
//             LatLng(-0.45047432071774657, 116.99568220178021),
//             LatLng(-0.45049693022957477, 116.99543851395491),
//             LatLng(-0.4505509418407339, 116.99490340563108),
//             LatLng(-0.4506049534528218, 116.9944775799917),
//             LatLng(-0.45065142855865153, 116.99414847581201),
//             LatLng(-0.4506704968527672, 116.99406462633348),
//           ],
//         ),
//         Lines(
//           name: "Jl Pesut",
//           points: [
//             LatLng(-0.45069396545513674, 116.99402036988538),
//             LatLng(-0.45037654264072735, 116.9938718965755),
//             LatLng(-0.4496363166147745, 116.99352087990829),
//             LatLng(-0.44920038997347295, 116.99333263306694),
//             LatLng(-0.4482068168162908, 116.99286980060975),
//             LatLng(-0.4474708366131096, 116.9925768149277),
//             LatLng(-0.4468022388292235, 116.99230336598997),
//             LatLng(-0.44609285998910164, 116.99204354445331),
//             LatLng(-0.4454482560737989, 116.99184081552775),
//             LatLng(-0.445306402744084, 116.9917832297636),
//             LatLng(-0.4447249445165512, 116.99160344981652),
//             LatLng(-0.44459854055054604, 116.9915556957688),
//             LatLng(-0.44295606832307977, 116.9906914075729),
//             LatLng(-0.44284528291867276, 116.99062985828684),
//             LatLng(-0.4424155698079919, 116.99041051900828),
//             LatLng(-0.4419728656261708, 116.99017723748365),
//             LatLng(-0.4409967456971565, 116.98973761934286),
//             LatLng(-0.4406975894852193, 116.98959295266889),
//             LatLng(-0.43996927735435787, 116.98923167039631),
//             LatLng(-0.43956667897018237, 116.98902607826545),
//             LatLng(-0.4382637549517513, 116.98838275436064),
//             LatLng(-0.43777184605640035, 116.98814631559458),
//             LatLng(-0.4371926335799544, 116.98785407996627),
//             LatLng(-0.4369502030035452, 116.98771779070239),
//             LatLng(-0.4361757355477604, 116.98732333813163),
//             LatLng(-0.4347355609786079, 116.98660024109952),
//             LatLng(-0.43347192449056554, 116.98599469590548),
//             LatLng(-0.432246697430694, 116.98536205200811),
//             LatLng(-0.4319076997697457, 116.98519079265553),
//             LatLng(-0.43148418451430903, 116.98501587508157),
//             LatLng(-0.4312725944460418, 116.98488028152964),
//             LatLng(-0.4311754207692308, 116.98483493253015),
//             LatLng(-0.4307369765298849, 116.9846437692929),
//             LatLng(-0.4301275610616313, 116.98435749838127),
//             LatLng(-0.42941289319882436, 116.98398168334003),
//             LatLng(-0.42896579431657617, 116.98372391248121),
//             LatLng(-0.4288169358897912, 116.98361528301997),
//           ],
//         ),
//         Lines(
//           name: "Jl A.Moh Alimuddin",
//           points: [
//             LatLng(-0.4287997146655688, 116.98359701837919),
//             LatLng(-0.42848657553003794, 116.98339987602111),
//             LatLng(-0.4284020883063991, 116.98337238337827),
//             LatLng(-0.42824719506340686, 116.98336500730304),
//             LatLng(-0.4279360675037289, 116.98344010915328),
//             LatLng(-0.42768260581750756, 116.98360104169122),
//             LatLng(-0.4273573970272474, 116.98381025399313),
//             LatLng(-0.42689342843347927, 116.98414449881311),
//             LatLng(-0.42659665382523854, 116.98437025595423),
//             LatLng(-0.4263264430572852, 116.9846013841726),
//             LatLng(-0.42591289339037286, 116.98481412512687),
//             LatLng(-0.42561212574105545, 116.98485464416643),
//             LatLng(-0.4253503176223364, 116.98483282622335),
//             LatLng(-0.4249860237724017, 116.98462741937615),
//             LatLng(-0.4248101366373399, 116.98452081363354),
//             LatLng(-0.4243522998607683, 116.98418111895536),
//             LatLng(-0.42399599944572963, 116.98381280869486),
//             LatLng(-0.423725543418691, 116.98343342142857),
//             LatLng(-0.4234798630830561, 116.98314635645056),
//             LatLng(-0.4233157856191714, 116.98297324247588),
//             LatLng(-0.4232448864573209, 116.98293910938261),
//           ],
//         ),
//         Lines(
//           name: "Jl Danau Aji",
//           points: [
//             LatLng(-0.4232472698394181, 116.9829384026321),
//             LatLng(-0.4232191074136723, 116.98305172595894),
//             LatLng(-0.42299325661838744, 116.98401729756463),
//             LatLng(-0.42277280426300073, 116.98457907470305),
//             LatLng(-0.4226899947482043, 116.98494389413115),
//             LatLng(-0.42265219151541034, 116.98517851906725),
//             LatLng(-0.4223957246196957, 116.9861699960861),
//             LatLng(-0.4222018823899492, 116.98691215505966),
//             LatLng(-0.42217049841006016, 116.98702661738596),
//             LatLng(-0.422000655689191, 116.98727031139184),
//             LatLng(-0.42106282843519777, 116.98772631454085),
//             LatLng(-0.420780372562305, 116.98794231603392),
//             LatLng(-0.42061052981064806, 116.98809739403401),
//             LatLng(-0.4203663139023087, 116.98861004369026),
//           ],
//         ),
//         Lines(
//           name: "Jl Imam Bonjol",
//           points: [
//             LatLng(-0.42034099885181886, 116.98864632598163),
//             LatLng(-0.42015077308303206, 116.98914040903541),
//             LatLng(-0.4200072201564572, 116.98945400394909),
//             LatLng(-0.41957093744652496, 116.99051941363457),
//             LatLng(-0.4191692523743, 116.99162056583748),
//           ],
//         ),
//         Lines(
//           name: "Jl K.H Ahmad Muksin",
//           points: [
//             LatLng(-0.4191543320915742, 116.99179814911523),
//             LatLng(-0.4195812980245857, 116.99187469604418),
//             LatLng(-0.42028124990558663, 116.99200195797587),
//             LatLng(-0.42096274929186434, 116.9921215136816),
//             LatLng(-0.42215028487107653, 116.99237706623192),
//             LatLng(-0.4227010724190343, 116.99247523989789),
//             LatLng(-0.42318754956296023, 116.99259914777524),
//             LatLng(-0.4235443770424348, 116.99275126295126),
//             LatLng(-0.42440414454632114, 116.99328228706386),
//             LatLng(-0.42452353575345264, 116.99329371406463),
//             LatLng(-0.4253027431925127, 116.99355866926491),
//             LatLng(-0.4272223935146942, 116.99410786277515),
//             LatLng(-0.42861512919820793, 116.99448512408291),
//             LatLng(-0.4295737171145648, 116.99479930235232),
//             LatLng(-0.42996581045489884, 116.99493660073028),
//             LatLng(-0.43021937239518077, 116.9949662868656),
//             LatLng(-0.43121259295048586, 116.9952532528444),
//             LatLng(-0.43777590884914036, 116.99766123577211),
//             LatLng(-0.4378091531254248, 116.99767634724041),
//           ],
//         ),
//         Lines(
//           name: "Jl Robert Wolter Mongsidi",
//           points: [
//             LatLng(-0.4378308357997265, 116.9976921381771),
//             LatLng(-0.4387466239014244, 116.99817470823862),
//             LatLng(-0.4419729917235994, 117.00004663819203),
//             LatLng(-0.44240608062270537, 117.00031405675738),
//             LatLng(-0.4430658871795901, 117.00043323242195),
//             LatLng(-0.44330854507456796, 117.00041987762025),
//             LatLng(-0.44347597159317065, 117.0004348714891),
//             LatLng(-0.4438180504980924, 117.00041741910185),
//             LatLng(-0.4440795091671822, 117.00037259626922),
//             LatLng(-0.4442139736279161, 117.00028855345789),
//             LatLng(-0.44459682379830845, 117.00014661448786),
//             LatLng(-0.44472942069977406, 117.0001391440156),
//             LatLng(-0.4453774645961409, 117.00023439253468),
//             LatLng(-0.4464158287643799, 117.00049772667599),
//             LatLng(-0.4470065611098346, 117.000827984103),
//             LatLng(-0.4470853646730341, 117.00083636771505),
//             LatLng(-0.44728488856772725, 117.00095541501187),
//             LatLng(-0.44746764574863473, 117.00093194089688),
//             LatLng(-0.4484114426693963, 117.00098074694525),
//             LatLng(-0.4488352321000711, 117.00105026411997),
//             LatLng(-0.44949483527876577, 117.00105762598886),
//             LatLng(-0.4504615690278102, 117.00116367157494),
//             LatLng(-0.45070222692005757, 117.00120437232908),
//             LatLng(-0.4510225142377478, 117.00125038187757),
//             LatLng(-0.45103136195351223, 117.00120260273108),
//           ],
//         ),
//       ],
//     ),
//     LineRoute(
//       name: "Jl Kartini - Jl Patin",
//       center: LatLng(-0.41942467521664395, 116.98021395384428),
//       lines: [
//         Lines(
//           name: "Jl Kartini",
//           points: [
//             LatLng(-0.41942467521664395, 116.98021395384428),
//             LatLng(-0.41940799377131566, 116.98021501685626),
//             LatLng(-0.4189580652594492, 116.98026799048277),
//             LatLng(-0.4183948164046072, 116.98031828190045),
//             LatLng(-0.4180179760744676, 116.98037661994704),
//             LatLng(-0.41779804077934923, 116.9804456868327),
//             LatLng(-0.4175559778488916, 116.980586502804),
//             LatLng(-0.4173722514118451, 116.98071390772854),
//             LatLng(-0.4172575900201245, 116.98081046725032),
//             LatLng(-0.41714292862169927, 116.9809734114494),
//             LatLng(-0.41694310934516526, 116.9812020697647),
//             LatLng(-0.41683649435689124, 116.98134757960527),
//             LatLng(-0.4166836124872651, 116.98159233117603),
//             LatLng(-0.4166138768981017, 116.98172241830952),
//             LatLng(-0.4165086029742974, 116.98189273858681),
//             LatLng(-0.4162021686857752, 116.98242649817972),
//             LatLng(-0.4160129221130351, 116.98269395551527),
//             LatLng(-0.41547196573281414, 116.98357482851972),
//             LatLng(-0.4151399348316748, 116.98422867701238),
//             LatLng(-0.4150244602426541, 116.98460118546382),
//             LatLng(-0.4149710687615816, 116.98489919223755),
//             LatLng(-0.414684244776732, 116.98608376907862),
//             LatLng(-0.4145517567099546, 116.98727215433566),
//             LatLng(-0.41461979953553985, 116.9876417602864),
//             LatLng(-0.41464199147772546, 116.98804871671855),
//             LatLng(-0.4146711555060931, 116.98851026264647),
//           ],
//         ),
//         Lines(
//           name: "Jl S Parman",
//           points: [
//             LatLng(-0.4146816566501166, 116.98850778257349),
//             LatLng(-0.4148038244511679, 116.98925318033922),
//             LatLng(-0.4150218707739718, 116.98982228070508),
//             LatLng(-0.4152820674203373, 116.99027022870662),
//             LatLng(-0.4154932500182916, 116.99049450660267),
//             LatLng(-0.4155188973821292, 116.99052565064767),
//             LatLng(-0.41549691392741495, 116.99060625876416),
//             LatLng(-0.4155372169276694, 116.99067953887007),
//             LatLng(-0.4156141590185079, 116.99069236288858),
//             LatLng(-0.4156636217907818, 116.99067404286211),
//           ],
//         ),
//         Lines(
//           name: "Jl Jend. Sudirman",
//           points: [
//             LatLng(-0.4157890126858483, 116.9907211089129),
//             LatLng(-0.4163985329185834, 116.99100093883341),
//             LatLng(-0.41651213300372186, 116.991051021912),
//             LatLng(-0.41699108281698455, 116.99126866002321),
//             LatLng(-0.41762831693697827, 116.99146251632912),
//             LatLng(-0.4191667524877723, 116.9917966090894),
//           ],
//         ),
//         Lines(
//           name: "Jl K.H Ahmad Muksin",
//           points: [
//             LatLng(-0.4191543320915742, 116.99179814911523),
//             LatLng(-0.4195812980245857, 116.99187469604418),
//             LatLng(-0.42028124990558663, 116.99200195797587),
//             LatLng(-0.42096274929186434, 116.9921215136816),
//             LatLng(-0.42215028487107653, 116.99237706623192),
//             LatLng(-0.4227010724190343, 116.99247523989789),
//             LatLng(-0.42318754956296023, 116.99259914777524),
//             LatLng(-0.4235443770424348, 116.99275126295126),
//             LatLng(-0.42440414454632114, 116.99328228706386),
//             LatLng(-0.42452353575345264, 116.99329371406463),
//             LatLng(-0.4253027431925127, 116.99355866926491),
//             LatLng(-0.4272223935146942, 116.99410786277515),
//             LatLng(-0.42861512919820793, 116.99448512408291),
//             LatLng(-0.4295737171145648, 116.99479930235232),
//             LatLng(-0.42996581045489884, 116.99493660073028),
//             LatLng(-0.43021937239518077, 116.9949662868656),
//             LatLng(-0.43121259295048586, 116.9952532528444),
//             LatLng(-0.43777590884914036, 116.99766123577211),
//             LatLng(-0.4378091531254248, 116.99767634724041),
//           ],
//         ),
//         Lines(
//           name: "Jl Patin",
//           points: [
//             LatLng(-0.4378309314009536, 116.99762222883025),
//             LatLng(-0.43864676976462535, 116.99567100586655),
//             LatLng(-0.4391830550962008, 116.99426749460137),
//             LatLng(-0.4392971583484485, 116.99405639738066),
//             LatLng(-0.44018922468173094, 116.99339061090443),
//             LatLng(-0.4403939118462109, 116.99313612745921),
//             LatLng(-0.4407430130587694, 116.9924465370604),
//             LatLng(-0.44089830589046913, 116.9921167301573),
//             LatLng(-0.4410535987107062, 116.991804534312),
//             LatLng(-0.44163154413665795, 116.99065021016679),
//             LatLng(-0.4418204570415157, 116.99026757012713),
//             LatLng(-0.44186078245529165, 116.9901844475836),
//             LatLng(-0.44187821629509083, 116.99014086168778),
//           ],
//         ),
//         Lines(
//           name: "Jl Pesut",
//           points: [
//             LatLng(-0.44188376942321245, 116.99014521414027),
//             LatLng(-0.4409967456971565, 116.98973761934286),
//             LatLng(-0.4406975894852193, 116.98959295266889),
//             LatLng(-0.43996927735435787, 116.98923167039631),
//             LatLng(-0.43956667897018237, 116.98902607826545),
//             LatLng(-0.4382637549517513, 116.98838275436064),
//             LatLng(-0.43777184605640035, 116.98814631559458),
//             LatLng(-0.4371926335799544, 116.98785407996627),
//             LatLng(-0.4369502030035452, 116.98771779070239),
//             LatLng(-0.4361757355477604, 116.98732333813163),
//             LatLng(-0.4347355609786079, 116.98660024109952),
//             LatLng(-0.4319076997697457, 116.98519079265553),
//             LatLng(-0.43148418451430903, 116.98501587508157),
//             LatLng(-0.4312725944460418, 116.98488028152964),
//             LatLng(-0.4311754207692308, 116.98483493253015),
//             LatLng(-0.4307369765298849, 116.9846437692929),
//             LatLng(-0.4301275610616313, 116.98435749838127),
//             LatLng(-0.42941289319882436, 116.98398168334003),
//             LatLng(-0.42896579431657617, 116.98372391248121),
//             LatLng(-0.4288169358897912, 116.98361528301997),
//           ],
//         ),
//         Lines(
//           name: "Jl A Moh Alimuddin",
//           points: [
//             LatLng(-0.4287997146655688, 116.98359701837919),
//             LatLng(-0.42848657553003794, 116.98339987602111),
//             LatLng(-0.4284020883063991, 116.98337238337827),
//             LatLng(-0.42824719506340686, 116.98336500730304),
//             LatLng(-0.4279360675037289, 116.98344010915328),
//             LatLng(-0.42768260581750756, 116.98360104169122),
//             LatLng(-0.4273573970272474, 116.98381025399313),
//             LatLng(-0.42689342843347927, 116.98414449881311),
//             LatLng(-0.42659665382523854, 116.98437025595423),
//             LatLng(-0.4263264430572852, 116.9846013841726),
//             LatLng(-0.42591289339037286, 116.98481412512687),
//             LatLng(-0.42561212574105545, 116.98485464416643),
//             LatLng(-0.4253503176223364, 116.98483282622335),
//             LatLng(-0.4249860237724017, 116.98462741937615),
//             LatLng(-0.4248101366373399, 116.98452081363354),
//             LatLng(-0.4243522998607683, 116.98418111895536),
//             LatLng(-0.42399599944572963, 116.98381280869486),
//             LatLng(-0.423725543418691, 116.98343342142857),
//             LatLng(-0.4234798630830561, 116.98314635645056),
//             LatLng(-0.4233157856191714, 116.98297324247588),
//             LatLng(-0.4232448864573209, 116.98293910938261),
//           ],
//         ),
//         Lines(
//           name: "Jl Gunung Gandek",
//           points: [
//             LatLng(-0.42317170805325727, 116.98292392032356),
//             LatLng(-0.4224247331868761, 116.98267112212355),
//             LatLng(-0.4218376891428292, 116.98246768750444),
//             LatLng(-0.4215010837314155, 116.98233361223265),
//             LatLng(-0.4214968048494368, 116.98233218590053),
//             LatLng(-0.42070093271564324, 116.98197845539514),
//             LatLng(-0.4198423035445543, 116.98152060260408),
//           ],
//         ),
//         Lines(
//           name: "Jl Gn Kinibalu",
//           points: [
//             LatLng(-0.4198277482282645, 116.98150784159223),
//             LatLng(-0.41981769021466586, 116.98140122378695),
//             LatLng(-0.4196500566499811, 116.98084198321511),
//             LatLng(-0.4194240865973558, 116.98021367575342),
//           ],
//         ),
//       ],
//     ),
//   ];
//
//   return RoleRoute(bus: busRoute, sharedTaxi: sharedTaxiRoute);
// }
