if (GetLocale() == "ruRU") then 

PowaAuras.Anim[0] = "[Cкрытый]";
PowaAuras.Anim[1] = "Статический";
PowaAuras.Anim[2] = "Мигание";
PowaAuras.Anim[3] = "Увеличение";
PowaAuras.Anim[4] = "Пульсация";
PowaAuras.Anim[5] = "Пузыриться";
PowaAuras.Anim[6] = "Капанье воды";
PowaAuras.Anim[7] = "Электрический";
PowaAuras.Anim[8] = "Стягивание";
PowaAuras.Anim[9] = "Огонь";
PowaAuras.Anim[10] = "Вращаться";

PowaAuras.BeginAnimDisplay[0] = "[Нету]";
PowaAuras.BeginAnimDisplay[1] = "Увеличить масштаб";
PowaAuras.BeginAnimDisplay[2] = "Уменьшить масштаб";
PowaAuras.BeginAnimDisplay[3] = "Только матовость";
PowaAuras.BeginAnimDisplay[4] = "Слева";
PowaAuras.BeginAnimDisplay[5] = "Вверху-слева";
PowaAuras.BeginAnimDisplay[6] = "Вверху";
PowaAuras.BeginAnimDisplay[7] = "Вверху-справа";
PowaAuras.BeginAnimDisplay[8] = "Справа";
PowaAuras.BeginAnimDisplay[9] = "Внизу-справа";
PowaAuras.BeginAnimDisplay[10] = "Внизу";
PowaAuras.BeginAnimDisplay[11] = "Внизу-слева";
PowaAuras.BeginAnimDisplay[12] = "Bounce";

PowaAuras.EndAnimDisplay[0] = "[Нету]";
PowaAuras.EndAnimDisplay[1] = "Увеличить масштаб";
PowaAuras.EndAnimDisplay[2] = "Уменьшить масштаб";
PowaAuras.EndAnimDisplay[3] = "Только матовость";
PowaAuras.EndAnimDisplay[4] = "Spin"; --- untranslated
PowaAuras.EndAnimDisplay[5] = "Spin In"; --- untranslated

PowaAuras.Sound[0] = "Нету";

PowaAuras:MergeTables(PowaAuras.Text, 
{
	welcome = "Для просмотра настроек введите /powa.",

	aucune = "Нету",
	aucun = "Нету",
	largeur = "Ширина",
	hauteur = "Высота",
	mainHand = "правая",
	offHand = "левая",
	bothHands = "Обе",

	DebuffType =
	{
		Magic = "Магия",
		Disease = "Болезнь",
		Curse = "Проклятие",
		Poison = "Яд",
	},
	
	DebuffCatType =
	{
		[PowaAuras.DebuffCatType.CC] = "Контроль",
		[PowaAuras.DebuffCatType.Silence] = "Молчание",
		[PowaAuras.DebuffCatType.Snare] = "Ловушка",
		[PowaAuras.DebuffCatType.Stun] = "Оглушение",
		[PowaAuras.DebuffCatType.Root] = "Корни",
		[PowaAuras.DebuffCatType.Disarm] = "Разоружение",
		[PowaAuras.DebuffCatType.PvE] = "PvE",
	},
	
	AuraType =
	{
		[PowaAuras.BuffTypes.Buff] = "Бафф",
		[PowaAuras.BuffTypes.Debuff] = "Дебафф",
		[PowaAuras.BuffTypes.AoE] = "Масс дебафф",
		[PowaAuras.BuffTypes.TypeDebuff] = "Тип дебаффов",
		[PowaAuras.BuffTypes.Enchant] = "Усиление оружия",
		[PowaAuras.BuffTypes.Combo] = "Приёмы в серии",
		[PowaAuras.BuffTypes.ActionReady] = "Применимое действие",
		[PowaAuras.BuffTypes.Health] = "Здоровье",
		[PowaAuras.BuffTypes.Mana] = "Мана",
		[PowaAuras.BuffTypes.EnergyRagePower] = "Ярость/Энергия/Руны",
		[PowaAuras.BuffTypes.Aggro] = "Угроза",
		[PowaAuras.BuffTypes.PvP] = "PvP",
		[PowaAuras.BuffTypes.Stance] = "Стойка",
		[PowaAuras.BuffTypes.SpellAlert] = "Оповещение о заклинаниях", 
		[PowaAuras.BuffTypes.OwnSpell] = "Моё заклинание",
		[PowaAuras.BuffTypes.StealableSpell] = "Крадущее заклинание", 
		[PowaAuras.BuffTypes.PurgeableSpell] = "Очищающее заклинание", 
	},
	
	-- main
	nomEnable = "Активировать Power Auras",
	aideEnable = "Включить все эффекты Power Auras",
	nomDebug = "Активировать сообщения отладки",
	aideDebug = "Включить сообщения отладки",
	ListePlayer = "Страница",
	ListeGlobal = "Глобальное",
	aideMove = "Переместить эффект сюда.",
	aideCopy = "Копировать эффект сюда.",
	nomRename = "Переименовать",
	aideRename = "Переименовать выбранную страницу эффектов.",
	nomTest = "Тест",
	nomHide = "Скрыть все",
	nomEdit = "Править",
	nomNew = "Новое",
	nomDel = "Удалить",
	nomImport = "Импорт", 
	nomExport = "Экспорт",
	nomImportSet = "Имп. набора", 
	nomExportSet = "Эксп. набора", 
	aideImport = "Нажмите Ctrl-V чтобы вставить строку-ауры и нажмите \'Принять\'.",
	aideExport = "Нажмите Ctrl-C чтобы скопировать строку-ауры.",
	aideImportSet = "Нажмите Ctrl-V чтобы вставить строку-набора-аур и нажмите \'Принять\', это сотрёт все ауры на этой странице.",
	aideExportSet = "Нажмите Ctrl-C чтобы скопировать все ауры на этой странице.",
	aideDel = "Удалить выбранный эффект (Чтобы кнопка заработала, удерживайте CTRL)",
	nomMove = "Переместить",
	nomCopy = "Копировать",
	nomPlayerEffects = "Эффекты персонажа",
	nomGlobalEffects = "Глобальные\nэффекты",
	aideEffectTooltip = "([Shift-клик] - вкл/выкл эффект)",

	-- editor
	nomSound = "Проигрываемый звук",
	aideSound = "Проиграть звук при начале.",
	nomCustomSound = "или звуковой файл:",
	aideCustomSound = "Введите название звукового файла, который поместили в папку Sounds, ПРЕЖДЕ чем запустили игру. Поддерживаются mp3 и WAV. Например: 'cookie.mp3' ;)",
	
	nomTexture = "Текстура",
	aideTexture = "Выбор отображаемой текстуры. Вы можете легко заменить текстуры путем изменения файлов Aura#.tga в директории модификации.",

	nomAnim1 = "Главная анимация",
	nomAnim2 = "Вторичная анимация",
	aideAnim1 = "Оживить текстуры или нет, с различными эффектами.",
	aideAnim2 = "Эта анимация будет показана с меньшей прозрачностью, чем основная анимация. Внимание, чтобы не перегружать экран, в одно и то же время будет показана только одна вторичная анимация.",

	nomDeform = "Деформация",
	aideDeform = "Вытягивание текстуры по ширине или по высоте.",

	aideColor = "Кликните тут, чтобы изменить цвет текстуры.",
	aideFont = "Нажмите сюда, чтобы выбрать шрифт. Нажмите OK, чтобы применить выбранное.",
	aideMultiID = "Здесь введите идентификаторы (ID) других аур для объединения проверки. Несколько ID должны разделяться с помощью '/'. ID аура можно найти в виде [#], в первой строке подсказки ауры. А лучше на http://ru.wowhead.com", 
	aideTooltipCheck = "Also check the tooltip starts with this text",

	aideBuff = "Здесь введите название баффа, или часть названия, который должен активировать/дезактивировать эффект. Вы можете ввести несколько названий, если они порядочно разделены (К примеру: Супер бафф/Сила)",
	aideBuff2 = "Здесь введите название дебаффа, или часть названия, который должен активировать/дезактивировать эффект. Вы можете ввести несколько названий, если они порядочно разделены (К примеру: Тёмная болезнь/Чума)",
	aideBuff3 = "Здесь введите тип дебаффа, который должен активировать/дезактивировать эффект (Яд, Болезнь, Проклятие, Магия или отсутствует). Вы также можете ввести несколько типов дебаффов.",
	aideBuff4 = "Enter here the name of area of effect that must trigger this effect (like a rain of fire for example, the name of this AOE can be found in the combat log)",
	aideBuff5 = "Enter here the temporary enchant which must activate this effect : optionally prepend it with 'main/' or 'off/ to designate mainhand or offhand slot. (ex: main/crippling)",
	aideBuff6 = "Вы можете ввести количество приёмов в серии, которое активирует данный эффект (пример : 1 или 1/2/3 или 0/4/5 и т.д...) ",
	aideBuff7 = "Здесь введите название или часть названия, какого-либо действия с ваших понелей команд. Эффект активируется при использовании этого действия.",
	aideBuff8 = "Здесь введите название, или часть названия заклинания из вашей книги заклинаний. Вы можете ввести идентификатор(id) заклинания [12345].",
	
	aideSpells = "Здесь введите название способности, которое вызовет оповещение.",
	aideStacks = "Здесь введите оператор и значение стопки, которые должны активировать/дезактивировать эффект. Это работает только с оператором! К примеру: '<5' '>3' '=11' '!5' '>=0' '<=6' '2-8'",

	aideStealableSpells = "Здесь введите название крадущего заклинания, которое вызовет оповещение (используйте * для любого крадущего заклинания).", 
	aidePurgeableSpells = "Здесь введите название очищающего заклинания, которое вызовет оповещение (используйте * для любого очищающего заклинания).", 

	aideUnitn = "Здесь введите название существа/игрока, который должен активировать/дезактивировать эффект. Можно ввести только имена, если они находятся в вашей группе или рейде.",
	aideUnitn2 = "Только в группе/рейде.",    

	aideMaxTex = "Define the maximum number of textures available on the Effect Editor. If you add textures on the Mod directory (with the names AURA1.tga to AURA50.tga), you must indicate the correct number here.",
	aideAddEffect = "Добавить эффект в редактор.",
	aideWowTextures = "Check this to use the texture of WoW instead of textures in the Power Auras directory for this effect.",
	aideTextAura = "Отметив тут, вы можете ввести используемый текст вместо текстуры.",
	aideRealaura = "Реальная аура",
	aideCustomTextures = "Check this to use textures in the 'Custom' subdirectory. Put the name of the texture below (ex: myTexture.tga). You can also use a Spell Name (ex: Feign Death) or SpellID (ex: 5384).",
	aideRandomColor = "Отметив это, вы устанавливаете использование случайного цвета каждый раз при активации эффекта.",

	aideTexMode = "Снимите этот флажок, чтобы использовать полупрозрачность текстур. По умолчанию, темные цвета будут более прозрачными.",

	nomActivationBy = "Активация :",

	nomOwnTex = "Своя текстуру",
	aideOwnTex = "Используйте де/бафф или способность вместо текстур.",
	nomStacks = "Стопка",

	nomUpdateSpeed = "Скорость обновления",
	nomSpeed = "Скорость анимации",
	nomFPS = "Global Animation FPS",
	nomTimerUpdate = "Timer update speed",
	nomBegin = "Начало анимации",
	nomEnd = "Конец анимации",
	nomSymetrie = "Симметрия",
	nomAlpha = "Прозрачность",
	nomPos = "Позиция",
	nomTaille = "Размер",

	nomExact = "Точное название",
	nomThreshold = "Порог",
	aideThreshInv = "Инверсия логики порога значений. Здоровье/Мана: по умолчанию = сообщать при малом количестве / отмечено = сообщать при большем количестве. Энергия/Ярость/Сила: по умолчанию = сообщать при большем количестве / отмечено = сообщать при малом количестве",
	nomThreshInv = "</>",
	nomStance = "Стойка",

	nomMine = "Применяемое мною",
	aideMine = "Отметив это, будет происходить проверка только баффов/дебаффав применяемых игроком.",
	nomDispellable = "Могу рассеять",
	aideDispellable = "Check to show only buffs that are dispellable", --- untranslated
	nomCanInterrupt = "Может быть прерван",
	aideCanInterrupt = "Check to show only for spells that can be Interrupted", --- untranslated

	nomPlayerSpell = "Player Casting", --- untranslated
	aidePlayerSpell = "Check if Player is casting a spell", --- untranslated

	nomCheckTarget = "Враждебная цель",
	nomCheckFriend = "Дружелюбная цель",
	nomCheckParty = "Участник группы",
	nomCheckFocus = "Фокус",
	nomCheckRaid = "Участник рейда",
	nomCheckGroupOrSelf = "Рейд/Группу или себя",
	nomCheckGroupAny = "Любой", 
	nomCheckOptunitn = "Название юнита",

	aideTarget = "Отметив это, будет происходить проверка только враждебной цели.",
	aideTargetFriend = "Отметив это, будет происходить проверка только дружеской цели.",
	aideParty = "Отметив это, будет происходить проверка только участников группы.",
	aideGroupOrSelf = "Отметив это, будет происходить проверка группы или рейда или вас.",
	aideFocus = "Отметив это, будет происходить проверка только фокуса.",
	aideRaid = "Отметив это, будет происходить проверка только участника рейда.",
	aideGroupAny = "Отметив это, будет происходить проверка баффов у 'любого' участника группы/рейда. Без отметки: Будет подразумеваться что 'Все' участники с баффами.",
	aideExact = "Отметив это, будет происходить проверка точного названия баффа/дебаффа/действия.",
	aideOptunitn = "Отметив это, будет происходить проверка только определённого персонажа у группе/рейде.",	
	aideStance = "Выберите в какая стойка, форма или аура вызовет событие.",

	aideShowSpinAtBeginning= "At the end of the begin animation show a 360 degree spin", --- untranslated
	nomCheckShowSpinAtBeginning = "Show Spin after begin animation ends", --- untranslated

	nomCheckShowTimer = "Показать",
	nomTimerDuration = "Длительность",
	aideTimerDuration = "Отображать таймер симулирующий длительность баффа/дебаффа на цели (0 - дезактивировать)",
	aideShowTimer = "Отображение таймера для этого эффекта.",
	aideSelectTimer = "Выберите, который таймер будет отображать длительность.",
	aideSelectTimerBuff = "Выберите, который таймер будет отображать длительность (this one is reserved for player's buffs)",
	aideSelectTimerDebuff = "Выберите, который таймер будет отображать длительность (this one is reserved for player's debuffs)",

	nomCheckShowStacks = "Показать",

	nomCheckInverse = "Инвертировать",
	aideInverse = "Инвертировать логику отображение этого эффекта только когда бафф/дебафф неактивен.",	

	nomCheckIgnoreMaj = "Игнор верхнего регистра",	
	aideIgnoreMaj = "Если отметите это, будет игнорироваться верхний/нижний регистр строчных букв в названиях баффов/дебаффов.",

	nomDuration = "Длина анимации:",
	aideDuration = "После истечения этого времени, данный эффект исчезнет (0 - дезактивировать)",

	nomCentiemes = "Показывать сотую часть",
	nomDual = "Показывать 2 таймера",
	nomHideLeadingZeros = "Убрать нули",
	nomTransparent = "Исп. прозрачные текстуры",
	nomUpdatePing = "Animate on refresh", --- untranslated
	nomClose = "Закрыть",
	nomEffectEditor = "Редактор эффектов",
	nomAdvOptions = "Опции",
	nomMaxTex = "Доступно максимум текстур",
	nomTabAnim = "Анимация",
	nomTabActiv = "Активация",
	nomTabSound = "Звук",
	nomTabTimer = "Таймер",
	nomTabStacks = "Стопки",
	nomWowTextures = "Текстуры WoW",
	nomCustomTextures = "Свои текстуры",
	nomTextAura = "Текст ауры",
	nomRealaura = "Реальные ауры",
	nomRandomColor = "Случайные цвета",
	nomTexMode = "Сияние",

	nomTalentGroup1 = "Спек 1",
	aideTalentGroup1 = "Отображать данный эффект только когда у вас активирован основной набор талантов.",
	nomTalentGroup2 = "Спек 2",
	aideTalentGroup2 = "Отображать данный эффект только когда у вас активирован второстепенный набор талантов.",

	nomReset = "Сброс позиции редактора",	
	nomPowaShowAuraBrowser = "Показать окно просмотра аур",
	
	nomDefaultTimerTexture = "Стандартная текстура таймера",
	nomTimerTexture = "Текстура таймера",
	nomDefaultStacksTexture = "Стандартная текстура стопки",
	nomStacksTexture = "Текстура стопки",
	
	Enabled = "Включено",
	Default = "По умолчанию",

	Ternary = {
		combat = "В бою",
		inRaid = "В рейде",
		inParty = "В группе",
		isResting = "Отдых",
		ismounted = "Верхом",
		inVehicle = "В транспорте",
		isAlive= "Живой",
	},

	nomWhatever = "Игнорировать",
	aideTernary = "Установите в каком состоянии, будет отображаться эта ауры.",
	TernaryYes = {
		combat = "Только когда в бою",
		inRaid = "Только когда в рейде",
		inParty = "Только когда в группе",
		isResting = "Только когда вы отдыхаете",
		ismounted = "Только когда на средстве передвижения",
		inVehicle = "Только когда в транспорте",
		isAlive= "Только когда жив",
	},
	TernaryNo = {
		combat = "Только когда НЕ в бою",
		inRaid = "Только когда НЕ в рейде",
		inParty = "Только когда НЕ в группе",
		isResting = "Только когда НЕ на отдыхе",
		ismounted = "Только когда НЕ на средстве передвижения",
		inVehicle = "Только когда НЕ в транспорте",
		isAlive= "Только когда мёртв",
	},
	TernaryAide = {
		combat = "Эффект изменен статусом боя.",
		inRaid = "Эффект изменен статусом участия в рейде.",
		inParty = "Эффект изменен статусом участия в группе.",
		isResting = "Эффект изменен статусом отдыха.",
		ismounted = "Эффект изменен статусом - на средстве передвижения.",
		inVehicle = "Эффект изменен статусом - в транспорте.",
		isAlive= "Эффект изменен статусом - живой.",
	},

	nomTimerInvertAura = "Инвертировать ауру когда время ниже",
	aidePowaTimerInvertAuraSlider = "Инвертировать ауру когда длительность меньше чем этот предел (0 - дезактивировать)",
	nomTimerHideAura = "Скрыть ауру и таймер если время выше",
	aidePowaTimerHideAuraSlider = "Скрыть ауру и таймер когда длительность больше чем этот предел (0 - дезактивировать)",

	aideTimerRounding = "When checked will round the timer up",
	nomTimerRounding = "Round Timer Up",

	aideGTFO = "Use GTFO (Boss) spell matches for AoE detection",
	nomGTFO = "Use GTFO for AoE",

	nomIgnoreUseable = "Display Only Depends on Cooldown",
	aideIgnoreUseable = "Ignores if spell is usable (just uses cooldown)",

	-- Diagnostic reason text, these have substitutions (using $1, $2 etc) to allow for different sententance constructions
	nomReasonShouldShow = "Should show because $1",
	nomReasonWontShow   = "Won't show because $1",
	
	nomReasonMulti = "All multiples match $1", --$1=Multiple match ID list
	
	nomReasonDisabled = "Power Auras Disabled",
	nomReasonGlobalCooldown = "Ignore Global Cooldown",
	
	nomReasonBuffPresent = "$1 has $2 $3", --$1=Target $2=BuffType, $3=BuffName (e.g. "Unit4 has Debuff Misery")
	nomReasonBuffMissing = "$1 doesn't have $2 $3", --$1=Target $2=BuffType, $3=BuffName (e.g. "Unit4 doesn't have Debuff Misery")
	nomReasonBuffFoundButIncomplete = "$2 $3 found for $1 but\n$4", --$1=Target $2=BuffType, $3=BuffName, $4=IncompleteReason (e.g. "Debuff Sunder Armor found for Target but\nStacks<=2")
	
	nomReasonOneInGroupHasBuff     = "$1 has $2 $3",            --$1=GroupId   $2=BuffType, $3=BuffName (e.g. "Raid23 has Buff Blessing of Kings")
	nomReasonNotAllInGroupHaveBuff = "Not all in $1 have $2 $3", --$1=GroupType $2=BuffType, $3=BuffName (e.g. "Not all in Raid have Buff Blessing of Kings")
	nomReasonAllInGroupHaveBuff    = "All in $1 have $2 $3",     --$1=GroupType $2=BuffType, $3=BuffName (e.g. "All in Raid have Buff Blessing of Kings")
	nomReasonNoOneInGroupHasBuff   = "No one in $1 has $2 $3",  --$1=GroupType $2=BuffType, $3=BuffName (e.g. "No one in Raid has Buff Blessing of Kings")

	nomReasonBuffPresentTimerInvert = "Buff present, timer invert",
	nomReasonBuffFound              = "Buff present",
	nomReasonStacksMismatch         = "Stacks = $1 expecting $2", --$1=Actual Stack count, $2=Expected Stack logic match (e.g. ">=0")

	nomReasonAuraMissing = "Aura missing",
	nomReasonAuraOff     = "Aura off",
	nomReasonAuraBad     = "Aura bad",
	
	nomReasonNotForTalentSpec = "Aura not active for this talent spec",
	
	nomReasonPlayerDead     = "Player is DEAD",
	nomReasonPlayerAlive    = "Player is Alive",
	nomReasonNoTarget       = "No Target",
	nomReasonTargetPlayer   = "Target is you",
	nomReasonTargetDead     = "Target is Dead",
	nomReasonTargetAlive    = "Target is Alive",
	nomReasonTargetFriendly = "Target is Friendly",
	nomReasonTargetNotFriendly = "Target not Friendly",
	
	nomReasonNotInCombat = "Not in combat",
	nomReasonInCombat = "In combat",
	
	nomReasonInParty = "In Party",
	nomReasonInRaid = "In Raid",
	nomReasonNotInParty = "Not in Party",
	nomReasonNotInRaid = "Not in Raid",
	nomReasonNoFocus = "No focus",	
	nomReasonNoCustomUnit = "Can't find custom unit not in party, raid or with pet unit=$1",

	nomReasonNotMounted = "Not Mounted",
	nomReasonMounted = "Mounted",		
	nomReasonNotInVehicle = "Not In Vehicle",
	nomReasonInVehicle = "In Vehicle",		
	nomReasonNotResting = "Not Resting",
	nomReasonResting = "Resting",		
	nomReasonStateOK = "State OK",

	nomReasonInverted        = "$1 (inverted)", -- $1 is the reason, but the inverted flag is set so the logic is reversed
	
	nomReasonSpellUsable     = "Spell $1 usable",
	nomReasonSpellNotUsable  = "Spell $1 not usable",
	nomReasonSpellNotReady   = "Spell $1 Not Ready, on cooldown, timer invert",
	nomReasonSpellNotEnabled = "Spell $1 not enabled ",
	nomReasonSpellNotFound   = "Spell $1 not found",
	nomReasonSpellOnCooldown = "Spell $1 on Cooldown",
	
	nomReasonStealablePresent = "$1 has Stealable spell $2", --$1=Target $2=SpellName (e.g. "Focus has Stealable spell Blessing of Wisdom")
	nomReasonNoStealablePresent = "Nobody has Stealable spell $1", --$1=SpellName (e.g. "Nobody has Stealable spell Blessing of Wisdom")
	nomReasonRaidTargetStealablePresent = "Raid$1Target has has Stealable spell $2", --$1=RaidId $2=SpellName (e.g. "Raid21Target has Stealable spell Blessing of Wisdom")
	nomReasonPartyTargetStealablePresent = "Party$1Target has has Stealable spell $2", --$1=PartyId $2=SpellName (e.g. "Party4Target has Stealable spell Blessing of Wisdom")
	
	nomReasonPurgeablePresent = "$1 has Purgeable spell $2", --$1=Target $2=SpellName (e.g. "Focus has Purgeable spell Blessing of Wisdom")
	nomReasonNoPurgeablePresent = "Nobody has Purgeable spell $1", --$1=SpellName (e.g. "Nobody has Purgeable spell Blessing of Wisdom")
	nomReasonRaidTargetPurgeablePresent = "Raid$1Target has has Purgeable spell $2", --$1=RaidId $2=SpellName (e.g. "Raid21Target has Purgeable spell Blessing of Wisdom")
	nomReasonPartyTargetPurgeablePresent = "Party$1Target has has Purgeable spell $2", --$1=PartyId $2=SpellName (e.g. "Party4Target has Purgeable spell Blessing of Wisdom")

	nomReasonAoETrigger = "AoE $1 triggered", -- $1=AoE spell name
	nomReasonAoENoTrigger = "AoE no trigger for $1", -- $1=AoE spell match
	
	nomReasonEnchantMainInvert = "Main Hand $1 enchant found, timer invert", -- $1=Enchant match
	nomReasonEnchantMain = "Main Hand $1 enchant found", -- $1=Enchant match
	nomReasonEnchantOffInvert = "Off Hand $1 enchant found, timer invert"; -- $1=Enchant match
	nomReasonEnchantOff = "Off Hand $1 enchant found", -- $1=Enchant match
	nomReasonNoEnchant = "No enchant found on weapons for $1", -- $1=Enchant match

	nomReasonNoUseCombo = "You do not use combo points",
	nomReasonComboMatch = "Combo points $1 match $2",-- $1=Combo Points, $2=Combo Match
	nomReasonNoComboMatch = "Combo points $1 no match with $2",-- $1=Combo Points, $2=Combo Match

	nomReasonActionNotFound = "not found on Action Bar",
	nomReasonActionReady = "Action Ready",
	nomReasonActionNotReadyInvert = "Action Not Ready (on cooldown), timer invert",
	nomReasonActionNotReady = "Action Not Ready (on cooldown)",
	nomReasonActionlNotEnabled = "Action not enabled",
	nomReasonActionNotUsable = "Action not usable",

	nomReasonYouAreCasting = "You are casting $1", -- $1=Casting match
	nomReasonYouAreNotCasting = "You are not casting $1", -- $1=Casting match
	nomReasonTargetCasting = "Target casting $1", -- $1=Casting match
	nomReasonFocusCasting = "Focus casting $1", -- $1=Casting match
	nomReasonRaidTargetCasting = "Raid$1Target casting $2", --$1=RaidId $2=Casting match
	nomReasonPartyTargetCasting = "Party$1Target casting $2", --$1=PartyId $2=Casting match
	nomReasonNoCasting = "Nobody's target casting $1", -- $1=Casting match
	
	nomReasonStance = "Current Stance $1, matches $2", -- $1=Current Stance, $2=Match Stance
	nomReasonNoStance = "Current Stance $1, does not match $2", -- $1=Current Stance, $2=Match Stance

	ReasonStat = {
		Health     = {MatchReason="$1 Health low",          NoMatchReason="$1 Health not low enough"},
		Mana       = {MatchReason="$1 Mana low",            NoMatchReason="$1 Mana not low enough"},
		RageEnergy = {MatchReason="$1 EnergyRagePower low", NoMatchReason="$1 EnergyRagePower not low enough"},
		Aggro      = {MatchReason="$1 has aggro",           NoMatchReason="$1 does not have aggro"},
		PvP        = {MatchReason="$1 PvP flag set",        NoMatchReason="$1 PvP flag not set"},
	},

});

end
