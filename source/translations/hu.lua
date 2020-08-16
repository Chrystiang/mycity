lang.hu = {
	-- profile
	profile_basicStats = "Általános adatok",
	profile_coins = "Érmék",
	profile_spentCoins = "Elköltött érmék",
	profile_purchasedHouses = "Vásárolt házak",
	profile_purchasedCars = "Vásárolt járművek",
	profile_completedQuests = "Küldetések",
	profile_completedSideQuests = "Mellékküldetések",
	profile_questCoins = "Küldetéspontok",
	profile_jobs = "Munkák",
	profile_arrestedPlayers = "Letartóztatott játékosok",
	profile_robbery = "Rablások",
	profile_fishes = "Horgászások",
	profile_gold = "Gyűjtött aranyrög",
	profile_seedsPlanted = "Learatott növények",
	profile_seedsSold = "Eladott magok",
	profile_cookedDishes = "Megfőzött ételek",
	profile_fulfilledOrders = "Teljesített megrendelések",
	profile_capturedGhosts = "Elfogott szellemek",
	profile_badges = "Kitűzők",
	-- quests
	questsName = "Küldetések",
	quests = {
		[1] = {
			name = "Küldetés 01: Csónaképítés",
			[0] = {
				_add = "Beszélj vele: Kane",
				dialog = "Hé! Hogy vagy? Nemrég valaki felfedezett egy kis szigetet a tenger után. Sok fa van ott néhány épülettel.\nAhogyan te is tudod, nincs repülőtér a városban. Jelen pillanatban csak egy csónakkal lehet oda eljutni.\nÉpíthetek neked egyet, de először egy kis segítségre lesz szükségem.\nA következő kalandom során meg szeretném tudni, mi található a Bánya másik oldalán. Van néhány elméletem, és ezekről kell meggyőződnöm.\nAzt hiszem hosszú felfedezés lesz, szóval sok ételre lesz szükségem.\nTudsz nekem fogni 5 halat?"
			},
			[1] = {
				_add = "Fogj %s halat"
			},
			[2] = {
				_add = "Beszélj vele: Kane",
				dialog = "Hűha! Köszönöm a halakat! Alig várom, hogy megehessem őket a felfedezésemen.\nMost hozz nekem 3 darab Coca-cola-t. A Boltban tudod megvásárolni."
			},
			[3] = {
				_add = "Vásárolj %s Coca-Cola-t"
			},
			[4] = {
				_add = "Beszélj vele: Kane",
				dialog = "Köszönöm, hogy hoztál nekem valamennyi élelmet! Most rajtam a sor, hogy viszonozzam a szivességed.\nDe először szükségem lesz néhány fa deszkára a csónakod megépítéséhez.\nNemrég láttam, hogy Chrystian fákat vág ki. Kérdezd meg, hogy adna-e néhány deszkát!"
			},
			[5] = {
				_add = "Beszélj vele: Chrystian",
				dialog = "Szóval deszkákat akarsz? Tudok adni néhányat, de előtte szükségem van egy gabonapehelyre.\nTudnál hozni?"
			},
			[6] = {
				_add = "Vásárolj egy gabonapelyhet"
			},
			[7] = {
				_add = "Beszélj vele: Chrystian",
				dialog = "Köszönöm, hogy segítettél! Itt vannak a deszkák, amiket kértél. Vedd jó hasznukat!"
			},
			[8] = {
				_add = "Beszélj vele: Kane",
				dialog = "Túl sokáig tartott... Már azt hittem, hogy elfelejtetted beszerezni a deszkákat...\nEgybébként, most már megépíthetem a csónakod...\nKész is van! Érezd jól magad a szigeten, és ne felejts el óvatos maradni!"
			}
		},
		[2] = {
			name = "Küldetés 02: Az elveszett kulcsok",
			[0] = {
				_add = "Menj a szigetre"
			},
			[1] = {
				_add = "Beszélj vele: Indy",
				dialog = "Hé! Te meg ki vagy? Még soha sem láttalak ez előtt...\nA nevem Indy! Hosszú ideje ezen a szigeten élek. Nagyszerű helyekkel találkozhatsz itt.\nA Bájitalbolt tulajdonosa vagyok. Meghívnálak, hogy megismerd az ütletem, de van egy nagy problémám: elvesztettem az üzletem kulcsait!!\nTalán a bányászatom során vesztettem el. Tudsz nekem segíteni?"
			},
			[2] = {
				_add = "Menj a Bányába"
			},
			[3] = {
				_add = "Keresd meg Indy kulcsát"
			},
			[4] = {
				_add = "Vidd el neki a kulcsot: Indy",
				dialog = "Köszönöm! Most már visszamehetek az üzletbe!\nVárjunk csak...\n1 kulcs hiányzik: az üzlet kulcsa! Vissza tudnál menni?"
			},
			[5] = {
				_add = "Menj vissza a Bányába"
			},
			[6] = {
				_add = "Keresd meg Indy hiányzó kulcsát"
			},
			[7] = {
				_add = "Vidd el neki a kulcsot: Indy",
				dialog = "Végre! Jobban kéne figyelned, mert akár egy filmet is megnézhettem volna, amíg vártam rád.\nMég mindig akarsz találkozni az üzletnél? Megyek oda!"
			}
		},
		[3] = {
			name = "Küldetés 03: A Rablás",
			[0] = {
				_add = "Menj a Rendőrségre"
			},
			[1] = {
				_add = "Beszélj vele: Sherlock",
				dialog = "Szia. Nincsenek rendőröktisztek a városban, ezért a te segítségedre van szükségem, de nem túl nehéz a feladat.\nEgy titokzatos rablás volt a Bankban, de eddig nem találtak gyanusítottat...\nAzt hiszem, van néhány nyom ott.\nColt-nak többet kell tudnia a történtekről. Beszélj vele."
			},
			[2] = {
				_add = "Menj a Bankba"
			},
			[3] = {
				_add = "Beszélj vele: Colt",
				dialog = "MICSODA?! Sherlock küldött ide? Mondtam neki, hogy gondoskodom az ügyről.\nAdd át neki, hogy nincs szükségem segítségetekre! Boldogulok egyedül!"
			},
			[4] = {
				_add = "Menj vissza a Rendőrségre"
			},
			[5] = {
				_add = "Beszélj vele: Sherlock",
				dialog = "Tudtam, hogy nem akar segíteni nekünk...\nNélküle kell nyomokat keresnünk.\nA Bankba kell mennünk, amikor Colt nincs ott. Meg tudod csinálni, igaz?"
			},
			[6] = {
				_add = "Lépj be a Bankba, amikor kirabolják"
			},
			[7] = {
				_add = "Keress néhány nyomot a Bankban"
			},
			[8] = {
				_add = "Menj a Rendőrségre"
			},
			[9] = {
				_add = "Beszélj vele: Sherlock",
				dialog = "Nagyon jó! Ez a ruha segíthet megtalálni a gyanusítottat.\nBeszélj Indy-vel. Ő segíteni fog nekünk."
			},
			[10] = {
				_add = "Beszélj vele: Indy.",
				dialog = "Szóval... Szükséged van a segítségemre ebben a nyomozásban?\nHmm... Hadd lássam azt a ruhát...\nLáttam már ezt valahol! A Kórházban használják! Menj, nézd meg!"
			},
			[11] = {
				_add = "Menj a Kórházba"
			},
			[12] = {
				_add = "Keress valami gyanúsat a Kórházban"
			},
			[13] = {
				_add = "Menj a Bányába"
			},
			[14] = {
				_add = "Keresd meg a gyanusítottat és tartóztasd le"
			},
			[15] = {
				_add = "Menj a Rendőrségre"
			},
			[16] = {
				_add = "Beszélj vele: Sherlock",
				dialog = "Szép munka! Igazán ügyes vagy.\nTudok egy nagyszerű helyet az energiád feltöltésére: a Kávézó!"
			}
		},
		[4] = {
			name = "Küldetés 04: Az elveszett szósz!",
			[0] = {
				_add = "Beszélj vele: Kariina",
				dialog = "Helló! Szeretnél valamilyen pizzát enni?\nNos... Rossz hírem van a számodra.\nKorábban elkezdtem készíteni néhány pizzát, majd észrevettem, hogy az összes szósz eltűnt!\nMegpróbáltam vásárolni néhány paradicsomot a Boltban, de nyilván nem árulnak.\nNéhány héttel ez előtt költöztem ebbe a városba és sajnos nem ismerek itt senkit, aki segíteni tudna.\nSzóval, te tudsz nekem segíteni, kérlek? Csak szószra van szükségem, hogy megnyithassam a Pizzériám."
			},
			[1] = {
				_add = "Menj a szigetre"
			},
			[2] = {
				_add = "Menj a Magboltba"
			},
			[3] = {
				_add = "Vásárolj egy magot"
			},
			[4] = {
				_add = "Menj a házadba"
			},
			[5] = {
				_add = "Ültess egy rejtélyes magot a házadba (Szükséged lesz egy kertre!)"
			},
			[6] = {
				_add = "Takarítsd be a paradicsomot"
			},
			[7] = {
				_add = "Menj a Magboltba"
			},
			[8] = {
				_add = "Vegyél egy Vizesvödröt"
			},
			[9] = {
				_add = "Menj a Boltba"
			},
			[10] = {
				_add = "Várásolj néhány sót"
			},
			[11] = {
				_add = "Főzz egy szószt (Szükséged lesz egy sütőre!)"
			},
			[12] = {
				_add = "Add oda a szószt neki: Kariina",
				dialog = "Azta! Köszönöm! Most már csak egy csípős szószra lesz szükségem. Készítenél egyet?"
			},
			[13] = {
				_add = "Ültess egy rejtélyes magot a házadba"
			},
			[14] = {
				_add = "Takarítsd be a paprikát"
			},
			[15] = {
				_add = "Főzz egy csípős szószt"
			},
			[16] = {
				_add = "Add oda a csípős szószt neki: Kariina",
				dialog = "ÚR ISTEN! Megcsináltad! Köszönöm!\nAmíg távol voltál, rájöttem, hogy több búzára van szükségem, hogy tésztát tudjak készíteni... Hoznál nekem néhány búzát?"
			},
			[17] = {
				_add = "Ültess egy rejtélyes magot a házadba"
			},
			[18] = {
				_add = "Takarítsd be a búzát"
			},
			[19] = {
				_add = "Add oda a búzát neki: Kariina",
				dialog = "Ismét köszönöm! Dolgozhatnál velem, ha új alkalmazottra lesz szükségem.\nKöszönöm a segítséget. Most megyek és befejezem a pizzákat!"
			}
		},
		[5] = {
			name = "Küldetés 05: ???",
			[0] = {
				_add = "???"
			}
		}
	},
	-- side quests
	_2ndquest = "Mellékküldetés",
	sideQuests = {
		[1] = "Ültess %s magot Oliver kertjébe.",
		[2] = "Trágyázd be a növényeket %s alkalommal Oliver kertjében.",
		[3] = "Gyűjts %s érmét.",
		[4] = "Tartóztass le egy tolvajt %s alkalommal.",
		[5] = "Használj %s tárgyat.",
		[6] = "Költs el %s érmét.",
		[7] = "Horgássz %s alkalommal.",
		[8] = "Bányássz %s aranyrögöt.",
		[9] = "Rabold ki a bankot anélkül, hogy letartóztatnának.",
		[10] = "Teljesíts %s rablást.",
		[11] = "Főzz %s alkalommal.",
		[12] = "Szerezz %s xp-t.",
		[13] = "Fogj ki %s békát.",
		[14] = "Fogj ki %s oroszlánhalat.",
		[15] = "Szállíts ki %s megrendelést.",
		[16] = "Szállíts ki %s megrendelést.",
		[17] = "Készíts egy pizzát.",
		[18] = "Készíts egy bruschettat.",
		[19] = "Készíts egy limonádét.",
		[20] = "Készíts egy béka szendvicset."
	},
	-- jobs
	job = "Munka",
	police = "Rendőr",
	thief = "Rabló",
	fisher = "Horgász",
	miner = "Bányász",
	farmer = "Farmer",
	chef = "Séf",
	ghostbuster = "Szellemírtó",
	ghost = "Szellem",
	-- badge Descs
	badgeDesc_0 = "Halloween 2019",
	badgeDesc_1 = "Találkoztál a #mycity alkotójával!",
	badgeDesc_2 = "500 kifogott hal",
	badgeDesc_3 = "1000 bányászott aranyrög",
	badgeDesc_4 = "500 betakarított növény",
	badgeDesc_5 = "500 teljesített lopás",
	badgeDesc_6 = "Karácsony 2019",
	badgeDesc_7 = "Megvásároltad a Szánt!",
	badgeDesc_9 = "500 teljesített megrendelés",
	badgeDesc_10 = "500 letartóztatott rabló",
	-- fish
	item_fish_SmoltFry = "Ponty",
	item_fish_Frog = "Béka",
	item_fish_RuntyGuppy = "Runty Guppy",
	item_fish_Dogfish = "Kutyahal",
	item_fish_Catfish = "Macskahal",
	item_fish_Lionfish = "Oroszlán hal",
	item_fish_Lobster = "Homár",
	item_fish_Goldenmare = "Aranyhal",
	-- furnitures
	furniture = "Bútor",
	furnitures = "Bútorok",
	furniture_bed = "Ágy",
	furniture_painting = "Festmény",
	furniture_derp = "Galamb",
	furniture_spiderweb = "Pókháló",
	furniture_candle = "Gyertya",
	furniture_chest = "Láda",
	furniture_hayWagon = "Szénás Kocsi",
	furniture_apiary = "Méh doboz",
	furniture_rip = "RIP",
	furniture_shelf = "Polc",
	furniture_diningTable = "Ebédlő Asztal",
	furniture_bookcase = "Könyvespolc",
	furniture_cauldron = "Üst",
	furniture_scarecrow = "Madárijesztő",
	furniture_fence = "Kerítés",
	furniture_oven = "Sütő",
	furniture_testTubes = "Kémcsövek",
	furniture_pumpkin = "Tök",
	furniture_cross = "Kereszt",
	furniture_hay = "Széna",
	furniture_tv = "Televízió",
	furniture_sofa = "Kanapé",
	furniture_kitchenCabinet = "Konyhaszekrény",
	furniture_flowerVase = "Virágcserép",
	furniture_nightstand = 'Éjjeli szekrény',
	furniture_bush = 'Bokor',
	furniture_armchair = 'Fotel',
	furniture_christmasSnowman = "Hóember",
	furniture_christmasSocks = "Karácsonyi Zokni",
	furniture_christmasGift = "Ajándékdoboz",
	furniture_christmasFireplace = "Kandalló",
	furniture_christmasWreath = "Karácsonyi Koszorú",
	furniture_christmasCandyBowl = "Cukros Tál",
	furniture_christmasCarnivorousPlant = "Húsevő Növény",
	-- items
	items = "Tárgyak:",
	item_cheese = "Sajt",
	item_coffee = "Kávé",
	--
	item_clock = "Óra",
	item_dynamite = "Dinamit",
	item_pickaxe = "Csákány",
	--
	item_salt = "Só",
	item_milk = "Tej",
	item_chocolate = "Csokoládé",
	item_cornFlakes = "Gabonapehely",
	item_sugar = "Cukor",
	item_bag = "Táska",
	--
	item_water = "Vizesvödör",
	item_fertilizer = "Trágya",
	item_superFertilizer = "Szupertrágya",
	item_wheatFlour = "Búzaliszt",
	--
	item_potato = "Krumpli",
	item_honey = "Méz",
	item_salad = "Saláta",
	item_egg = "Tojás",
	item_garlic = "Fokhagyma",
	--
	item_shrinkPotion = "Zsugorító bájital",
	item_growthPotion = "Növekedési bájital",
	--
	item_energyDrink_Ultra = "Coca-Cola",
	item_energyDrink_Mega = "Fanta",
	item_energyDrink_Basic = "Sprite",
	--
	item_crystal_yellow = "Citromsárga Kristály",
	item_crystal_blue = "Kék Kristály",
	item_crystal_purple = "Lila Kristály",
	item_crystal_green = "Zöld Kristály",
	item_crystal_red = "Piros Kristály",
	--
	item_milkShake = "Tejturmix",
	item_hotChocolate = "Forró csokoládé",
	item_waffles = "Gofri",
	item_chocolateCake = "Csokoládé Torta",
	item_sauce = "Szósz",
	item_bread = "Kenyér",
	item_lobsterBisque = "Homár Krémleves",
	item_frenchFries = "Sültkrumpli",
	item_frogSandwich = "Béka szendvics",
	item_hotsauce = "Csípős szósz",
	item_bruschetta = "Bruschetta",
	item_grilledLobster = "Grillezett Homár",
	item_lettuce = "Saláta",
	item_garlicBread = "Fokhagymás Kenyér",
	item_cookies = "Sütemény",
	item_pizza = "Pizza",
	item_lemonade = "Limonádé",
	item_pudding = "Puding",
	item_pierogies = "Pierogies",
	--
	item_goldNugget = "Aranyrög",
	item_dough = "Tészta",
	-- item descs
	itemDesc_dynamite = "Bumm!",
	itemDesc_pickaxe = "Törj sziklákat",
	itemDesc_seed = "Egy rejtélyes mag.",
	itemDesc_goldNugget = "Fényes és drága.",
	itemDesc_bag = "+%s kapacitás a táskában",
	itemDesc_minerpack = "%s csákányt tartalmaz.",
	itemDesc_water = "Ettől a magok gyorsabban nőnek!",
	itemDesc_clock = "Egyszerű óra, mely egyszer használható",
	itemDesc_fertilizer = "Felgyorsítja a növények növekedési idejét!",
	itemDesc_superFertilizer = "Ez 2x hatékonyabb, mint a rendes trágya.",
	itemInfo_Seed = "Növekedési idő: <vp>%s perc</vp>\nMagonkénti ár: <vp>$%s</vp>",
	itemInfo_miningPower = "Kő sebzés: %s",
	itemDesc_cheese = "Használd ezt a tárgyat, hogy sajtot kapj a Transformice boltban!",
	itemDesc_shrinkPotion = "Használd ezt a bájitalt, hogy összezsugorodj %s másodpercre!",
	itemDesc_growthPotion = "Használd ezt a bájitalt, hogy megnövekedj %s másodpercre!",
	-- houses and descriptions
	house = "Ház",
	houses = "Házak",
	House1 = "Klasszikus Ház",
	houseDescription_1 = "Egy kis ház.",
	House2 = "Családi Ház",
	houseDescription_2 = "Nagy ház, nagy családoknak, nagy problémákkal.",
	House3 = "Kísértetház",
	houseDescription_3 = "Csak a legbátrabbak élhetnek ebben a házban. Ooooo!",
	House4 = "Istálló",
	houseDescription_4 = "Unalmas a városban élni? Mi tudjuk, mire van szükséged.",
	House5 = "Kísértet Kastély",
	houseDescription_5 = "A szellemek valódi otthona. Légy óvatos!",
	House6 = "Karácsonyi Ház",
	houseDescription_6 = "Ez az otthonos ház még a hideg napokban is kényelmet nyújt számodra.",
	House7 = "Faház",
	houseDescription_7 = "Egy ház azoknak, akik szeretnek a természethez közelebb ébredni!",
	-- plants and seeds
	item_seed = "Mag",
	item_tomato = "Paradicsom",
	item_tomatoSeed = "Paradicsommag",
	item_oregano = "Oregánó",
	item_oreganoSeed = "Oregánó mag",
	item_wheat = "Búza",
	item_wheatSeed = "Búzamag",
	item_pepper = "Paprika",
	item_pepperSeed = "Paprika mag",
	item_lemon = "Citrom",
	item_lemonSeed = "Citrommag",
	item_pumpkin = "Tök",
	item_pumpkinSeed = "Tökmag",
	item_blueberries = "Áfonya",
	item_blueberriesSeed = "Áfonya mag",
	item_luckyFlower = "Szerencsevirág",
	item_luckyFlowerSeed = "Szerencsevirág mag",
	-- vehicles
	vehicles = "Járművek",
	boats = "Hajók",
	landVehicles = "Szárazföldi",
	vehicle_9 = "Szán",
	vehicle_12 = "Bugatti",
	waterVehicles = "Vízi",
	vehicle_5 = "Csónak",
	vehicle_6 = "Halászhajó",
	vehicle_8 = "Járőrhajó",
	vehicle_11 = "Jacht",
	-- settings
	settings = "Beállítások",
	houseSettings = "Házbeállítások",
	houseSettings_unlockHouse = "Ház kinyitása",
	houseSettings_placeFurniture = "Lehelyez",
	houseSettings_finish = "Befejez!",
	houseSettings_reset = "Visszaállít",
	houseSettings_permissions = "Jogosultságok",
	houseSettings_lockHouse = "Ház bezárása",
	houseSettings_buildMode = "Építési Mód",
	houseSettings_changeExpansion = "Bővítés Módosítása",
	houseSetting_storeFurnitures = "Az összes bútor áthelyezése a bútorraktárba",
	placedFurnitures = 'Lehelyezett bútorok: %s',
	sellFurnitureWarning = "Biztosan eladod ezt a bútort?\n<r>A művelet nem visszavonható!</r>",
	settings_help = "Segítség",
	settings_helpText = "Üdvözöl a <j>#Mycity</j>!\n Ha tudni akarod, hogyan kell játszani, akkor kattints az alábbi gombra:",
	settings_helpText2 = "Meglévő parancsok:",
	command_profile = "<g>!profile</g> <v>[játékosNév]</v>\n   Megmutatja <i>játékosNév</i> profilját.",
	settings_settings = "Beállítások",
	settings_config_mirror = "Tükrözött Szöveg",
	settings_config_lang = "Nyelv",
	settings_credits = "Kreditek",
	settings_creditsText = "A <j>#Mycity</j>-t <v>%s</v> készítette, a rajzokban <v>%s</v> segített, és ők fordították:",
	settings_creditsText2 = "Különleges köszönet <v>%s</v>-nek a modul fontos erőforrásainak segítéséért.",
	settings_donate = "Adományozás",
	settings_donateText = "<j>#Mycity</j> egy <b><cep>2014</cep></b>-ben indult projekt, de egy másik játékmenettel: <v>építs egy várost</v>! Azonban ez a projekt nem haladt előre, és hónapokkal később törölve lett.\n <b><cep>2017</cep></b>-ben úgy döntöttem, hogy helyrehozom egy új céllal: <v>élj egy városban</v>!\n\n A rendelkezésre álló funkciók nagy részét én készítettem <v>hosszú és fárasztó</v> időn keresztül.\n\n Ha képes vagy nekem segíteni, adományozz! Ez nagyban ösztönöz az új frissítések elkészítésében!",
	settings_donateText2 = 'Az adományozók exkluzív NPC-ket kapnak az adományozásért. Ne felejtsd el elküldeni a Transformice felhasználóneved, így fogom tudni megszerezni az aktuális kinézeted.',
	settings_gamePlaces = "Helyek",
	settings_gameHour = "Játékóra",
	settingsText_createdAt = "A szoba <vp>%s</vp> perccel ezelőtt lett létrehozva.",
	settingsText_currentRuntime = "Futási idő: <r>%s</r>/60ms",
	settingsText_placeWithMorePlayers = "Több játékossal való hely: <vp>%s</vp> <r>(%s)</r>",
	settingsText_availablePlaces = "Elérhető helyek: <vp>%s</vp>",
	settingsText_grounds = "Generált területek: %s/509",
	settingsText_hour = "Aktuális idő: <vp>%s</vp>",
	-- closed shops
	closed_buildshop = "Az Építészeti Bolt zárva van.\nGyere vissza 08:00-kor!",
	closed_police = "A Rendőrség zárva van.\nGyere vissza 08:00-kor!",
	closed_bank = "A Bank zárva van.\nGyere vissza 07:00-kor!",
	closed_market = "A Bolt zárva van.\nGyere vissza 08:00-kor!",
	closed_dealership = "Az Autókereskedés zárva van.\nGyere vissza 08:00-kor!",
	closed_furnitureStore = "A Bútorbolt zárva van.\nGyere vissza később!",
	closed_fishShop = "A Horgászbolt zárva van.\nGyere vissza később!",
	closed_potionShop = "A Bájitalbolt zárva van.\nGyere vissza később!",
	closed_seedStore = "A Magbolt zárva van.\nGyere vissza később.",
	-- errors
	error = "Hiba",
	timeOut = "Nem elérhető hely.",
	error_maxStorage = "Maximum mennyiség megvásárolva.",
	error_boatInIsland = "Nem használhatsz csónakot messze a tengertől.",
	error_houseUnderEdit = "%s szerkeszti a házat.",
	error_blockedFromHouse = "Ki vagy zárva %s házából.",
	error_houseClosed = "%s bezárta ezt a házat.",
	fishingError = "Most már nem horgászol.",
	moneyError = "Nincs elég pénzed.",
	bagError = "Nincs elég hely a táskádban!",
	passwordError = "Min. 1 karakter",
	pickaxeError = "Csákányra lesz szükséged!",
	vehicleError = "Ezen a helyen nem használhatod ezt a járművet.",
	codeLevelError = "Ha kód használatához el kell érned a(z) %s szintet.",
	copError = "10 másodpercet várnod kell, hogy újra elkaphass valakit.",
	mouseSizeError = "Túl kicsi vagy ahhoz, hogy ezt tedd.",
	mine5error = "A Bánya beomlott.",
	rewardNotFound = "A jutalom nem található.",
	noMissions = "Nincsenek elérhető küldetések.",
	fishWarning = "Itt nem tudsz horgászni.",
	codeNotAvailable = "A kód nem érhető el.",
	codeAlreadyReceived = "Használt kód.",
	incorrect = "Helytelen",
	noEnergy = "Több energiára lesz szükséged, hogy újra munkába állj.",
	chestIsFull = "A láda megtelt.",
	alreadyLand = "Valaki már megszerezte ezt a területet.",
	limitedItemBlock = "Várnod kell %s másodpercet, hogy használhasd ezt a tárgyat.",
	maxFurnitureStorage = "Csak %s bútor lehet a házadban.",
	frozenLake = "A tó befagyott. Várnod kell tél végéig, hogy újra használhass hajót.",
	enterQuestPlace = "Ez a hely a <vp>%s</vp> teljesítése után lesz elérhető.",
	maxFurnitureDepot = "A bútorraktár megtelt.",
	-- NPC dialogs
	npcDialog_Paulo = "Ez a doboz igazán nehéz...\nJó lenne, ha itt volna egy targonca.",
	npcDialog_Natasha = "Szia!",
	npcDialog_Billy = "Alig várom, hogy ma este kiraboljam a bankot!",
	npcDialog_Pablo = "Szóval, rabló akarsz lenni? Úgy érzem, titkos zsaru vagy...\nOh, nem vagy? Rendben, akkor hiszek neked.\nMost már rabló vagy. Rabolj a rózsaszín névvel ellátott karakterektől a SPACE gombot lenyomva. Ne felejts el távol maradni a zsaruktól!",
	npcDialog_Weth = "Puding *-*",
	npcDialog_Julie = "Légy óvatos. Ez a szupermarket nagyon veszélyes.",
	npcDialog_Goldie = "Akarsz eladni egy kristályt? Dobd le mellém, hogy megbecsülhessem az árát.",
	npcDialog_Davi = "Sajnálom, de nem engedhetem, hogy itt tovább menj.",
	npcDialog_Marie = "Imáááááááádom a sajtot *-*",
	npcDialog_Rupe = "Egyértelmű, hogy a kőből készült csákány nem jó választás a kövek törésére.",
	npcDialog_Jason = "Hé... Az üzletemben még nincsenek eladó dolgok.\nKérlek, gyere vissza később!",
	npcDialog_Kapo = "Mindig idejövök, hogy ellenőrizzem Dave napi ajánlatát.\nNéha olyan tárgyakat kapok, amik csak az ő tulajdonában vannak!",
	npcDialog_Cassy = "Szép napot!",
	npcDialog_Lauren = "Imádja a sajtot.",
	npcDialog_Louis = "Mondtam neki, hogy ne rakjon olajbogyót...",
	npcDialog_Blank = "Szükséged van valamire?",
	npcDialog_Sebastian = "Hé haver.\n...\nNem Colt vagyok.",
	npcDialog_Heinrich = "Huh... Szóval Bányász akarsz lenni? Ha igen, akkor légy óvatos. Amikor kisegér voltam, eltévedtem ebben a labirintusban.",
	npcDialog_Derek = "Psszt.. Ma este valami nagy eredményt szerzünk: kiraboljuk a Bankot.\nHa csatlakozni akarsz hozzánk, jobb, ha beszélsz a főnökünkkel, Pablo-val.",
	npcDialog_Bill = 'Heyyo! Szeretnéd ellenőrizni az aktuális horgászszerencséd?\nHmmm... Lássuk csak..\n%s esélyed van egy közönséges hal megszerzésére, %s esélyed egy ritka hal megszerzésére és %s esélyed egy mitikus hal megszerzésére.\n... És %s esélyed van egy legendás hal megszerzésére!',
	npcDialog_Alexa = "Helló. Mi újság?",
	npcDialog_Santih = "Sok ember még mindig mer horgászni ebben a tóban.",
	npc_mine6msg = "Ez bármikor beomolhat, de senki sem hallgat rám.",
	-- chat messages
	playerBannedFromRoom = "%s ki lett tiltva ebből a szobából.",
	playerUnbannedFromRoom = "El lett távolítva %s kitiltása, így újra játszhat.",
	arrestedPlayer = "Letartóztattad <v>%s</v> -t!",
	captured = "<g>A rabló (<v>%s</v>) le lett tartóztatva!",
	copAlerted = "A zsaruk riasztva lettek.",
	levelUp = "%s elérte a(z) %s. szintet!",
	seedSold = "%s eladva ennyiért: %s.",
	orderCompleted = "Kiszállítottad %s rendelését és %s-t kaptál!",
	transferedItem = "A(z) %s áthelyezve a táskádba.",
	bankRobAlert = "A Bankot kirabolták. Védd meg!",
	itemAddedToChest = "%s hozzáadva a ládához.",
	furnitureRewarded = "Feloldott bútor: %s",
	goldAdded = "A bányászott aranyrög hozzáadva a táskádhoz.",
	caught_goldenmare = "<v>%s</v> <j>kifogott egy Aranyhalat!</j>",
	alert = "RIADÓ!",
	-- UI messages
	reward = "Jutalom",
	newUpdate = "Új frissítés!",
	robberyInProgress = "Rablás folyamatban",
	chooseExpansion = "Válassz ki egy bővítést",
	chooseOption = "Válassz egy lehetőséget",
	daveOffers = 'Mai ajánlatok',
	completedQuest = "Küldetés befejezve",
	newLevel = "Új szint!",
	ranking_Season = "Évad %s",
	password = "A Bank kódja",
	using = "Használatban",
	daysLeft = "Még %s napig",
	level = "Szint %s",
	code = "írd be a kódot",
	owned = "Birtokolva",
	codeReceived = "A jutalmad: %s.",
	waitingForPlayers = "Várakozás játékosokra...",
	newBadge = "Új kitűző",
	createdBy = "Készítette %s",
	unlockedBadge = "Egy új Kitűzőt szereztél!",
	newLevelMessage = "Gratulálunk!\nSzintet léptél!",
	runAway = "Menekülj %s másodpercig.",
	runAwayCoinInfo = "A rablás befejezése után %s-t kapsz.",
	looseMgs = "Megmenekülsz %s másodpercen belül.",
	healing = "Az életszinted %s másodpercen belül feltöltődik.",
	newQuestSoon = "A Küldetés %s még nem érhető el:/\n<font size=\"11\">Fejlesztési stádium: %s%%",
	sidequestCompleted = "Teljesítetted a Mellékküldetést!\nA jutalmad:",
	questCompleted = "Teljesítetted a következő küldetést:\n%s!\nA jutalmad:",
	rewardText = "Hihetetlen jutalmakat kaptál!",
	updateWarning = "<font size=\"10\"><rose><p align=\"center\">Figyelem!</p></rose>\nÚj frissítés:\n%s:%s perc múlva",
	tip_vehicle = "Kattints a jármű melletti csillag ikonra, hogy a kedvenceid közé tedd! A kedvenc jármű meghívásához nyomd meg az F(szárazföldi) vagy G(vízi) gombot.",
	codeInfo = "Írj be egy érvényes kódot, majd kattints az Elfogadra, hogy megkapd a jutalmad.\nÚj kódokat kaphatsz, ha csatlakozol a Discord szerverünkhöz!\n<a href=\"event:getDiscordLink\"><v>(Kattints ide a meghívó linkért)</v></a>",
	-- emergency messages
	emergencyMode_able = "<r>Vészleállás kezdeményezése, új játékosok nem engedélyezettek. Kérjük, menj egy másik #mycity szobába.",
	syncingGame = "<r>A játék adatainak szinkronizálása. A játék néhány másodpercre leáll.",
	emergencyMode_pause = "<cep><b>[Figyelem!]</b> <r>A modul elérte a kritikus határát, így szüneteltetés alatt áll.",
	emergencyMode_resume = "<r>A modul folytatódik.",
	-- buttons
	goTo = "Belépés",
	sell = "Eladás",
	remove = "Eltávolítás",
	cook = "Főzés",
	seeItems = "Tárgyak mutatása",
	yes = "Igen",
	no = "Nem",
	expansion_pool = "Medence",
	receiveQuestReward = "Jutalom begyűjtése",
	buy = "Vásárlás",
	confirmButton_Buy = "Vásárlás %s",
	confirmButton_Sell = "Eladás %s -ért",
	sellGold = "%s aranyrög eladása <vp>%s</vp>-ért",
	use = "Használ",
	saveChanges = "Változtatások Mentése",
	confirmButton_Work = "Munkára fel!",
	eatItem = "Elfogyaszt",
	recipes = "Receptek",
	confirmButton_Great = "Nagyszerű!",
	open = "Nyit",
	cancel = "Mégse",
	close = "Bezárás",
	confirmButton_tip = "Tipp",
	passToBag = "Táskába helyezés",
	submit = "Elfogad",
	sellFurniture = "Bútor eladása",
	sale = "Eladó",
	drop = "Kidobás",
	harvest = "Betakarítás",
	permissions_guest = "Vendég",
	permissions_roommate = "Szobatárs",
	permissions_blocked = "Zárolt",
	permissions_owner = "Tulajdonos",
	permissions_coowner = "Társtulajdonos",
	setPermission = "Jog: %s",
	-- other
	hospital = "Kórház",
	elevator = "Lift",
	hungerInfo = "<v>%s</v> étel",
	hunger = "Éhség",
	pizzaMaker = "Pizzakészítő",
	price = "Ár: %s",
	speed = "Sebesség: %s",
	sleep = "Alvás",
	ranking_spentCoins = "Elköltött érme",
	placeDynamite = "Dinamit elhelyezése",
	quest = "Küldetés",
	experiencePoints = "Tapasztalati pont",
	confirmButton_Select = "Kiválaszt",
   	expansion_garden = "Kert",
	bag = "Táska",
	minerpack = "Bányászcsomag %s",
	percentageFormat = "%s%%",
	soon = "Hamarosan!",
	expansion_grass = "Fű",
	waitUntilUpdate = "<rose>Kérlek várj.</rose>",
	collectorItem = "Gyűjtő tárgy",
	daysLeft2 = "%s nap",
	pickaxes = "Csákányok",
	multiTextFormating = "{0}: {1}",
	energyInfo = "<v>%s</v> energia",
	itemAmount = "Tárgyak: %s",
	wordSeparator = " és ",
	speed_knots = "nmi",
	ranking_coins = "Összegyűjtött érme",
	energy = "Energia",
	locked_quest = "Küldetés %s",
	expansion = "Bővítések",
	event_halloween2019 = "Halloween 2019",
	shop = "Bolt",
	atmMachine = "ATM",
	hey = "Hé! Állj!",
	speed_km = "Km/h",
	leisure = "Szórakozás",
	--- V3.0.4
	badgeDesc_11 = 'Top10-ben voltál az Évad 01-ben',
	caught_goldenmare = '<v>%s</v> <j>kifogott egy Aranyhalat!</j>',
	newCar = 'Új autó',
	unlockedCar = 'Gratulálunk! Feloldottál egy új autót!',
	seasonReward = 'Évad Jutalom',
	furniture_inflatableDuck = 'Felfújható Kacsa',
	furniture_lifesaverChair = 'Életmentő Szék',
	furniture_coolBox = 'Hűtőláda',
	furniture_bbqGrill = 'Kerti Sütögető',
	furniture_shower = 'Zuhanyzó',
	furniture_flamingo = 'Flamingó',
	item_bananaSeed = 'Banán Palánta',
	item_banana = 'Banán',
	item_moqueca = 'Halpaprikás',
	--- V3.0.5
	item_grilledCheese = 'Grillezett Sajt',
	item_fishBurger = 'Hal Burger',
	item_sushi = 'Sushi',
}
