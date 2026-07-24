# 七十二候 — the seventy-two microseasons.
#
# The Japanese traditional calendar splits the year into 24 節気 (sekki, solar
# terms) and each of those into three 候 (kō) of roughly five days. Every kō has
# a name that describes what the world is doing right now: "east wind melts the
# ice", "rotten grass becomes fireflies", "hens start laying eggs".
#
# This is the Ink & Wave system's living clock. `modules/home-manager/tools/
# sekki.nix` compiles this table into a `sekki` CLI; waybar, neovim, fastfetch
# and hyprlock all read it, so the whole machine quietly changes its mind about
# what season it is every five days.
#
# Pure data on purpose — same contract as lib/palette.nix. Dates are the fixed
# Gregorian approximations used by the modern Japanese almanac (the true kō
# boundaries drift ±1 day with the solar longitude; nobody's compiler cares).
#
# Rows MUST stay sorted by `start` — the CLI picks the last row whose start is
# <= today, and wraps to the final row for early January.
#
# Fields:
#   start        "MMDD" — first day of the kō
#   ko           kanji name of the microseason
#   romaji       how it is read
#   en           what it means
#   sekki        parent solar term (kanji)
#   sekkiRomaji  parent solar term (reading)
#   sekkiEn      parent solar term (meaning)
#   season       spring | summer | autumn | winter  (drives the accent colour)
[
  # ── 小寒 shōkan · lesser cold ───────────────────────────────────────────
  { start = "0105"; ko = "芹乃栄";     romaji = "seri sunawachi sakau";        en = "parsley flourishes";                     sekki = "小寒"; sekkiRomaji = "shōkan";    sekkiEn = "lesser cold";        season = "winter"; }
  { start = "0110"; ko = "水泉動";     romaji = "shimizu atataka o fukumu";    en = "springs thaw underground";               sekki = "小寒"; sekkiRomaji = "shōkan";    sekkiEn = "lesser cold";        season = "winter"; }
  { start = "0115"; ko = "雉始雊";     romaji = "kiji hajimete naku";          en = "pheasants start to call";                sekki = "小寒"; sekkiRomaji = "shōkan";    sekkiEn = "lesser cold";        season = "winter"; }

  # ── 大寒 daikan · greater cold ──────────────────────────────────────────
  { start = "0120"; ko = "款冬華";     romaji = "fuki no hana saku";           en = "butterburs bud";                         sekki = "大寒"; sekkiRomaji = "daikan";    sekkiEn = "greater cold";       season = "winter"; }
  { start = "0125"; ko = "水沢腹堅";   romaji = "sawamizu kōri tsumeru";       en = "ice thickens on the streams";            sekki = "大寒"; sekkiRomaji = "daikan";    sekkiEn = "greater cold";       season = "winter"; }
  { start = "0130"; ko = "鶏始乳";     romaji = "niwatori hajimete toya ni tsuku"; en = "hens start laying eggs";             sekki = "大寒"; sekkiRomaji = "daikan";    sekkiEn = "greater cold";       season = "winter"; }

  # ── 立春 risshun · beginning of spring ──────────────────────────────────
  { start = "0204"; ko = "東風解凍";   romaji = "harukaze kōri o toku";        en = "east wind melts the ice";                sekki = "立春"; sekkiRomaji = "risshun";   sekkiEn = "beginning of spring"; season = "spring"; }
  { start = "0209"; ko = "黄鶯睍睆";   romaji = "kōō kenkan su";               en = "bush warblers sing in the mountains";    sekki = "立春"; sekkiRomaji = "risshun";   sekkiEn = "beginning of spring"; season = "spring"; }
  { start = "0214"; ko = "魚上氷";     romaji = "uo kōri o izuru";             en = "fish rise through the cracking ice";     sekki = "立春"; sekkiRomaji = "risshun";   sekkiEn = "beginning of spring"; season = "spring"; }

  # ── 雨水 usui · rainwater ───────────────────────────────────────────────
  { start = "0219"; ko = "土脉潤起";   romaji = "tsuchi no shō uruoi okoru";   en = "rain moistens the soil";                 sekki = "雨水"; sekkiRomaji = "usui";      sekkiEn = "rainwater";          season = "spring"; }
  { start = "0224"; ko = "霞始靆";     romaji = "kasumi hajimete tanabiku";    en = "mist begins to linger";                  sekki = "雨水"; sekkiRomaji = "usui";      sekkiEn = "rainwater";          season = "spring"; }
  { start = "0301"; ko = "草木萌動";   romaji = "sōmoku mebae izuru";          en = "grass sprouts, trees bud";               sekki = "雨水"; sekkiRomaji = "usui";      sekkiEn = "rainwater";          season = "spring"; }

  # ── 啓蟄 keichitsu · insects awaken ─────────────────────────────────────
  { start = "0306"; ko = "蟄虫啓戸";   romaji = "sugomori mushito o hiraku";   en = "hibernating insects open their doors";   sekki = "啓蟄"; sekkiRomaji = "keichitsu"; sekkiEn = "insects awaken";     season = "spring"; }
  { start = "0311"; ko = "桃始笑";     romaji = "momo hajimete saku";          en = "first peach blossoms";                   sekki = "啓蟄"; sekkiRomaji = "keichitsu"; sekkiEn = "insects awaken";     season = "spring"; }
  { start = "0316"; ko = "菜虫化蝶";   romaji = "namushi chō to naru";         en = "caterpillars become butterflies";        sekki = "啓蟄"; sekkiRomaji = "keichitsu"; sekkiEn = "insects awaken";     season = "spring"; }

  # ── 春分 shunbun · spring equinox ───────────────────────────────────────
  { start = "0321"; ko = "雀始巣";     romaji = "suzume hajimete sukū";        en = "sparrows start to nest";                 sekki = "春分"; sekkiRomaji = "shunbun";   sekkiEn = "spring equinox";     season = "spring"; }
  { start = "0326"; ko = "桜始開";     romaji = "sakura hajimete saku";        en = "first cherry blossoms";                  sekki = "春分"; sekkiRomaji = "shunbun";   sekkiEn = "spring equinox";     season = "spring"; }
  { start = "0331"; ko = "雷乃発声";   romaji = "kaminari sunawachi koe o hassu"; en = "distant thunder";                     sekki = "春分"; sekkiRomaji = "shunbun";   sekkiEn = "spring equinox";     season = "spring"; }

  # ── 清明 seimei · pure and clear ────────────────────────────────────────
  { start = "0405"; ko = "玄鳥至";     romaji = "tsubame kitaru";              en = "swallows return";                        sekki = "清明"; sekkiRomaji = "seimei";    sekkiEn = "pure and clear";     season = "spring"; }
  { start = "0410"; ko = "鴻雁北";     romaji = "kōgan kaeru";                 en = "wild geese fly north";                   sekki = "清明"; sekkiRomaji = "seimei";    sekkiEn = "pure and clear";     season = "spring"; }
  { start = "0415"; ko = "虹始見";     romaji = "niji hajimete arawaru";       en = "first rainbows";                         sekki = "清明"; sekkiRomaji = "seimei";    sekkiEn = "pure and clear";     season = "spring"; }

  # ── 穀雨 kokuu · grain rain ─────────────────────────────────────────────
  { start = "0420"; ko = "葭始生";     romaji = "ashi hajimete shōzu";         en = "reeds begin to sprout";                  sekki = "穀雨"; sekkiRomaji = "kokuu";     sekkiEn = "grain rain";         season = "spring"; }
  { start = "0425"; ko = "霜止出苗";   romaji = "shimo yamite nae izuru";      en = "last frost, rice seedlings grow";        sekki = "穀雨"; sekkiRomaji = "kokuu";     sekkiEn = "grain rain";         season = "spring"; }
  { start = "0430"; ko = "牡丹華";     romaji = "botan hana saku";             en = "peonies bloom";                          sekki = "穀雨"; sekkiRomaji = "kokuu";     sekkiEn = "grain rain";         season = "spring"; }

  # ── 立夏 rikka · beginning of summer ────────────────────────────────────
  { start = "0505"; ko = "蛙始鳴";     romaji = "kawazu hajimete naku";        en = "frogs start singing";                    sekki = "立夏"; sekkiRomaji = "rikka";     sekkiEn = "beginning of summer"; season = "summer"; }
  { start = "0510"; ko = "蚯蚓出";     romaji = "mimizu izuru";                en = "worms surface";                          sekki = "立夏"; sekkiRomaji = "rikka";     sekkiEn = "beginning of summer"; season = "summer"; }
  { start = "0515"; ko = "竹笋生";     romaji = "takenoko shōzu";              en = "bamboo shoots sprout";                   sekki = "立夏"; sekkiRomaji = "rikka";     sekkiEn = "beginning of summer"; season = "summer"; }

  # ── 小満 shōman · lesser ripening ───────────────────────────────────────
  { start = "0521"; ko = "蚕起食桑";   romaji = "kaiko okite kuwa o hamu";     en = "silkworms wake and eat mulberry";        sekki = "小満"; sekkiRomaji = "shōman";    sekkiEn = "lesser ripening";    season = "summer"; }
  { start = "0526"; ko = "紅花栄";     romaji = "benibana sakau";              en = "safflowers bloom in abundance";          sekki = "小満"; sekkiRomaji = "shōman";    sekkiEn = "lesser ripening";    season = "summer"; }
  { start = "0531"; ko = "麦秋至";     romaji = "mugi no toki itaru";          en = "wheat ripens and is harvested";          sekki = "小満"; sekkiRomaji = "shōman";    sekkiEn = "lesser ripening";    season = "summer"; }

  # ── 芒種 bōshu · grain beards and seeds ─────────────────────────────────
  { start = "0606"; ko = "螳螂生";     romaji = "kamakiri shōzu";              en = "praying mantises hatch";                 sekki = "芒種"; sekkiRomaji = "bōshu";     sekkiEn = "grain beards and seeds"; season = "summer"; }
  { start = "0611"; ko = "腐草為蛍";   romaji = "kusaretaru kusa hotaru to naru"; en = "rotten grass becomes fireflies";      sekki = "芒種"; sekkiRomaji = "bōshu";     sekkiEn = "grain beards and seeds"; season = "summer"; }
  { start = "0616"; ko = "梅子黄";     romaji = "ume no mi kibamu";            en = "plums turn yellow";                      sekki = "芒種"; sekkiRomaji = "bōshu";     sekkiEn = "grain beards and seeds"; season = "summer"; }

  # ── 夏至 geshi · summer solstice ────────────────────────────────────────
  { start = "0621"; ko = "乃東枯";     romaji = "natsukarekusa karuru";        en = "self-heal withers";                      sekki = "夏至"; sekkiRomaji = "geshi";     sekkiEn = "summer solstice";    season = "summer"; }
  { start = "0626"; ko = "菖蒲華";     romaji = "ayame hana saku";             en = "irises bloom";                           sekki = "夏至"; sekkiRomaji = "geshi";     sekkiEn = "summer solstice";    season = "summer"; }
  { start = "0701"; ko = "半夏生";     romaji = "hange shōzu";                 en = "crow-dipper sprouts";                    sekki = "夏至"; sekkiRomaji = "geshi";     sekkiEn = "summer solstice";    season = "summer"; }

  # ── 小暑 shōsho · lesser heat ───────────────────────────────────────────
  { start = "0707"; ko = "温風至";     romaji = "atsukaze itaru";              en = "warm winds blow";                        sekki = "小暑"; sekkiRomaji = "shōsho";    sekkiEn = "lesser heat";        season = "summer"; }
  { start = "0712"; ko = "蓮始開";     romaji = "hasu hajimete hiraku";        en = "first lotus blossoms";                   sekki = "小暑"; sekkiRomaji = "shōsho";    sekkiEn = "lesser heat";        season = "summer"; }
  { start = "0717"; ko = "鷹乃学習";   romaji = "taka sunawachi waza o narau"; en = "hawks learn to fly";                     sekki = "小暑"; sekkiRomaji = "shōsho";    sekkiEn = "lesser heat";        season = "summer"; }

  # ── 大暑 taisho · greater heat ──────────────────────────────────────────
  { start = "0723"; ko = "桐始結花";   romaji = "kiri hajimete hana o musubu"; en = "paulownia trees produce seeds";          sekki = "大暑"; sekkiRomaji = "taisho";    sekkiEn = "greater heat";       season = "summer"; }
  { start = "0728"; ko = "土潤溽暑";   romaji = "tsuchi uruōte mushi atsushi"; en = "earth is damp, air is humid";            sekki = "大暑"; sekkiRomaji = "taisho";    sekkiEn = "greater heat";       season = "summer"; }
  { start = "0802"; ko = "大雨時行";   romaji = "taiu tokidoki furu";          en = "great rains sometimes fall";             sekki = "大暑"; sekkiRomaji = "taisho";    sekkiEn = "greater heat";       season = "summer"; }

  # ── 立秋 risshū · beginning of autumn ───────────────────────────────────
  { start = "0807"; ko = "涼風至";     romaji = "suzukaze itaru";              en = "cool winds blow";                        sekki = "立秋"; sekkiRomaji = "risshū";    sekkiEn = "beginning of autumn"; season = "autumn"; }
  { start = "0812"; ko = "寒蝉鳴";     romaji = "higurashi naku";              en = "evening cicadas sing";                   sekki = "立秋"; sekkiRomaji = "risshū";    sekkiEn = "beginning of autumn"; season = "autumn"; }
  { start = "0817"; ko = "蒙霧升降";   romaji = "fukaki kiri matō";            en = "thick fog descends";                     sekki = "立秋"; sekkiRomaji = "risshū";    sekkiEn = "beginning of autumn"; season = "autumn"; }

  # ── 処暑 shosho · manageable heat ───────────────────────────────────────
  { start = "0823"; ko = "綿柎開";     romaji = "wata no hana shibe hiraku";   en = "cotton flowers bloom";                   sekki = "処暑"; sekkiRomaji = "shosho";    sekkiEn = "manageable heat";    season = "autumn"; }
  { start = "0828"; ko = "天地始粛";   romaji = "tenchi hajimete samushi";     en = "heat starts to die down";                sekki = "処暑"; sekkiRomaji = "shosho";    sekkiEn = "manageable heat";    season = "autumn"; }
  { start = "0902"; ko = "禾乃登";     romaji = "kokumono sunawachi minoru";   en = "rice ripens";                            sekki = "処暑"; sekkiRomaji = "shosho";    sekkiEn = "manageable heat";    season = "autumn"; }

  # ── 白露 hakuro · white dew ─────────────────────────────────────────────
  { start = "0907"; ko = "草露白";     romaji = "kusa no tsuyu shiroshi";      en = "dew glistens white on grass";            sekki = "白露"; sekkiRomaji = "hakuro";    sekkiEn = "white dew";          season = "autumn"; }
  { start = "0912"; ko = "鶺鴒鳴";     romaji = "sekirei naku";                en = "wagtails sing";                          sekki = "白露"; sekkiRomaji = "hakuro";    sekkiEn = "white dew";          season = "autumn"; }
  { start = "0917"; ko = "玄鳥去";     romaji = "tsubame saru";                en = "swallows leave";                         sekki = "白露"; sekkiRomaji = "hakuro";    sekkiEn = "white dew";          season = "autumn"; }

  # ── 秋分 shūbun · autumn equinox ────────────────────────────────────────
  { start = "0923"; ko = "雷乃収声";   romaji = "kaminari sunawachi koe o osamu"; en = "thunder ceases";                      sekki = "秋分"; sekkiRomaji = "shūbun";    sekkiEn = "autumn equinox";     season = "autumn"; }
  { start = "0928"; ko = "蟄虫坏戸";   romaji = "mushi kakurete to o fusagu";  en = "insects hole up underground";            sekki = "秋分"; sekkiRomaji = "shūbun";    sekkiEn = "autumn equinox";     season = "autumn"; }
  { start = "1003"; ko = "水始涸";     romaji = "mizu hajimete karuru";        en = "farmers drain the fields";               sekki = "秋分"; sekkiRomaji = "shūbun";    sekkiEn = "autumn equinox";     season = "autumn"; }

  # ── 寒露 kanro · cold dew ───────────────────────────────────────────────
  { start = "1008"; ko = "鴻雁来";     romaji = "kōgan kitaru";                en = "wild geese return";                      sekki = "寒露"; sekkiRomaji = "kanro";     sekkiEn = "cold dew";           season = "autumn"; }
  { start = "1013"; ko = "菊花開";     romaji = "kiku no hana hiraku";         en = "chrysanthemums bloom";                   sekki = "寒露"; sekkiRomaji = "kanro";     sekkiEn = "cold dew";           season = "autumn"; }
  { start = "1018"; ko = "蟋蟀在戸";   romaji = "kirigirisu to ni ari";        en = "crickets chirp around the door";         sekki = "寒露"; sekkiRomaji = "kanro";     sekkiEn = "cold dew";           season = "autumn"; }

  # ── 霜降 sōkō · frost falls ─────────────────────────────────────────────
  { start = "1023"; ko = "霜始降";     romaji = "shimo hajimete furu";         en = "first frost";                            sekki = "霜降"; sekkiRomaji = "sōkō";      sekkiEn = "frost falls";        season = "autumn"; }
  { start = "1028"; ko = "霎時施";     romaji = "kosame tokidoki furu";        en = "light rains sometimes fall";             sekki = "霜降"; sekkiRomaji = "sōkō";      sekkiEn = "frost falls";        season = "autumn"; }
  { start = "1102"; ko = "楓蔦黄";     romaji = "momiji tsuta kibamu";         en = "maple leaves and ivy turn yellow";       sekki = "霜降"; sekkiRomaji = "sōkō";      sekkiEn = "frost falls";        season = "autumn"; }

  # ── 立冬 rittō · beginning of winter ────────────────────────────────────
  { start = "1107"; ko = "山茶始開";   romaji = "tsubaki hajimete hiraku";     en = "camellias bloom";                        sekki = "立冬"; sekkiRomaji = "rittō";     sekkiEn = "beginning of winter"; season = "winter"; }
  { start = "1112"; ko = "地始凍";     romaji = "chi hajimete kōru";           en = "the land starts to freeze";              sekki = "立冬"; sekkiRomaji = "rittō";     sekkiEn = "beginning of winter"; season = "winter"; }
  { start = "1117"; ko = "金盞香";     romaji = "kinsenka saku";               en = "daffodils bloom";                        sekki = "立冬"; sekkiRomaji = "rittō";     sekkiEn = "beginning of winter"; season = "winter"; }

  # ── 小雪 shōsetsu · lesser snow ─────────────────────────────────────────
  { start = "1122"; ko = "虹蔵不見";   romaji = "niji kakurete miezu";         en = "rainbows hide";                          sekki = "小雪"; sekkiRomaji = "shōsetsu";  sekkiEn = "lesser snow";        season = "winter"; }
  { start = "1127"; ko = "朔風払葉";   romaji = "kitakaze konoha o harau";     en = "north wind strips the leaves";           sekki = "小雪"; sekkiRomaji = "shōsetsu";  sekkiEn = "lesser snow";        season = "winter"; }
  { start = "1202"; ko = "橘始黄";     romaji = "tachibana hajimete kibamu";   en = "citrus leaves start to yellow";          sekki = "小雪"; sekkiRomaji = "shōsetsu";  sekkiEn = "lesser snow";        season = "winter"; }

  # ── 大雪 taisetsu · greater snow ────────────────────────────────────────
  { start = "1207"; ko = "閉塞成冬";   romaji = "sora samuku fuyu to naru";    en = "cold sets in, winter begins";            sekki = "大雪"; sekkiRomaji = "taisetsu";  sekkiEn = "greater snow";       season = "winter"; }
  { start = "1212"; ko = "熊蟄穴";     romaji = "kuma ana ni komoru";          en = "bears retreat to their dens";            sekki = "大雪"; sekkiRomaji = "taisetsu";  sekkiEn = "greater snow";       season = "winter"; }
  { start = "1216"; ko = "鱖魚群";     romaji = "sake no uo muragaru";         en = "salmon gather and swim upstream";        sekki = "大雪"; sekkiRomaji = "taisetsu";  sekkiEn = "greater snow";       season = "winter"; }

  # ── 冬至 tōji · winter solstice ─────────────────────────────────────────
  { start = "1222"; ko = "乃東生";     romaji = "natsukarekusa shōzu";         en = "self-heal sprouts";                      sekki = "冬至"; sekkiRomaji = "tōji";      sekkiEn = "winter solstice";    season = "winter"; }
  { start = "1226"; ko = "麋角解";     romaji = "sawashika no tsuno otsuru";   en = "deer shed their antlers";                sekki = "冬至"; sekkiRomaji = "tōji";      sekkiEn = "winter solstice";    season = "winter"; }
  { start = "1231"; ko = "雪下出麦";   romaji = "yuki watarite mugi nobiru";   en = "wheat sprouts under the snow";           sekki = "冬至"; sekkiRomaji = "tōji";      sekkiEn = "winter solstice";    season = "winter"; }
]
