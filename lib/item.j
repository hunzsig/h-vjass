//物品系统
/*
物品分为
1、永久型物品 permanent
2、消耗型物品 consume
3、永久/消耗混合型物品 mixed
4、瞬逝型 moment

每个英雄最大支持使用6件物品
支持满背包合成
物品存在重量，背包有负重，超过负重即使存在合成关系，也会被暂时禁止合成

主动指玩家需要手动触发的技能
被动指英雄不需要主动使用而是在满足特定条件后（如攻击成功时）自动触发的技能
属性有三种叠加： 线性 | 非线性 | 不叠加
属性的叠加不仅限于几率也有可能是持续时间，伤害等等
-线性：直接叠加，如：100伤害的物品，持有2件时，造成伤害将提升为200
-非线性：一般几率的计算为33%左右的叠加效益，如：30%几率的物品，持有两件时，触发几率将提升为42.9%左右
-不叠加：数量不影响几率，如：30%几率的物品，持有100件也为30%
*物品不说明的属性不涉及叠加规定，默认不叠加
*/

globals
    hItem hitem
    hashtable hash_item = null
    integer ITEM_ABILITY = 'AInv' //默认物品栏技能（英雄6格那个）hjass默认全部认定这个技能为物品栏，如有需要自行更改
	integer ITEM_ABILITY_SEPARATE = 'A039'
	trigger ITEM_TRIGGER_PICKUP = null
	trigger ITEM_TRIGGER_PICKUP_FALSE = null
	trigger ITEM_TRIGGER_DROP = null
	trigger ITEM_TRIGGER_PAWN = null
	trigger ITEM_TRIGGER_SEPARATE = null
endglobals

struct hItemBean

    //物品设定
    public static integer item_id = 0            //物品id
    public static integer item_overlay = 1       //最大叠加,默认1
    public static integer item_level = 1         //等级，默认1级
    public static integer item_gold = 0          //价值黄金
    public static integer item_lumber = 0        //价值木头
    public static real item_weight = 0           //重量
    public static string item_icon = ""          //物品图标路径
    //属性
    public static real life = 0.0
	public static real mana = 0.0
	public static real move = 0.0
	public static real defend  = 0.0
	public static real attackSpeed  = 0.0
	public static string attackHuntType = ""
	public static real attackPhysical = 0.0
	public static real attackMagic = 0.0
	public static real str = 0.0
	public static real agi = 0.0
	public static real int = 0.0
	public static real strWhite = 0.0
	public static real agiWhite = 0.0
	public static real intWhite = 0.0
	public static real lifeBack = 0.0
	public static real lifeSource = 0.0
	public static real lifeSourceCurrent = 0.0
	public static real manaBack = 0.0
	public static real manaSource = 0.0
	public static real manaSourceCurrent = 0.0
	public static real resistance = 0.0
	public static real toughness = 0.0
	public static real avoid = 0.0
	public static real aim = 0.0
	public static real knocking = 0.0
	public static real violence = 0.0
	public static real mortalOppose = 0.0
	public static real punish = 0.0
	public static real punishCurrent = 0.0
	public static real punishOppose = 0.0
	public static real meditative = 0.0
	public static real help = 0.0
	public static real hemophagia = 0.0
	public static real hemophagiaSkill = 0.0
	public static real split = 0.0
	public static real splitRange = 0.0
	public static real goldRatio = 0.0
	public static real lumberRatio = 0.0
	public static real expRatio = 0.0
	public static real swimOppose = 0.0
	public static real luck = 0.0
	public static real invincible = 0.0
	public static real weight = 0.0
	public static real weightCurrent = 0.0
	public static real huntAmplitude = 0.0
	public static real huntRebound = 0.0
	public static real cure = 0.0
	public static real fire = 0.0
	public static real soil = 0.0
	public static real water = 0.0
	public static real ice = 0.0
	public static real wind = 0.0
	public static real light = 0.0
	public static real dark = 0.0
	public static real wood = 0.0
	public static real thunder = 0.0
	public static real poison = 0.0
	public static real fireOppose = 0.0
	public static real soilOppose = 0.0
	public static real waterOppose = 0.0
	public static real iceOppose = 0.0
	public static real windOppose = 0.0
	public static real lightOppose = 0.0
	public static real darkOppose = 0.0
	public static real woodOppose = 0.0
	public static real thunderOppose = 0.0
	public static real poisonOppose = 0.0
	public static real lifeBackVal = 0.0
	public static real lifeBackDuring = 0.0
	public static real manaBackVal = 0.0
	public static real manaBackDuring = 0.0
	public static real attackSpeedVal = 0.0
	public static real attackSpeedDuring = 0.0
	public static real attackPhysicalVal = 0.0
	public static real attackPhysicalDuring = 0.0
	public static real attackMagicVal = 0.0
	public static real attackMagicDuring = 0.0
	public static real moveVal = 0.0
	public static real moveDuring = 0.0
	public static real aimVal = 0.0
	public static real aimDuring = 0.0
	public static real strVal = 0.0
	public static real strDuring = 0.0
	public static real agiVal = 0.0
	public static real agiDuring = 0.0
	public static real intVal = 0.0
	public static real intDuring = 0.0
	public static real knockingVal = 0.0
	public static real knockingDuring = 0.0
	public static real violenceVal = 0.0
	public static real violenceDuring = 0.0
	public static real hemophagiaVal = 0.0
	public static real hemophagiaDuring = 0.0
	public static real hemophagiaSkillVal = 0.0
	public static real hemophagiaSkillDuring = 0.0
	public static real splitVal = 0.0
	public static real splitDuring = 0.0
	public static real luckVal = 0.0
	public static real luckDuring = 0.0
	public static real huntAmplitudeVal = 0.0
	public static real huntAmplitudeDuring = 0.0
	public static real poisonVal = 0.0
	public static real poisonDuring = 0.0
	public static real fireVal = 0.0
	public static real fireDuring = 0.0
	public static real dryVal = 0.0
	public static real dryDuring = 0.0
	public static real freezeVal = 0.0
	public static real freezeDuring = 0.0
	public static real coldVal = 0.0
	public static real coldDuring = 0.0
	public static real bluntVal = 0.0
	public static real bluntDuring = 0.0
	public static real muggleVal = 0.0
	public static real muggleDuring = 0.0
	public static real corrosionVal = 0.0
	public static real corrosionDuring = 0.0
	public static real chaosVal = 0.0
	public static real chaosDuring = 0.0
	public static real twineVal = 0.0
	public static real twineDuring = 0.0
	public static real blindVal = 0.0
	public static real blindDuring = 0.0
	public static real tortuaVal = 0.0
	public static real tortuaDuring = 0.0
	public static real weakVal = 0.0
	public static real weakDuring = 0.0
	public static real astrictVal = 0.0
	public static real astrictDuring = 0.0
	public static real foolishVal = 0.0
	public static real foolishDuring = 0.0
	public static real dullVal = 0.0
	public static real dullDuring = 0.0
	public static real dirtVal = 0.0
	public static real dirtDuring = 0.0
	public static real swimOdds = 0.0
	public static real swimDuring = 0.0
	public static real heavyOdds = 0.0
	public static real heavyVal = 0.0
	public static real breakOdds = 0.0
	public static real breakDuring = 0.0
	public static real unluckVal = 0.0
	public static real unluckDuring = 0.0
	public static real silentOdds = 0.0
	public static real silentDuring = 0.0
	public static real unarmOdds = 0.0
	public static real unarmDuring = 0.0
	public static real fetterOdds = 0.0
	public static real fetterDuring = 0.0
	public static real bombVal = 0.0
	public static string bombModel = ""
	public static real lightningChainVal = 0.0
	public static real lightningChainOdds = 0.0
	public static real lightningChainQty = 0.0
	public static real lightningChainReduce = 0.0
	public static string lightningChainModel = ""
	public static real crackFlyVal = 0.0
	public static real crackFlyOdds = 0.0
	public static real crackFlyDistance = 0.0
	public static real crackFlyHigh = 0.0
    static method create takes nothing returns hItemBean
        local hItemBean x = 0
        set x = hItemBean.allocate()
        set x.item_id = 0
        set x.item_overlay = 10
        set x.item_level = 1
        set x.item_gold = 0
        set x.item_lumber = 0
        set x.item_weight = 0
        set x.item_icon = ""
        //
        set x.life = 0
		set x.mana = 0
		set x.move = 0
		set x.defend  = 0
		set x.attackSpeed  = 0
		set x.attackHuntType = ""
		set x.attackPhysical = 0
		set x.attackMagic = 0
		set x.str = 0
		set x.agi = 0
		set x.int = 0
		set x.strWhite = 0
		set x.agiWhite = 0
		set x.intWhite = 0
		set x.lifeBack = 0
		set x.lifeSource = 0
		set x.lifeSourceCurrent = 0
		set x.manaBack = 0
		set x.manaSource = 0
		set x.manaSourceCurrent = 0
		set x.resistance = 0
		set x.toughness = 0
		set x.avoid = 0
		set x.aim = 0
		set x.knocking = 0
		set x.violence = 0
		set x.mortalOppose = 0
		set x.punish = 0
		set x.punishCurrent = 0
		set x.punishOppose = 0
		set x.meditative = 0
		set x.help = 0
		set x.hemophagia = 0
		set x.hemophagiaSkill = 0
		set x.split = 0
		set x.splitRange = 0
		set x.goldRatio = 0
		set x.lumberRatio = 0
		set x.expRatio = 0
		set x.swimOppose = 0
		set x.luck = 0
		set x.invincible = 0
		set x.weight = 0
		set x.weightCurrent = 0
		set x.huntAmplitude = 0
		set x.huntRebound = 0
		set x.cure = 0
		set x.fire = 0
		set x.soil = 0
		set x.water = 0
		set x.ice = 0
		set x.wind = 0
		set x.light = 0
		set x.dark = 0
		set x.wood = 0
		set x.thunder = 0
		set x.poison = 0
		set x.fireOppose = 0
		set x.soilOppose = 0
		set x.waterOppose = 0
		set x.iceOppose = 0
		set x.windOppose = 0
		set x.lightOppose = 0
		set x.darkOppose = 0
		set x.woodOppose = 0
		set x.thunderOppose = 0
		set x.poisonOppose = 0
		set x.lifeBackVal = 0.0
		set x.lifeBackDuring = 0.0
		set x.manaBackVal = 0.0
		set x.manaBackDuring = 0.0
		set x.attackSpeedVal = 0.0
		set x.attackSpeedDuring = 0.0
		set x.attackPhysicalVal = 0.0
		set x.attackPhysicalDuring = 0.0
		set x.attackMagicVal = 0.0
		set x.attackMagicDuring = 0.0
		set x.moveVal = 0.0
		set x.moveDuring = 0.0
		set x.aimVal = 0.0
		set x.aimDuring = 0.0
		set x.strVal = 0.0
		set x.strDuring = 0.0
		set x.agiVal = 0.0
		set x.agiDuring = 0.0
		set x.intVal = 0.0
		set x.intDuring = 0.0
		set x.knockingVal = 0.0
		set x.knockingDuring = 0.0
		set x.violenceVal = 0.0
		set x.violenceDuring = 0.0
		set x.hemophagiaVal = 0.0
		set x.hemophagiaDuring = 0.0
		set x.hemophagiaSkillVal = 0.0
		set x.hemophagiaSkillDuring = 0.0
		set x.splitVal = 0.0
		set x.splitDuring = 0.0
		set x.luckVal = 0.0
		set x.luckDuring = 0.0
		set x.huntAmplitudeVal = 0.0
		set x.huntAmplitudeDuring = 0.0
		set x.poisonVal = 0.0
		set x.poisonDuring = 0.0
		set x.fireVal = 0.0
		set x.fireDuring = 0.0
		set x.dryVal = 0.0
		set x.dryDuring = 0.0
		set x.freezeVal = 0.0
		set x.freezeDuring = 0.0
		set x.coldVal = 0.0
		set x.coldDuring = 0.0
		set x.bluntVal = 0.0
		set x.bluntDuring = 0.0
		set x.muggleVal = 0.0
		set x.muggleDuring = 0.0
		set x.corrosionVal = 0.0
		set x.corrosionDuring = 0.0
		set x.chaosVal = 0.0
		set x.chaosDuring = 0.0
		set x.twineVal = 0.0
		set x.twineDuring = 0.0
		set x.blindVal = 0.0
		set x.blindDuring = 0.0
		set x.tortuaVal = 0.0
		set x.tortuaDuring = 0.0
		set x.weakVal = 0.0
		set x.weakDuring = 0.0
		set x.astrictVal = 0.0
		set x.astrictDuring = 0.0
		set x.foolishVal = 0.0
		set x.foolishDuring = 0.0
		set x.dullVal = 0.0
		set x.dullDuring = 0.0
		set x.dirtVal = 0.0
		set x.dirtDuring = 0.0
		set x.swimOdds = 0.0
		set x.swimDuring = 0.0
		set x.heavyOdds = 0.0
		set x.heavyVal = 0.0
		set x.breakOdds = 0.0
		set x.breakDuring = 0.0
		set x.unluckVal = 0.0
		set x.unluckDuring = 0.0
		set x.silentOdds = 0.0
		set x.silentDuring = 0.0
		set x.unarmOdds = 0.0
		set x.unarmDuring = 0.0
		set x.fetterOdds = 0.0
		set x.fetterDuring = 0.0
		set x.bombVal = 0.0
		set x.bombModel = ""
		set x.lightningChainVal = 0.0
		set x.lightningChainOdds = 0.0
		set x.lightningChainQty = 0.0
		set x.lightningChainReduce = 0.0
		set x.lightningChainModel = ""
		set x.crackFlyVal = 0.0
		set x.crackFlyOdds = 0.0
		set x.crackFlyDistance = 0.0
		set x.crackFlyHigh = 0.0
        return x
    endmethod
    method destroy takes nothing returns nothing
        set item_id = 0
        set item_overlay = 10
        set item_level = 1
        set item_gold = 0
        set item_lumber = 0
        set item_weight = 0
		set item_icon = ""
        //
        set life = 0
		set mana = 0
		set move = 0
		set defend  = 0
		set attackSpeed  = 0
		set attackHuntType = ""
		set attackPhysical = 0
		set attackMagic = 0
		set str = 0
		set agi = 0
		set int = 0
		set strWhite = 0
		set agiWhite = 0
		set intWhite = 0
		set lifeBack = 0
		set lifeSource = 0
		set lifeSourceCurrent = 0
		set manaBack = 0
		set manaSource = 0
		set manaSourceCurrent = 0
		set resistance = 0
		set toughness = 0
		set avoid = 0
		set aim = 0
		set knocking = 0
		set violence = 0
		set mortalOppose = 0
		set punish = 0
		set punishCurrent = 0
		set punishOppose = 0
		set meditative = 0
		set help = 0
		set hemophagia = 0
		set hemophagiaSkill = 0
		set split = 0
		set splitRange = 0
		set goldRatio = 0
		set lumberRatio = 0
		set expRatio = 0
		set swimOppose = 0
		set luck = 0
		set invincible = 0
		set weight = 0
		set weightCurrent = 0
		set huntAmplitude = 0
		set huntRebound = 0
		set cure = 0
		set fire = 0
		set soil = 0
		set water = 0
		set ice = 0
		set wind = 0
		set light = 0
		set dark = 0
		set wood = 0
		set thunder = 0
		set poison = 0
		set fireOppose = 0
		set soilOppose = 0
		set waterOppose = 0
		set iceOppose = 0
		set windOppose = 0
		set lightOppose = 0
		set darkOppose = 0
		set woodOppose = 0
		set thunderOppose = 0
		set poisonOppose = 0
		set lifeBackVal = 0.0
		set lifeBackDuring = 0.0
		set manaBackVal = 0.0
		set manaBackDuring = 0.0
		set attackSpeedVal = 0.0
		set attackSpeedDuring = 0.0
		set attackPhysicalVal = 0.0
		set attackPhysicalDuring = 0.0
		set attackMagicVal = 0.0
		set attackMagicDuring = 0.0
		set moveVal = 0.0
		set moveDuring = 0.0
		set aimVal = 0.0
		set aimDuring = 0.0
		set strVal = 0.0
		set strDuring = 0.0
		set agiVal = 0.0
		set agiDuring = 0.0
		set intVal = 0.0
		set intDuring = 0.0
		set knockingVal = 0.0
		set knockingDuring = 0.0
		set violenceVal = 0.0
		set violenceDuring = 0.0
		set hemophagiaVal = 0.0
		set hemophagiaDuring = 0.0
		set hemophagiaSkillVal = 0.0
		set hemophagiaSkillDuring = 0.0
		set splitVal = 0.0
		set splitDuring = 0.0
		set luckVal = 0.0
		set luckDuring = 0.0
		set huntAmplitudeVal = 0.0
		set huntAmplitudeDuring = 0.0
		set poisonVal = 0.0
		set poisonDuring = 0.0
		set fireVal = 0.0
		set fireDuring = 0.0
		set dryVal = 0.0
		set dryDuring = 0.0
		set freezeVal = 0.0
		set freezeDuring = 0.0
		set coldVal = 0.0
		set coldDuring = 0.0
		set bluntVal = 0.0
		set bluntDuring = 0.0
		set muggleVal = 0.0
		set muggleDuring = 0.0
		set corrosionVal = 0.0
		set corrosionDuring = 0.0
		set chaosVal = 0.0
		set chaosDuring = 0.0
		set twineVal = 0.0
		set twineDuring = 0.0
		set blindVal = 0.0
		set blindDuring = 0.0
		set tortuaVal = 0.0
		set tortuaDuring = 0.0
		set weakVal = 0.0
		set weakDuring = 0.0
		set astrictVal = 0.0
		set astrictDuring = 0.0
		set foolishVal = 0.0
		set foolishDuring = 0.0
		set dullVal = 0.0
		set dullDuring = 0.0
		set dirtVal = 0.0
		set dirtDuring = 0.0
		set swimOdds = 0.0
		set swimDuring = 0.0
		set heavyOdds = 0.0
		set heavyVal = 0.0
		set breakOdds = 0.0
		set breakDuring = 0.0
		set unluckVal = 0.0
		set unluckDuring = 0.0
		set silentOdds = 0.0
		set silentDuring = 0.0
		set unarmOdds = 0.0
		set unarmDuring = 0.0
		set fetterOdds = 0.0
		set fetterDuring = 0.0
		set bombVal = 0.0
		set bombModel = ""
		set lightningChainVal = 0.0
		set lightningChainOdds = 0.0
		set lightningChainQty = 0.0
		set lightningChainReduce = 0.0
		set lightningChainModel = ""
		set crackFlyVal = 0.0
		set crackFlyOdds = 0.0
		set crackFlyDistance = 0.0
		set crackFlyHigh = 0.0
    endmethod
endstruct

struct hItem

    private static integer hk_item_init = 10
    private static integer hk_item_id = 11
    private static integer hk_item_type = 12
    private static integer hk_item_overlay = 13
    private static integer hk_item_level = 14
    private static integer hk_item_gold = 15
    private static integer hk_item_lumber = 16
    private static integer hk_item_weight = 17
    private static integer hk_item_icon = 18
    private static integer hk_item_is_powerup = 19
	private static integer hk_item_combat_effectiveness = 20
    //
    private static integer hk_life = 1000
    private static integer hk_mana = 1001
    private static integer hk_move = 1002
    private static integer hk_defend  = 1003
    private static integer hk_attackSpeed = 1004
    private static integer hk_attackHuntType = 1005
    private static integer hk_attackPhysical = 1006
    private static integer hk_attackMagic = 1007
    private static integer hk_str = 1008
    private static integer hk_agi = 1009
    private static integer hk_int = 1010
    private static integer hk_strWhite = 1011
    private static integer hk_agiWhite = 1012
    private static integer hk_intWhite = 1013
    private static integer hk_lifeBack = 1014
    private static integer hk_lifeSource = 1015
    private static integer hk_lifeSourceCurrent = 1016
    private static integer hk_manaBack = 1017
    private static integer hk_manaSource = 1018
    private static integer hk_manaSourceCurrent = 1019
    private static integer hk_resistance = 1020
    private static integer hk_toughness = 1021
    private static integer hk_avoid = 1022
    private static integer hk_aim = 1023
    private static integer hk_knocking = 1024
    private static integer hk_violence = 1025
    private static integer hk_mortalOppose = 1026
    private static integer hk_punish = 1027
    private static integer hk_punishCurrent = 1028
    private static integer hk_punishOppose = 1029
    private static integer hk_meditative = 1030
    private static integer hk_help = 1031
    private static integer hk_hemophagia = 1032
    private static integer hk_hemophagiaSkill = 1033
    private static integer hk_split = 1034
    private static integer hk_splitRange = 1035
    private static integer hk_goldRatio = 1036
    private static integer hk_lumberRatio = 1037
    private static integer hk_expRatio = 1038
    private static integer hk_swimOppose = 1039
    private static integer hk_luck = 1040
    private static integer hk_invincible = 1041
    private static integer hk_weight = 1042
    private static integer hk_weightCurrent = 1043
    private static integer hk_huntAmplitude = 1044
    private static integer hk_huntRebound = 1045
    private static integer hk_cure = 1046
    private static integer hk_fire = 1047
    private static integer hk_soil = 1048
    private static integer hk_water = 1049
    private static integer hk_ice = 1050
    private static integer hk_wind = 1051
    private static integer hk_light = 1052
    private static integer hk_dark = 1053
    private static integer hk_wood = 1054
    private static integer hk_thunder = 1055
    private static integer hk_poison = 1056
    private static integer hk_fireOppose = 1057
    private static integer hk_soilOppose = 1058
    private static integer hk_waterOppose = 1059
    private static integer hk_iceOppose = 1060
    private static integer hk_windOppose = 1061
    private static integer hk_lightOppose = 1062
    private static integer hk_darkOppose = 1063
    private static integer hk_woodOppose = 1064
    private static integer hk_thunderOppose = 1065
    private static integer hk_poisonOppose = 1066
    private static integer hk_lifeBackVal = 10000
    private static integer hk_lifeBackDuring = 10001
    private static integer hk_manaBackVal = 10100
    private static integer hk_manaBackDuring = 10101
    private static integer hk_attackSpeedVal = 10200
    private static integer hk_attackSpeedDuring = 10201
    private static integer hk_attackPhysicalVal = 10300
    private static integer hk_attackPhysicalDuring = 10301
    private static integer hk_attackMagicVal = 10400
    private static integer hk_attackMagicDuring = 10401
    private static integer hk_moveVal = 10500
    private static integer hk_moveDuring = 10501
    private static integer hk_aimVal = 10600
    private static integer hk_aimDuring = 10601
    private static integer hk_strVal = 10700
    private static integer hk_strDuring = 10701
    private static integer hk_agiVal = 10800
    private static integer hk_agiDuring = 10801
    private static integer hk_intVal = 10900
    private static integer hk_intDuring = 10901
    private static integer hk_knockingVal = 11000
    private static integer hk_knockingDuring = 11001
    private static integer hk_violenceVal = 11100
    private static integer hk_violenceDuring = 11101
    private static integer hk_hemophagiaVal = 11200
    private static integer hk_hemophagiaDuring = 11201
    private static integer hk_hemophagiaSkillVal = 11300
    private static integer hk_hemophagiaSkillDuring = 11301
    private static integer hk_splitVal = 11400
    private static integer hk_splitDuring = 11401
    private static integer hk_luckVal = 11500
    private static integer hk_luckDuring = 11501
    private static integer hk_huntAmplitudeVal = 11600
    private static integer hk_huntAmplitudeDuring = 11601
    private static integer hk_poisonVal = 11700
    private static integer hk_poisonDuring = 11701
    private static integer hk_fireVal = 11800
    private static integer hk_fireDuring = 11801
    private static integer hk_dryVal = 11900
    private static integer hk_dryDuring = 11901
    private static integer hk_freezeVal = 12000
    private static integer hk_freezeDuring = 12001
    private static integer hk_coldVal = 12100
    private static integer hk_coldDuring = 12101
    private static integer hk_bluntVal = 12200
    private static integer hk_bluntDuring = 12201
    private static integer hk_muggleVal = 12300
    private static integer hk_muggleDuring = 12301
    private static integer hk_corrosionVal = 12400
    private static integer hk_corrosionDuring = 12401
    private static integer hk_chaosVal = 12500
    private static integer hk_chaosDuring = 12501
    private static integer hk_twineVal = 12600
    private static integer hk_twineDuring = 12601
    private static integer hk_blindVal = 12700
    private static integer hk_blindDuring = 12701
    private static integer hk_tortuaVal = 12800
    private static integer hk_tortuaDuring = 12801
    private static integer hk_weakVal = 12900
    private static integer hk_weakDuring = 12901
    private static integer hk_astrictVal = 13000
    private static integer hk_astrictDuring = 13001
    private static integer hk_foolishVal = 13100
    private static integer hk_foolishDuring = 13101
    private static integer hk_dullVal = 13200
    private static integer hk_dullDuring = 13201
    private static integer hk_dirtVal = 13300
    private static integer hk_dirtDuring = 13301
    private static integer hk_swimOdds = 13400
    private static integer hk_swimDuring = 13401
    private static integer hk_heavyOdds = 13500
    private static integer hk_heavyVal = 13501
    private static integer hk_breakOdds = 13600
    private static integer hk_breakDuring = 13601
    private static integer hk_unluckVal = 13700
    private static integer hk_unluckDuring = 13701
    private static integer hk_silentOdds = 13800
    private static integer hk_silentDuring = 13801
    private static integer hk_unarmOdds = 13900
    private static integer hk_unarmDuring = 13901
    private static integer hk_fetterOdds = 14000
    private static integer hk_fetterDuring = 14001
    private static integer hk_bombVal = 14100
    private static integer hk_bombRange = 14101
    private static integer hk_bombModel = 14102
    private static integer hk_lightningChainVal = 14200
    private static integer hk_lightningChainOdds = 14201
    private static integer hk_lightningChainQty = 14202
    private static integer hk_lightningChainReduce = 14203
    private static integer hk_lightningChainModel = 14204
    private static integer hk_crackFlyVal = 14300
    private static integer hk_crackFlyOdds = 14301
    private static integer hk_crackFlyDistance = 14302
    private static integer hk_crackFlyHigh = 14303

	/**
     * 删除物品回调
     */
    private static method delCall takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local item it = htime.getItem( t, 1 )
        call htime.delTimer(t)
        if( it != null ) then
	        call RemoveItem( it )
            set it = null
    	endif
    endmethod
	/**
	 * 删除物品，可延时
	 */
	public static method del takes item it,real during returns nothing
		local timer t = null
        if( during <= 0 ) then
            call RemoveItem( it )
            set it = null
        else
            set t = htime.setTimeout( during , function thistype.delCall)
            call htime.setItem( t, 1 ,it )
        endif
	endmethod

    //获取注册的物品数量
    public static method getTotalQty takes nothing returns integer
        local integer qty = LoadInteger(hash_item,0,StringHash("_TOTAL_QTY_"))
        if(qty<=0)then
            set qty = 0
        endif
        return qty
    endmethod
	//设定注册的物品数量
    public static method setTotalQty takes integer qty returns nothing
        call SaveInteger(hash_item,0,StringHash("_TOTAL_QTY_"), qty)
    endmethod

	//获取某单位身上空格物品栏数量
    public static method getEmptySlot takes unit u returns integer
        local integer i
        local item it = null
        local integer qty = UnitInventorySize(u)
        set i = 0
        loop
            exitwhen i > 5
            set it = UnitItemInSlot(u, i)
            if(it != null and GetItemCharges(it) > 0) then
                set qty = qty - 1
            endif
            set i=i+1
        endloop
        return qty
    endmethod

	//获取某单位身上某种物品的使用总次数
    public static method getCharges takes integer itemId,unit u returns integer
        local integer i
        local integer charges = 0
        local item it = null
        set i = 0
        loop
            exitwhen i > 5
            set it = UnitItemInSlot(u, i)
            if(it != null and GetItemTypeId(it) == itemId and GetItemCharges(it) > 0) then
                set charges = charges + GetItemCharges(it)
            endif
            set i=i+1
        endloop
        set it = null
        return charges
    endmethod

	//绑定物品到系统截断调用
    private static method formatEval takes hItemBean bean returns nothing
		local item it = null
		local integer score = 0
        if(bean.item_id!=0)then
			call setTotalQty(1+getTotalQty())
			set it = CreateItem(bean.item_id,0,0)
			if(IsItemPowerup(it))then
				call SaveBoolean(hash_item, bean.item_id, hk_item_is_powerup,true)
			else
				call SaveBoolean(hash_item, bean.item_id, hk_item_is_powerup,false)
			endif
			call RemoveItem(it)
			set it = null
            call SaveBoolean(hash_item, bean.item_id, hk_item_init, true)
            call SaveInteger(hash_item, bean.item_id, hk_item_overlay, bean.item_overlay)
            call SaveInteger(hash_item, bean.item_id, hk_item_level, bean.item_level)
            call SaveInteger(hash_item, bean.item_id, hk_item_gold, bean.item_gold)
            call SaveInteger(hash_item, bean.item_id, hk_item_lumber, bean.item_lumber)
            call SaveReal(hash_item, bean.item_id, hk_item_weight, bean.item_weight)
            call SaveStr(hash_item, bean.item_id, hk_item_icon, bean.item_icon)
            //
            call SaveReal(hash_item, bean.item_id, hk_goldRatio, bean.goldRatio)
            call SaveReal(hash_item, bean.item_id, hk_lumberRatio, bean.lumberRatio)
            call SaveReal(hash_item, bean.item_id, hk_expRatio, bean.expRatio)
            call SaveReal(hash_item, bean.item_id, hk_life, bean.life)
            call SaveReal(hash_item, bean.item_id, hk_mana, bean.mana)
            call SaveReal(hash_item, bean.item_id, hk_move, bean.move)
            call SaveReal(hash_item, bean.item_id, hk_defend , bean.defend )
            call SaveReal(hash_item, bean.item_id, hk_attackSpeed, bean.attackSpeed)
            call SaveReal(hash_item, bean.item_id, hk_attackPhysical, bean.attackPhysical)
            call SaveReal(hash_item, bean.item_id, hk_attackMagic, bean.attackMagic)
            call SaveReal(hash_item, bean.item_id, hk_str, bean.str)
            call SaveReal(hash_item, bean.item_id, hk_agi, bean.agi)
            call SaveReal(hash_item, bean.item_id, hk_int, bean.int)
            call SaveReal(hash_item, bean.item_id, hk_strWhite, bean.strWhite)
            call SaveReal(hash_item, bean.item_id, hk_agiWhite, bean.agiWhite)
            call SaveReal(hash_item, bean.item_id, hk_intWhite, bean.intWhite)
            call SaveReal(hash_item, bean.item_id, hk_lifeBack, bean.lifeBack)
            call SaveReal(hash_item, bean.item_id, hk_lifeSource, bean.lifeSource)
            call SaveReal(hash_item, bean.item_id, hk_lifeSourceCurrent, bean.lifeSourceCurrent)
            call SaveReal(hash_item, bean.item_id, hk_manaBack, bean.manaBack)
            call SaveReal(hash_item, bean.item_id, hk_manaSource, bean.manaSource)
            call SaveReal(hash_item, bean.item_id, hk_manaSourceCurrent, bean.manaSourceCurrent)
            call SaveReal(hash_item, bean.item_id, hk_resistance, bean.resistance)
            call SaveReal(hash_item, bean.item_id, hk_toughness, bean.toughness)
            call SaveReal(hash_item, bean.item_id, hk_avoid, bean.avoid)
            call SaveReal(hash_item, bean.item_id, hk_aim, bean.aim)
            call SaveReal(hash_item, bean.item_id, hk_knocking, bean.knocking)
            call SaveReal(hash_item, bean.item_id, hk_violence, bean.violence)
            call SaveReal(hash_item, bean.item_id, hk_mortalOppose, bean.mortalOppose)
            call SaveReal(hash_item, bean.item_id, hk_punish, bean.punish)
            call SaveReal(hash_item, bean.item_id, hk_punishCurrent, bean.punishCurrent)
            call SaveReal(hash_item, bean.item_id, hk_punishOppose, bean.punishOppose)
            call SaveReal(hash_item, bean.item_id, hk_meditative, bean.meditative)
            call SaveReal(hash_item, bean.item_id, hk_help, bean.help)
            call SaveReal(hash_item, bean.item_id, hk_hemophagia, bean.hemophagia)
            call SaveReal(hash_item, bean.item_id, hk_hemophagiaSkill, bean.hemophagiaSkill)
            call SaveReal(hash_item, bean.item_id, hk_split, bean.split)
            call SaveReal(hash_item, bean.item_id, hk_splitRange, bean.splitRange)
            call SaveReal(hash_item, bean.item_id, hk_swimOppose, bean.swimOppose)
            call SaveReal(hash_item, bean.item_id, hk_luck, bean.luck)
            call SaveReal(hash_item, bean.item_id, hk_invincible, bean.invincible)
            call SaveReal(hash_item, bean.item_id, hk_weight, bean.weight)
            call SaveReal(hash_item, bean.item_id, hk_weightCurrent, bean.weightCurrent)
            call SaveReal(hash_item, bean.item_id, hk_huntAmplitude, bean.huntAmplitude)
            call SaveReal(hash_item, bean.item_id, hk_huntRebound, bean.huntRebound)
            call SaveReal(hash_item, bean.item_id, hk_cure, bean.cure)
            call SaveReal(hash_item, bean.item_id, hk_fire, bean.fire)
            call SaveReal(hash_item, bean.item_id, hk_soil, bean.soil)
            call SaveReal(hash_item, bean.item_id, hk_water, bean.water)
            call SaveReal(hash_item, bean.item_id, hk_ice, bean.ice)
            call SaveReal(hash_item, bean.item_id, hk_wind, bean.wind)
            call SaveReal(hash_item, bean.item_id, hk_light, bean.light)
            call SaveReal(hash_item, bean.item_id, hk_dark, bean.dark)
            call SaveReal(hash_item, bean.item_id, hk_wood, bean.wood)
            call SaveReal(hash_item, bean.item_id, hk_thunder, bean.thunder)
            call SaveReal(hash_item, bean.item_id, hk_poison, bean.poison)
            call SaveReal(hash_item, bean.item_id, hk_fireOppose, bean.fireOppose)
            call SaveReal(hash_item, bean.item_id, hk_soilOppose, bean.soilOppose)
            call SaveReal(hash_item, bean.item_id, hk_waterOppose, bean.waterOppose)
            call SaveReal(hash_item, bean.item_id, hk_iceOppose, bean.iceOppose)
            call SaveReal(hash_item, bean.item_id, hk_windOppose, bean.windOppose)
            call SaveReal(hash_item, bean.item_id, hk_lightOppose, bean.lightOppose)
            call SaveReal(hash_item, bean.item_id, hk_darkOppose, bean.darkOppose)
            call SaveReal(hash_item, bean.item_id, hk_woodOppose, bean.woodOppose)
            call SaveReal(hash_item, bean.item_id, hk_thunderOppose, bean.thunderOppose)
            call SaveReal(hash_item, bean.item_id, hk_poisonOppose, bean.poisonOppose)
            call SaveReal(hash_item, bean.item_id, hk_lifeBackVal, bean.lifeBackVal)
            call SaveReal(hash_item, bean.item_id, hk_lifeBackDuring, bean.lifeBackDuring)
            call SaveReal(hash_item, bean.item_id, hk_manaBackVal, bean.manaBackVal)
            call SaveReal(hash_item, bean.item_id, hk_manaBackDuring, bean.manaBackDuring)
            call SaveReal(hash_item, bean.item_id, hk_attackSpeedVal, bean.attackSpeedVal)
            call SaveReal(hash_item, bean.item_id, hk_attackSpeedDuring, bean.attackSpeedDuring)
            call SaveReal(hash_item, bean.item_id, hk_attackPhysicalVal, bean.attackPhysicalVal)
            call SaveReal(hash_item, bean.item_id, hk_attackPhysicalDuring, bean.attackPhysicalDuring)
            call SaveReal(hash_item, bean.item_id, hk_attackMagicVal, bean.attackMagicVal)
            call SaveReal(hash_item, bean.item_id, hk_attackMagicDuring, bean.attackMagicDuring)
            call SaveReal(hash_item, bean.item_id, hk_moveVal, bean.moveVal)
            call SaveReal(hash_item, bean.item_id, hk_moveDuring, bean.moveDuring)
            call SaveReal(hash_item, bean.item_id, hk_aimVal, bean.aimVal)
            call SaveReal(hash_item, bean.item_id, hk_aimDuring, bean.aimDuring)
            call SaveReal(hash_item, bean.item_id, hk_strVal, bean.strVal)
            call SaveReal(hash_item, bean.item_id, hk_strDuring, bean.strDuring)
            call SaveReal(hash_item, bean.item_id, hk_agiVal, bean.agiVal)
            call SaveReal(hash_item, bean.item_id, hk_agiDuring, bean.agiDuring)
            call SaveReal(hash_item, bean.item_id, hk_intVal, bean.intVal)
            call SaveReal(hash_item, bean.item_id, hk_intDuring, bean.intDuring)
            call SaveReal(hash_item, bean.item_id, hk_knockingVal, bean.knockingVal)
            call SaveReal(hash_item, bean.item_id, hk_knockingDuring, bean.knockingDuring)
            call SaveReal(hash_item, bean.item_id, hk_violenceVal, bean.violenceVal)
            call SaveReal(hash_item, bean.item_id, hk_violenceDuring, bean.violenceDuring)
            call SaveReal(hash_item, bean.item_id, hk_hemophagiaVal, bean.hemophagiaVal)
            call SaveReal(hash_item, bean.item_id, hk_hemophagiaDuring, bean.hemophagiaDuring)
            call SaveReal(hash_item, bean.item_id, hk_hemophagiaSkillVal, bean.hemophagiaSkillVal)
            call SaveReal(hash_item, bean.item_id, hk_hemophagiaSkillDuring, bean.hemophagiaSkillDuring)
            call SaveReal(hash_item, bean.item_id, hk_splitVal, bean.splitVal)
            call SaveReal(hash_item, bean.item_id, hk_splitDuring, bean.splitDuring)
            call SaveReal(hash_item, bean.item_id, hk_luckVal, bean.luckVal)
            call SaveReal(hash_item, bean.item_id, hk_luckDuring, bean.luckDuring)
            call SaveReal(hash_item, bean.item_id, hk_huntAmplitudeVal, bean.huntAmplitudeVal)
            call SaveReal(hash_item, bean.item_id, hk_huntAmplitudeDuring, bean.huntAmplitudeDuring)
            call SaveReal(hash_item, bean.item_id, hk_poisonVal, bean.poisonVal)
            call SaveReal(hash_item, bean.item_id, hk_poisonDuring, bean.poisonDuring)
            call SaveReal(hash_item, bean.item_id, hk_fireVal, bean.fireVal)
            call SaveReal(hash_item, bean.item_id, hk_fireDuring, bean.fireDuring)
            call SaveReal(hash_item, bean.item_id, hk_dryVal, bean.dryVal)
            call SaveReal(hash_item, bean.item_id, hk_dryDuring, bean.dryDuring)
            call SaveReal(hash_item, bean.item_id, hk_freezeVal, bean.freezeVal)
            call SaveReal(hash_item, bean.item_id, hk_freezeDuring, bean.freezeDuring)
            call SaveReal(hash_item, bean.item_id, hk_coldVal, bean.coldVal)
            call SaveReal(hash_item, bean.item_id, hk_coldDuring, bean.coldDuring)
            call SaveReal(hash_item, bean.item_id, hk_bluntVal, bean.bluntVal)
            call SaveReal(hash_item, bean.item_id, hk_bluntDuring, bean.bluntDuring)
            call SaveReal(hash_item, bean.item_id, hk_muggleVal, bean.muggleVal)
            call SaveReal(hash_item, bean.item_id, hk_muggleDuring, bean.muggleDuring)
            call SaveReal(hash_item, bean.item_id, hk_corrosionVal, bean.corrosionVal)
            call SaveReal(hash_item, bean.item_id, hk_corrosionDuring, bean.corrosionDuring)
            call SaveReal(hash_item, bean.item_id, hk_chaosVal, bean.chaosVal)
            call SaveReal(hash_item, bean.item_id, hk_chaosDuring, bean.chaosDuring)
            call SaveReal(hash_item, bean.item_id, hk_twineVal, bean.twineVal)
            call SaveReal(hash_item, bean.item_id, hk_twineDuring, bean.twineDuring)
            call SaveReal(hash_item, bean.item_id, hk_blindVal, bean.blindVal)
            call SaveReal(hash_item, bean.item_id, hk_blindDuring, bean.blindDuring)
            call SaveReal(hash_item, bean.item_id, hk_tortuaVal, bean.tortuaVal)
            call SaveReal(hash_item, bean.item_id, hk_tortuaDuring, bean.tortuaDuring)
            call SaveReal(hash_item, bean.item_id, hk_weakVal, bean.weakVal)
            call SaveReal(hash_item, bean.item_id, hk_weakDuring, bean.weakDuring)
            call SaveReal(hash_item, bean.item_id, hk_astrictVal, bean.astrictVal)
            call SaveReal(hash_item, bean.item_id, hk_astrictDuring, bean.astrictDuring)
            call SaveReal(hash_item, bean.item_id, hk_foolishVal, bean.foolishVal)
            call SaveReal(hash_item, bean.item_id, hk_foolishDuring, bean.foolishDuring)
            call SaveReal(hash_item, bean.item_id, hk_dullVal, bean.dullVal)
            call SaveReal(hash_item, bean.item_id, hk_dullDuring, bean.dullDuring)
            call SaveReal(hash_item, bean.item_id, hk_dirtVal, bean.dirtVal)
            call SaveReal(hash_item, bean.item_id, hk_dirtDuring, bean.dirtDuring)
            call SaveReal(hash_item, bean.item_id, hk_swimOdds, bean.swimOdds)
            call SaveReal(hash_item, bean.item_id, hk_swimDuring, bean.swimDuring)
            call SaveReal(hash_item, bean.item_id, hk_heavyOdds, bean.heavyOdds)
            call SaveReal(hash_item, bean.item_id, hk_heavyVal, bean.heavyVal)
            call SaveReal(hash_item, bean.item_id, hk_breakOdds, bean.breakOdds)
            call SaveReal(hash_item, bean.item_id, hk_breakDuring, bean.breakDuring)
            call SaveReal(hash_item, bean.item_id, hk_unluckVal, bean.unluckVal)
            call SaveReal(hash_item, bean.item_id, hk_unluckDuring, bean.unluckDuring)
            call SaveReal(hash_item, bean.item_id, hk_silentOdds, bean.silentOdds)
            call SaveReal(hash_item, bean.item_id, hk_silentDuring, bean.silentDuring)
            call SaveReal(hash_item, bean.item_id, hk_unarmOdds, bean.unarmOdds)
            call SaveReal(hash_item, bean.item_id, hk_unarmDuring, bean.unarmDuring)
            call SaveReal(hash_item, bean.item_id, hk_fetterOdds, bean.fetterOdds)
            call SaveReal(hash_item, bean.item_id, hk_fetterDuring, bean.fetterDuring)
            call SaveReal(hash_item, bean.item_id, hk_bombVal, bean.bombVal)
            call SaveStr(hash_item, bean.item_id, hk_bombModel, bean.bombModel)
            call SaveReal(hash_item, bean.item_id, hk_lightningChainVal, bean.lightningChainVal)
            call SaveReal(hash_item, bean.item_id, hk_lightningChainOdds, bean.lightningChainOdds)
            call SaveReal(hash_item, bean.item_id, hk_lightningChainQty, bean.lightningChainQty)
            call SaveReal(hash_item, bean.item_id, hk_lightningChainReduce, bean.lightningChainReduce)
            call SaveStr(hash_item, bean.item_id, hk_lightningChainModel, bean.lightningChainModel)
            call SaveReal(hash_item, bean.item_id, hk_crackFlyVal, bean.crackFlyVal)
            call SaveReal(hash_item, bean.item_id, hk_crackFlyOdds, bean.crackFlyOdds)
            call SaveReal(hash_item, bean.item_id, hk_crackFlyDistance, bean.crackFlyDistance)
            call SaveReal(hash_item, bean.item_id, hk_crackFlyHigh, bean.crackFlyHigh)
			//-------
			if(bean.life!=0)then
				set score = score + R2I(bean.life)*3
			endif
			if(bean.mana!=0)then
				set score = score + R2I(bean.mana)*1
			endif
			if(bean.move!=0)then
				set score = score + R2I(bean.move)*5
			endif
			if(bean.defend!=0)then
				set score = score + R2I(bean.defend)*2
			endif
			if(bean.attackSpeed!=0)then
				set score = score + R2I(bean.attackSpeed)*3
			endif
			if(bean.attackPhysical!=0)then
				set score = score + R2I(bean.attackPhysical)*4
			endif
			if(bean.attackMagic!=0)then
				set score = score + R2I(bean.attackMagic)*4
			endif
			if(bean.str!=0)then
				set score = score + R2I(bean.str)*3
			endif
			if(bean.agi!=0)then
				set score = score + R2I(bean.agi)*3
			endif
			if(bean.int!=0)then
				set score = score + R2I(bean.int)*3
			endif
			if(bean.strWhite!=0)then
				set score = score + R2I(bean.strWhite)*4
			endif
			if(bean.agiWhite!=0)then
				set score = score + R2I(bean.agiWhite)*4
			endif
			if(bean.intWhite!=0)then
				set score = score + R2I(bean.intWhite)*4
			endif
			if(bean.lifeBack!=0)then
				set score = score + R2I(bean.lifeBack)*2
			endif
			if(bean.lifeSource!=0)then
				set score = score + R2I(bean.lifeSource)*1
			endif
			if(bean.manaBack!=0)then
				set score = score + R2I(bean.manaBack)*1
			endif
			if(bean.manaSource!=0)then
				set score = score + R2I(bean.manaSource)*1
			endif
			if(bean.resistance!=0)then
				set score = score + R2I(bean.resistance)*2
			endif
			if(bean.toughness!=0)then
				set score = score + R2I(bean.toughness)*3
			endif
			if(bean.avoid!=0)then
				set score = score + R2I(bean.avoid)*2
			endif
			if(bean.aim!=0)then
				set score = score + R2I(bean.aim)*2
			endif
			if(bean.knocking!=0)then
				set score = score + R2I(bean.knocking)*4
			endif
			if(bean.violence!=0)then
				set score = score + R2I(bean.violence)*4
			endif
			if(bean.mortalOppose!=0)then
				set score = score + R2I(bean.mortalOppose)*1
			endif
			if(bean.punish!=0)then
				set score = score + R2I(bean.punish)*3
			endif
			if(bean.punishOppose!=0)then
				set score = score + R2I(bean.punishOppose)*3
			endif
			if(bean.meditative!=0)then
				set score = score + R2I(bean.meditative)*1
			endif
			if(bean.help!=0)then
				set score = score + R2I(bean.help)*1
			endif
			if(bean.hemophagia!=0)then
				set score = score + R2I(bean.hemophagia)*4
			endif
			if(bean.hemophagiaSkill!=0)then
				set score = score + R2I(bean.hemophagiaSkill)*4
			endif
			if(bean.split!=0)then
				set score = score + R2I(bean.split)*4
			endif
			if(bean.splitRange!=0)then
				set score = score + R2I(bean.splitRange)*1
			endif
			if(bean.goldRatio!=0)then
				set score = score + R2I(bean.goldRatio)*1
			endif
			if(bean.lumberRatio!=0)then
				set score = score + R2I(bean.lumberRatio)*1
			endif
			if(bean.expRatio!=0)then
				set score = score + R2I(bean.expRatio)*1
			endif
			if(bean.swimOppose!=0)then
				set score = score + R2I(bean.swimOppose)*2
			endif
			if(bean.luck!=0)then
				set score = score + R2I(bean.luck)*2
			endif
			if(bean.invincible!=0)then
				set score = score + R2I(bean.invincible)*2
			endif
			if(bean.huntAmplitude!=0)then
				set score = score + R2I(bean.huntAmplitude)*10
			endif
			if(bean.huntRebound!=0)then
				set score = score + R2I(bean.huntRebound)*5
			endif
			if(bean.cure!=0)then
				set score = score + R2I(bean.cure)*1
			endif
			if(bean.fire!=0)then
				set score = score + R2I(bean.fire)*5
			endif
			if(bean.soil!=0)then
				set score = score + R2I(bean.soil)*5
			endif
			if(bean.water!=0)then
				set score = score + R2I(bean.water)*5
			endif
			if(bean.ice!=0)then
				set score = score + R2I(bean.ice)*5
			endif
			if(bean.wind!=0)then
				set score = score + R2I(bean.wind)*5
			endif
			if(bean.light!=0)then
				set score = score + R2I(bean.light)*5
			endif
			if(bean.dark!=0)then
				set score = score + R2I(bean.dark)*5
			endif
			if(bean.wood!=0)then
				set score = score + R2I(bean.wood)*5
			endif
			if(bean.thunder!=0)then
				set score = score + R2I(bean.thunder)*5
			endif
			if(bean.poison!=0)then
				set score = score + R2I(bean.poison)*5
			endif
			if(bean.fireOppose!=0)then
				set score = score + R2I(bean.fireOppose)*4
			endif
			if(bean.soilOppose!=0)then
				set score = score + R2I(bean.soilOppose)*4
			endif
			if(bean.waterOppose!=0)then
				set score = score + R2I(bean.waterOppose)*4
			endif
			if(bean.iceOppose!=0)then
				set score = score + R2I(bean.iceOppose)*4
			endif
			if(bean.windOppose!=0)then
				set score = score + R2I(bean.windOppose)*4
			endif
			if(bean.lightOppose!=0)then
				set score = score + R2I(bean.lightOppose)*4
			endif
			if(bean.darkOppose!=0)then
				set score = score + R2I(bean.darkOppose)*4
			endif
			if(bean.woodOppose!=0)then
				set score = score + R2I(bean.woodOppose)*4
			endif
			if(bean.thunderOppose!=0)then
				set score = score + R2I(bean.thunderOppose)*4
			endif
			if(bean.poisonOppose!=0)then
				set score = score + R2I(bean.poisonOppose)*4
			endif
			if(bean.lifeBackVal!=0)then
				set score = score + R2I(bean.lifeBackVal)*3
			endif
			if(bean.lifeBackDuring!=0)then
				set score = score + R2I(bean.lifeBackDuring)*3
			endif
			if(bean.manaBackVal!=0)then
				set score = score + R2I(bean.manaBackVal)*3
			endif
			if(bean.manaBackDuring!=0)then
				set score = score + R2I(bean.manaBackDuring)*3
			endif
			if(bean.attackSpeedVal!=0)then
				set score = score + R2I(bean.attackSpeedVal)*3
			endif
			if(bean.attackSpeedDuring!=0)then
				set score = score + R2I(bean.attackSpeedDuring)*3
			endif
			if(bean.attackPhysicalVal!=0)then
				set score = score + R2I(bean.attackPhysicalVal)*3
			endif
			if(bean.attackPhysicalDuring!=0)then
				set score = score + R2I(bean.attackPhysicalDuring)*3
			endif
			if(bean.attackMagicVal!=0)then
				set score = score + R2I(bean.attackMagicVal)*3
			endif
			if(bean.attackMagicDuring!=0)then
				set score = score + R2I(bean.attackMagicDuring)*3
			endif
			if(bean.moveVal!=0)then
				set score = score + R2I(bean.moveVal)*3
			endif
			if(bean.moveDuring!=0)then
				set score = score + R2I(bean.moveDuring)*3
			endif
			if(bean.aimVal!=0)then
				set score = score + R2I(bean.aimVal)*3
			endif
			if(bean.aimDuring!=0)then
				set score = score + R2I(bean.aimDuring)*3
			endif
			if(bean.strVal!=0)then
				set score = score + R2I(bean.strVal)*3
			endif
			if(bean.strDuring!=0)then
				set score = score + R2I(bean.strDuring)*3
			endif
			if(bean.agiVal!=0)then
				set score = score + R2I(bean.agiVal)*3
			endif
			if(bean.agiDuring!=0)then
				set score = score + R2I(bean.agiDuring)*3
			endif
			if(bean.intVal!=0)then
				set score = score + R2I(bean.intVal)*3
			endif
			if(bean.intDuring!=0)then
				set score = score + R2I(bean.intDuring)*3
			endif
			if(bean.knockingVal!=0)then
				set score = score + R2I(bean.knockingVal)*3
			endif
			if(bean.knockingDuring!=0)then
				set score = score + R2I(bean.knockingDuring)*3
			endif
			if(bean.violenceVal!=0)then
				set score = score + R2I(bean.violenceVal)*3
			endif
			if(bean.violenceDuring!=0)then
				set score = score + R2I(bean.violenceDuring)*3
			endif
			if(bean.hemophagiaVal!=0)then
				set score = score + R2I(bean.hemophagiaVal)*3
			endif
			if(bean.hemophagiaDuring!=0)then
				set score = score + R2I(bean.hemophagiaDuring)*3
			endif
			if(bean.hemophagiaSkillVal!=0)then
				set score = score + R2I(bean.hemophagiaSkillVal)*3
			endif
			if(bean.hemophagiaSkillDuring!=0)then
				set score = score + R2I(bean.hemophagiaSkillDuring)*3
			endif
			if(bean.splitVal!=0)then
				set score = score + R2I(bean.splitVal)*3
			endif
			if(bean.splitDuring!=0)then
				set score = score + R2I(bean.splitDuring)*3
			endif
			if(bean.luckVal!=0)then
				set score = score + R2I(bean.luckVal)*3
			endif
			if(bean.luckDuring!=0)then
				set score = score + R2I(bean.luckDuring)*3
			endif
			if(bean.huntAmplitudeVal!=0)then
				set score = score + R2I(bean.huntAmplitudeVal)*3
			endif
			if(bean.huntAmplitudeDuring!=0)then
				set score = score + R2I(bean.huntAmplitudeDuring)*3
			endif
			if(bean.poisonVal!=0)then
				set score = score + R2I(bean.poisonVal)*3
			endif
			if(bean.poisonDuring!=0)then
				set score = score + R2I(bean.poisonDuring)*3
			endif
			if(bean.fireVal!=0)then
				set score = score + R2I(bean.fireVal)*3
			endif
			if(bean.fireDuring!=0)then
				set score = score + R2I(bean.fireDuring)*3
			endif
			if(bean.dryVal!=0)then
				set score = score + R2I(bean.dryVal)*3
			endif
			if(bean.dryDuring!=0)then
				set score = score + R2I(bean.dryDuring)*3
			endif
			if(bean.freezeVal!=0)then
				set score = score + R2I(bean.freezeVal)*3
			endif
			if(bean.freezeDuring!=0)then
				set score = score + R2I(bean.freezeDuring)*3
			endif
			if(bean.coldVal!=0)then
				set score = score + R2I(bean.coldVal)*3
			endif
			if(bean.coldDuring!=0)then
				set score = score + R2I(bean.coldDuring)*3
			endif
			if(bean.bluntVal!=0)then
				set score = score + R2I(bean.bluntVal)*3
			endif
			if(bean.bluntDuring!=0)then
				set score = score + R2I(bean.bluntDuring)*3
			endif
			if(bean.muggleVal!=0)then
				set score = score + R2I(bean.muggleVal)*3
			endif
			if(bean.muggleDuring!=0)then
				set score = score + R2I(bean.muggleDuring)*3
			endif
			if(bean.corrosionVal!=0)then
				set score = score + R2I(bean.corrosionVal)*3
			endif
			if(bean.corrosionDuring!=0)then
				set score = score + R2I(bean.corrosionDuring)*3
			endif
			if(bean.chaosVal!=0)then
				set score = score + R2I(bean.chaosVal)*3
			endif
			if(bean.chaosDuring!=0)then
				set score = score + R2I(bean.chaosDuring)*3
			endif
			if(bean.twineVal!=0)then
				set score = score + R2I(bean.twineVal)*3
			endif
			if(bean.twineDuring!=0)then
				set score = score + R2I(bean.twineDuring)*3
			endif
			if(bean.blindVal!=0)then
				set score = score + R2I(bean.blindVal)*3
			endif
			if(bean.blindDuring!=0)then
				set score = score + R2I(bean.blindDuring)*3
			endif
			if(bean.tortuaVal!=0)then
				set score = score + R2I(bean.tortuaVal)*3
			endif
			if(bean.tortuaDuring!=0)then
				set score = score + R2I(bean.tortuaDuring)*3
			endif
			if(bean.weakVal!=0)then
				set score = score + R2I(bean.weakVal)*3
			endif
			if(bean.weakDuring!=0)then
				set score = score + R2I(bean.weakDuring)*3
			endif
			if(bean.astrictVal!=0)then
				set score = score + R2I(bean.astrictVal)*3
			endif
			if(bean.astrictDuring!=0)then
				set score = score + R2I(bean.astrictDuring)*3
			endif
			if(bean.foolishVal!=0)then
				set score = score + R2I(bean.foolishVal)*3
			endif
			if(bean.foolishDuring!=0)then
				set score = score + R2I(bean.foolishDuring)*3
			endif
			if(bean.dullVal!=0)then
				set score = score + R2I(bean.dullVal)*3
			endif
			if(bean.dullDuring!=0)then
				set score = score + R2I(bean.dullDuring)*3
			endif
			if(bean.dirtVal!=0)then
				set score = score + R2I(bean.dirtVal)*3
			endif
			if(bean.dirtDuring!=0)then
				set score = score + R2I(bean.dirtDuring)*3
			endif
			if(bean.swimOdds!=0)then
				set score = score + R2I(bean.swimOdds)*3
			endif
			if(bean.swimDuring!=0)then
				set score = score + R2I(bean.swimDuring)*3
			endif
			if(bean.heavyOdds!=0)then
				set score = score + R2I(bean.heavyOdds)*3
			endif
			if(bean.heavyVal!=0)then
				set score = score + R2I(bean.heavyVal)*3
			endif
			if(bean.breakOdds!=0)then
				set score = score + R2I(bean.breakOdds)*3
			endif
			if(bean.breakDuring!=0)then
				set score = score + R2I(bean.breakDuring)*3
			endif
			if(bean.unluckVal!=0)then
				set score = score + R2I(bean.unluckVal)*3
			endif
			if(bean.unluckDuring!=0)then
				set score = score + R2I(bean.unluckDuring)*3
			endif
			if(bean.silentOdds!=0)then
				set score = score + R2I(bean.silentOdds)*3
			endif
			if(bean.silentDuring!=0)then
				set score = score + R2I(bean.silentDuring)*3
			endif
			if(bean.unarmOdds!=0)then
				set score = score + R2I(bean.unarmOdds)*3
			endif
			if(bean.unarmDuring!=0)then
				set score = score + R2I(bean.unarmDuring)*3
			endif
			if(bean.fetterOdds!=0)then
				set score = score + R2I(bean.fetterOdds)*3
			endif
			if(bean.fetterDuring!=0)then
				set score = score + R2I(bean.fetterDuring)*3
			endif
			if(bean.bombVal!=0)then
				set score = score + R2I(bean.bombVal)*3
			endif
			if(bean.lightningChainVal!=0)then
				set score = score + R2I(bean.lightningChainVal)*3
			endif
			if(bean.lightningChainOdds!=0)then
				set score = score + R2I(bean.lightningChainOdds)*3
			endif
			if(bean.lightningChainQty!=0)then
				set score = score + R2I(bean.lightningChainQty)*3
			endif
			if(bean.lightningChainReduce!=0)then
				set score = score + R2I(bean.lightningChainReduce)*3
			endif
			if(bean.crackFlyVal!=0)then
				set score = score + R2I(bean.crackFlyVal)*3
			endif
			if(bean.crackFlyOdds!=0)then
				set score = score + R2I(bean.crackFlyOdds)*3
			endif
			if(bean.crackFlyDistance!=0)then
				set score = score + R2I(bean.crackFlyDistance)*3
			endif
			if(bean.crackFlyHigh!=0)then
				set score = score + R2I(bean.crackFlyHigh)*3
			endif
			call SaveInteger(hash_item, bean.item_id, hk_item_combat_effectiveness,score/10)
        endif
	endmethod

    //绑定物品到系统
    public static method format takes hItemBean bean returns nothing
		call formatEval.evaluate(bean)
    endmethod

	//获取物品ID是否注册过
    public static method isFormat takes integer itemId returns boolean
        return LoadBoolean(hash_item, itemId, hk_item_init)
    endmethod

	//增加物品属性
	public static method addAttr takes integer item_id,real charges,unit whichUnit returns nothing
		local real goldRatio = LoadReal(hash_item, item_id, hk_goldRatio)*charges
		local real lumberRatio = LoadReal(hash_item, item_id, hk_lumberRatio)*charges
		local real expRatio = LoadReal(hash_item, item_id, hk_expRatio)*charges
		local real life = LoadReal(hash_item, item_id, hk_life)*charges
		local real mana = LoadReal(hash_item, item_id, hk_mana)*charges
		local real move = LoadReal(hash_item, item_id, hk_move)*charges
		local real defend  = LoadReal(hash_item, item_id, hk_defend )*charges
		local real attackSpeed = LoadReal(hash_item, item_id, hk_attackSpeed)*charges
		local real attackPhysical = LoadReal(hash_item, item_id, hk_attackPhysical)*charges
		local real attackMagic = LoadReal(hash_item, item_id, hk_attackMagic)*charges
		local real str = LoadReal(hash_item, item_id, hk_str)*charges
		local real agi = LoadReal(hash_item, item_id, hk_agi)*charges
		local real int = LoadReal(hash_item, item_id, hk_int)*charges
		local real strWhite = LoadReal(hash_item, item_id, hk_strWhite)*charges
		local real agiWhite = LoadReal(hash_item, item_id, hk_agiWhite)*charges
		local real intWhite = LoadReal(hash_item, item_id, hk_intWhite)*charges
		local real lifeBack = LoadReal(hash_item, item_id, hk_lifeBack)*charges
		local real lifeSource = LoadReal(hash_item, item_id, hk_lifeSource)*charges
		local real lifeSourceCurrent = LoadReal(hash_item, item_id, hk_lifeSourceCurrent)*charges
		local real manaBack = LoadReal(hash_item, item_id, hk_manaBack)*charges
		local real manaSource = LoadReal(hash_item, item_id, hk_manaSource)*charges
		local real manaSourceCurrent = LoadReal(hash_item, item_id, hk_manaSourceCurrent)*charges
		local real resistance = LoadReal(hash_item, item_id, hk_resistance)*charges
		local real toughness = LoadReal(hash_item, item_id, hk_toughness)*charges
		local real avoid = LoadReal(hash_item, item_id, hk_avoid)*charges
		local real aim = LoadReal(hash_item, item_id, hk_aim)*charges
		local real knocking = LoadReal(hash_item, item_id, hk_knocking)*charges
		local real violence = LoadReal(hash_item, item_id, hk_violence)*charges
		local real mortalOppose = LoadReal(hash_item, item_id, hk_mortalOppose)*charges
		local real punish = LoadReal(hash_item, item_id, hk_punish)*charges
		local real punishCurrent = LoadReal(hash_item, item_id, hk_punishCurrent)*charges
		local real punishOppose = LoadReal(hash_item, item_id, hk_punishOppose)*charges
		local real meditative = LoadReal(hash_item, item_id, hk_meditative)*charges
		local real help = LoadReal(hash_item, item_id, hk_help)*charges
		local real hemophagia = LoadReal(hash_item, item_id, hk_hemophagia)*charges
		local real hemophagiaSkill = LoadReal(hash_item, item_id, hk_hemophagiaSkill)*charges
		local real split = LoadReal(hash_item, item_id, hk_split)*charges
		local real splitRange = LoadReal(hash_item, item_id, hk_splitRange)*charges
		local real swimOppose = LoadReal(hash_item, item_id, hk_swimOppose)*charges
		local real luck = LoadReal(hash_item, item_id, hk_luck)*charges
		local real invincible = LoadReal(hash_item, item_id, hk_invincible)*charges
		local real weight = LoadReal(hash_item, item_id, hk_weight)*charges
		local real weightCurrent = LoadReal(hash_item, item_id, hk_weightCurrent)*charges
		local real huntAmplitude = LoadReal(hash_item, item_id, hk_huntAmplitude)*charges
		local real huntRebound = LoadReal(hash_item, item_id, hk_huntRebound)*charges
		local real cure = LoadReal(hash_item, item_id, hk_cure)*charges
		local real fire = LoadReal(hash_item, item_id, hk_fire)*charges
		local real soil = LoadReal(hash_item, item_id, hk_soil)*charges
		local real water = LoadReal(hash_item, item_id, hk_water)*charges
		local real ice = LoadReal(hash_item, item_id, hk_ice)*charges
		local real wind = LoadReal(hash_item, item_id, hk_wind)*charges
		local real light = LoadReal(hash_item, item_id, hk_light)*charges
		local real dark = LoadReal(hash_item, item_id, hk_dark)*charges
		local real wood = LoadReal(hash_item, item_id, hk_wood)*charges
		local real thunder = LoadReal(hash_item, item_id, hk_thunder)*charges
		local real poison = LoadReal(hash_item, item_id, hk_poison)*charges
		local real fireOppose = LoadReal(hash_item, item_id, hk_fireOppose)*charges
		local real soilOppose = LoadReal(hash_item, item_id, hk_soilOppose)*charges
		local real waterOppose = LoadReal(hash_item, item_id, hk_waterOppose)*charges
		local real iceOppose = LoadReal(hash_item, item_id, hk_iceOppose)*charges
		local real windOppose = LoadReal(hash_item, item_id, hk_windOppose)*charges
		local real lightOppose = LoadReal(hash_item, item_id, hk_lightOppose)*charges
		local real darkOppose = LoadReal(hash_item, item_id, hk_darkOppose)*charges
		local real woodOppose = LoadReal(hash_item, item_id, hk_woodOppose)*charges
		local real thunderOppose = LoadReal(hash_item, item_id, hk_thunderOppose)*charges
		local real poisonOppose = LoadReal(hash_item, item_id, hk_poisonOppose)*charges
		local real lifeBackVal = LoadReal(hash_item, item_id, hk_lifeBackVal)*charges
		local real lifeBackDuring = LoadReal(hash_item, item_id, hk_lifeBackDuring)*charges
		local real manaBackVal = LoadReal(hash_item, item_id, hk_manaBackVal)*charges
		local real manaBackDuring = LoadReal(hash_item, item_id, hk_manaBackDuring)*charges
		local real attackSpeedVal = LoadReal(hash_item, item_id, hk_attackSpeedVal)*charges
		local real attackSpeedDuring = LoadReal(hash_item, item_id, hk_attackSpeedDuring)*charges
		local real attackPhysicalVal = LoadReal(hash_item, item_id, hk_attackPhysicalVal)*charges
		local real attackPhysicalDuring = LoadReal(hash_item, item_id, hk_attackPhysicalDuring)*charges
		local real attackMagicVal = LoadReal(hash_item, item_id, hk_attackMagicVal)*charges
		local real attackMagicDuring = LoadReal(hash_item, item_id, hk_attackMagicDuring)*charges
		local real moveVal = LoadReal(hash_item, item_id, hk_moveVal)*charges
		local real moveDuring = LoadReal(hash_item, item_id, hk_moveDuring)*charges
		local real aimVal = LoadReal(hash_item, item_id, hk_aimVal)*charges
		local real aimDuring = LoadReal(hash_item, item_id, hk_aimDuring)*charges
		local real strVal = LoadReal(hash_item, item_id, hk_strVal)*charges
		local real strDuring = LoadReal(hash_item, item_id, hk_strDuring)*charges
		local real agiVal = LoadReal(hash_item, item_id, hk_agiVal)*charges
		local real agiDuring = LoadReal(hash_item, item_id, hk_agiDuring)*charges
		local real intVal = LoadReal(hash_item, item_id, hk_intVal)*charges
		local real intDuring = LoadReal(hash_item, item_id, hk_intDuring)*charges
		local real knockingVal = LoadReal(hash_item, item_id, hk_knockingVal)*charges
		local real knockingDuring = LoadReal(hash_item, item_id, hk_knockingDuring)*charges
		local real violenceVal = LoadReal(hash_item, item_id, hk_violenceVal)*charges
		local real violenceDuring = LoadReal(hash_item, item_id, hk_violenceDuring)*charges
		local real hemophagiaVal = LoadReal(hash_item, item_id, hk_hemophagiaVal)*charges
		local real hemophagiaDuring = LoadReal(hash_item, item_id, hk_hemophagiaDuring)*charges
		local real hemophagiaSkillVal = LoadReal(hash_item, item_id, hk_hemophagiaSkillVal)*charges
		local real hemophagiaSkillDuring = LoadReal(hash_item, item_id, hk_hemophagiaSkillDuring)*charges
		local real splitVal = LoadReal(hash_item, item_id, hk_splitVal)*charges
		local real splitDuring = LoadReal(hash_item, item_id, hk_splitDuring)*charges
		local real luckVal = LoadReal(hash_item, item_id, hk_luckVal)*charges
		local real luckDuring = LoadReal(hash_item, item_id, hk_luckDuring)*charges
		local real huntAmplitudeVal = LoadReal(hash_item, item_id, hk_huntAmplitudeVal)*charges
		local real huntAmplitudeDuring = LoadReal(hash_item, item_id, hk_huntAmplitudeDuring)*charges
		local real poisonVal = LoadReal(hash_item, item_id, hk_poisonVal)*charges
		local real poisonDuring = LoadReal(hash_item, item_id, hk_poisonDuring)*charges
		local real fireVal = LoadReal(hash_item, item_id, hk_fireVal)*charges
		local real fireDuring = LoadReal(hash_item, item_id, hk_fireDuring)*charges
		local real dryVal = LoadReal(hash_item, item_id, hk_dryVal)*charges
		local real dryDuring = LoadReal(hash_item, item_id, hk_dryDuring)*charges
		local real freezeVal = LoadReal(hash_item, item_id, hk_freezeVal)*charges
		local real freezeDuring = LoadReal(hash_item, item_id, hk_freezeDuring)*charges
		local real coldVal = LoadReal(hash_item, item_id, hk_coldVal)*charges
		local real coldDuring = LoadReal(hash_item, item_id, hk_coldDuring)*charges
		local real bluntVal = LoadReal(hash_item, item_id, hk_bluntVal)*charges
		local real bluntDuring = LoadReal(hash_item, item_id, hk_bluntDuring)*charges
		local real muggleVal = LoadReal(hash_item, item_id, hk_muggleVal)*charges
		local real muggleDuring = LoadReal(hash_item, item_id, hk_muggleDuring)*charges
		local real corrosionVal = LoadReal(hash_item, item_id, hk_corrosionVal)*charges
		local real corrosionDuring = LoadReal(hash_item, item_id, hk_corrosionDuring)*charges
		local real chaosVal = LoadReal(hash_item, item_id, hk_chaosVal)*charges
		local real chaosDuring = LoadReal(hash_item, item_id, hk_chaosDuring)*charges
		local real twineVal = LoadReal(hash_item, item_id, hk_twineVal)*charges
		local real twineDuring = LoadReal(hash_item, item_id, hk_twineDuring)*charges
		local real blindVal = LoadReal(hash_item, item_id, hk_blindVal)*charges
		local real blindDuring = LoadReal(hash_item, item_id, hk_blindDuring)*charges
		local real tortuaVal = LoadReal(hash_item, item_id, hk_tortuaVal)*charges
		local real tortuaDuring = LoadReal(hash_item, item_id, hk_tortuaDuring)*charges
		local real weakVal = LoadReal(hash_item, item_id, hk_weakVal)*charges
		local real weakDuring = LoadReal(hash_item, item_id, hk_weakDuring)*charges
		local real astrictVal = LoadReal(hash_item, item_id, hk_astrictVal)*charges
		local real astrictDuring = LoadReal(hash_item, item_id, hk_astrictDuring)*charges
		local real foolishVal = LoadReal(hash_item, item_id, hk_foolishVal)*charges
		local real foolishDuring = LoadReal(hash_item, item_id, hk_foolishDuring)*charges
		local real dullVal = LoadReal(hash_item, item_id, hk_dullVal)*charges
		local real dullDuring = LoadReal(hash_item, item_id, hk_dullDuring)*charges
		local real dirtVal = LoadReal(hash_item, item_id, hk_dirtVal)*charges
		local real dirtDuring = LoadReal(hash_item, item_id, hk_dirtDuring)*charges
		local real swimOdds = LoadReal(hash_item, item_id, hk_swimOdds)*charges
		local real swimDuring = LoadReal(hash_item, item_id, hk_swimDuring)*charges
		local real heavyOdds = LoadReal(hash_item, item_id, hk_heavyOdds)*charges
		local real heavyVal = LoadReal(hash_item, item_id, hk_heavyVal)*charges
		local real breakOdds = LoadReal(hash_item, item_id, hk_breakOdds)*charges
		local real breakDuring = LoadReal(hash_item, item_id, hk_breakDuring)*charges
		local real unluckVal = LoadReal(hash_item, item_id, hk_unluckVal)*charges
		local real unluckDuring = LoadReal(hash_item, item_id, hk_unluckDuring)*charges
		local real silentOdds = LoadReal(hash_item, item_id, hk_silentOdds)*charges
		local real silentDuring = LoadReal(hash_item, item_id, hk_silentDuring)*charges
		local real unarmOdds = LoadReal(hash_item, item_id, hk_unarmOdds)*charges
		local real unarmDuring = LoadReal(hash_item, item_id, hk_unarmDuring)*charges
		local real fetterOdds = LoadReal(hash_item, item_id, hk_fetterOdds)*charges
		local real fetterDuring = LoadReal(hash_item, item_id, hk_fetterDuring)*charges
		local real bombVal = LoadReal(hash_item, item_id, hk_bombVal)*charges
		local string bombModel = LoadStr(hash_item, item_id, hk_bombModel)
		local real lightningChainVal = LoadReal(hash_item, item_id, hk_lightningChainVal)*charges
		local real lightningChainOdds = LoadReal(hash_item, item_id, hk_lightningChainOdds)*charges
		local real lightningChainQty = LoadReal(hash_item, item_id, hk_lightningChainQty)*charges
		local real lightningChainReduce = LoadReal(hash_item, item_id, hk_lightningChainReduce)*charges
		local string lightningChainModel = LoadStr(hash_item, item_id, hk_lightningChainModel)
		local real crackFlyVal = LoadReal(hash_item, item_id, hk_crackFlyVal)*charges
		local real crackFlyOdds = LoadReal(hash_item, item_id, hk_crackFlyOdds)*charges
		local real crackFlyDistance = LoadReal(hash_item, item_id, hk_crackFlyDistance)*charges
		local real crackFlyHigh = LoadReal(hash_item, item_id, hk_crackFlyHigh)*charges
		if(goldRatio!=0)then
			call hplayer.addGoldRatio(GetOwningPlayer(whichUnit),goldRatio,0)
		endif
		if(lumberRatio!=0)then
			call hplayer.addLumberRatio(GetOwningPlayer(whichUnit),lumberRatio,0)
		endif
		if(expRatio!=0)then
			call hplayer.addExpRatio(GetOwningPlayer(whichUnit),expRatio,0)
		endif
		if(life!=0)then
			call hattr.addLife(whichUnit,life,0)
		endif
		if(mana!=0)then
			call hattr.addMana(whichUnit,mana,0)
		endif
		if(move!=0)then
			call hattr.addMove(whichUnit,move,0)
		endif
		if(defend !=0)then
			call hattr.addDefend (whichUnit,defend ,0)
		endif
		if(attackSpeed!=0)then
			call hattr.addAttackSpeed(whichUnit,attackSpeed,0)
		endif
		if(attackPhysical!=0)then
			call hattr.addAttackPhysical(whichUnit,attackPhysical,0)
		endif
		if(attackMagic!=0)then
			call hattr.addAttackMagic(whichUnit,attackMagic,0)
		endif
		if(str!=0)then
			call hattr.addStr(whichUnit,str,0)
		endif
		if(agi!=0)then
			call hattr.addAgi(whichUnit,agi,0)
		endif
		if(int!=0)then
			call hattr.addInt(whichUnit,int,0)
		endif
		if(strWhite!=0)then
			call hattr.addStrWhite(whichUnit,strWhite,0)
		endif
		if(agiWhite!=0)then
			call hattr.addAgiWhite(whichUnit,agiWhite,0)
		endif
		if(intWhite!=0)then
			call hattr.addIntWhite(whichUnit,intWhite,0)
		endif
		if(lifeBack!=0)then
			call hattr.addLifeBack(whichUnit,lifeBack,0)
		endif
		if(lifeSource!=0)then
			call hattr.addLifeSource(whichUnit,lifeSource,0)
		endif
		if(lifeSourceCurrent!=0)then
			call hattr.addLifeSourceCurrent(whichUnit,lifeSourceCurrent,0)
		endif
		if(manaBack!=0)then
			call hattr.addManaBack(whichUnit,manaBack,0)
		endif
		if(manaSource!=0)then
			call hattr.addManaSource(whichUnit,manaSource,0)
		endif
		if(manaSourceCurrent!=0)then
			call hattr.addManaSourceCurrent(whichUnit,manaSourceCurrent,0)
		endif
		if(resistance!=0)then
			call hattr.addResistance(whichUnit,resistance,0)
		endif
		if(toughness!=0)then
			call hattr.addToughness(whichUnit,toughness,0)
		endif
		if(avoid!=0)then
			call hattr.addAvoid(whichUnit,avoid,0)
		endif
		if(aim!=0)then
			call hattr.addAim(whichUnit,aim,0)
		endif
		if(knocking!=0)then
			call hattr.addKnocking(whichUnit,knocking,0)
		endif
		if(violence!=0)then
			call hattr.addViolence(whichUnit,violence,0)
		endif
		if(mortalOppose!=0)then
			call hattr.addMortalOppose(whichUnit,mortalOppose,0)
		endif
		if(punish!=0)then
			call hattr.addPunish(whichUnit,punish,0)
		endif
		if(punishCurrent!=0)then
			call hattr.addPunishCurrent(whichUnit,punishCurrent,0)
		endif
		if(punishOppose!=0)then
			call hattr.addPunishOppose(whichUnit,punishOppose,0)
		endif
		if(meditative!=0)then
			call hattr.addMeditative(whichUnit,meditative,0)
		endif
		if(help!=0)then
			call hattr.addHelp(whichUnit,help,0)
		endif
		if(hemophagia!=0)then
			call hattr.addHemophagia(whichUnit,hemophagia,0)
		endif
		if(hemophagiaSkill!=0)then
			call hattr.addHemophagiaSkill(whichUnit,hemophagiaSkill,0)
		endif
		if(split!=0)then
			call hattr.addSplit(whichUnit,split,0)
		endif
		if(splitRange!=0)then
			call hattr.addSplitRange(whichUnit,splitRange,0)
		endif
		if(swimOppose!=0)then
			call hattr.addSwimOppose(whichUnit,swimOppose,0)
		endif
		if(luck!=0)then
			call hattr.addLuck(whichUnit,luck,0)
		endif
		if(invincible!=0)then
			call hattr.addInvincible(whichUnit,invincible,0)
		endif
		if(weight!=0)then
			call hattr.addWeight(whichUnit,weight,0)
		endif
		if(weightCurrent!=0)then
			call hattr.addWeightCurrent(whichUnit,weightCurrent,0)
		endif
		if(huntAmplitude!=0)then
			call hattr.addHuntAmplitude(whichUnit,huntAmplitude,0)
		endif
		if(huntRebound!=0)then
			call hattr.addHuntRebound(whichUnit,huntRebound,0)
		endif
		if(cure!=0)then
			call hattr.addCure(whichUnit,cure,0)
		endif
		if(fire!=0)then
			call hattrNatural.addFire(whichUnit,fire,0)
		endif
		if(soil!=0)then
			call hattrNatural.addSoil(whichUnit,soil,0)
		endif
		if(water!=0)then
			call hattrNatural.addWater(whichUnit,water,0)
		endif
		if(ice!=0)then
			call hattrNatural.addIce(whichUnit,ice,0)
		endif
		if(wind!=0)then
			call hattrNatural.addWind(whichUnit,wind,0)
		endif
		if(light!=0)then
			call hattrNatural.addLight(whichUnit,light,0)
		endif
		if(dark!=0)then
			call hattrNatural.addDark(whichUnit,dark,0)
		endif
		if(wood!=0)then
			call hattrNatural.addWood(whichUnit,wood,0)
		endif
		if(thunder!=0)then
			call hattrNatural.addThunder(whichUnit,thunder,0)
		endif
		if(poison!=0)then
			call hattrNatural.addPoison(whichUnit,poison,0)
		endif
		if(fireOppose!=0)then
			call hattrNatural.addFireOppose(whichUnit,fireOppose,0)
		endif
		if(soilOppose!=0)then
			call hattrNatural.addSoilOppose(whichUnit,soilOppose,0)
		endif
		if(waterOppose!=0)then
			call hattrNatural.addWaterOppose(whichUnit,waterOppose,0)
		endif
		if(iceOppose!=0)then
			call hattrNatural.addIceOppose(whichUnit,iceOppose,0)
		endif
		if(windOppose!=0)then
			call hattrNatural.addWindOppose(whichUnit,windOppose,0)
		endif
		if(lightOppose!=0)then
			call hattrNatural.addLightOppose(whichUnit,lightOppose,0)
		endif
		if(darkOppose!=0)then
			call hattrNatural.addDarkOppose(whichUnit,darkOppose,0)
		endif
		if(woodOppose!=0)then
			call hattrNatural.addWoodOppose(whichUnit,woodOppose,0)
		endif
		if(thunderOppose!=0)then
			call hattrNatural.addThunderOppose(whichUnit,thunderOppose,0)
		endif
		if(poisonOppose!=0)then
			call hattrNatural.addPoisonOppose(whichUnit,poisonOppose,0)
		endif
		if(lifeBackVal!=0)then
			call hattrEffect.addLifeBackVal(whichUnit,lifeBackVal,0)
		endif
		if(lifeBackDuring!=0)then
			call hattrEffect.addLifeBackDuring(whichUnit,lifeBackDuring,0)
		endif
		if(manaBackVal!=0)then
			call hattrEffect.addManaBackVal(whichUnit,manaBackVal,0)
		endif
		if(manaBackDuring!=0)then
			call hattrEffect.addManaBackDuring(whichUnit,manaBackDuring,0)
		endif
		if(attackSpeedVal!=0)then
			call hattrEffect.addAttackSpeedVal(whichUnit,attackSpeedVal,0)
		endif
		if(attackSpeedDuring!=0)then
			call hattrEffect.addAttackSpeedDuring(whichUnit,attackSpeedDuring,0)
		endif
		if(attackPhysicalVal!=0)then
			call hattrEffect.addAttackPhysicalVal(whichUnit,attackPhysicalVal,0)
		endif
		if(attackPhysicalDuring!=0)then
			call hattrEffect.addAttackPhysicalDuring(whichUnit,attackPhysicalDuring,0)
		endif
		if(attackMagicVal!=0)then
			call hattrEffect.addAttackMagicVal(whichUnit,attackMagicVal,0)
		endif
		if(attackMagicDuring!=0)then
			call hattrEffect.addAttackMagicDuring(whichUnit,attackMagicDuring,0)
		endif
		if(moveVal!=0)then
			call hattrEffect.addMoveVal(whichUnit,moveVal,0)
		endif
		if(moveDuring!=0)then
			call hattrEffect.addMoveDuring(whichUnit,moveDuring,0)
		endif
		if(aimVal!=0)then
			call hattrEffect.addAimVal(whichUnit,aimVal,0)
		endif
		if(aimDuring!=0)then
			call hattrEffect.addAimDuring(whichUnit,aimDuring,0)
		endif
		if(strVal!=0)then
			call hattrEffect.addStrVal(whichUnit,strVal,0)
		endif
		if(strDuring!=0)then
			call hattrEffect.addStrDuring(whichUnit,strDuring,0)
		endif
		if(agiVal!=0)then
			call hattrEffect.addAgiVal(whichUnit,agiVal,0)
		endif
		if(agiDuring!=0)then
			call hattrEffect.addAgiDuring(whichUnit,agiDuring,0)
		endif
		if(intVal!=0)then
			call hattrEffect.addIntVal(whichUnit,intVal,0)
		endif
		if(intDuring!=0)then
			call hattrEffect.addIntDuring(whichUnit,intDuring,0)
		endif
		if(knockingVal!=0)then
			call hattrEffect.addKnockingVal(whichUnit,knockingVal,0)
		endif
		if(knockingDuring!=0)then
			call hattrEffect.addKnockingDuring(whichUnit,knockingDuring,0)
		endif
		if(violenceVal!=0)then
			call hattrEffect.addViolenceVal(whichUnit,violenceVal,0)
		endif
		if(violenceDuring!=0)then
			call hattrEffect.addViolenceDuring(whichUnit,violenceDuring,0)
		endif
		if(hemophagiaVal!=0)then
			call hattrEffect.addHemophagiaVal(whichUnit,hemophagiaVal,0)
		endif
		if(hemophagiaDuring!=0)then
			call hattrEffect.addHemophagiaDuring(whichUnit,hemophagiaDuring,0)
		endif
		if(hemophagiaSkillVal!=0)then
			call hattrEffect.addHemophagiaSkillVal(whichUnit,hemophagiaSkillVal,0)
		endif
		if(hemophagiaSkillDuring!=0)then
			call hattrEffect.addHemophagiaSkillDuring(whichUnit,hemophagiaSkillDuring,0)
		endif
		if(splitVal!=0)then
			call hattrEffect.addSplitVal(whichUnit,splitVal,0)
		endif
		if(splitDuring!=0)then
			call hattrEffect.addSplitDuring(whichUnit,splitDuring,0)
		endif
		if(luckVal!=0)then
			call hattrEffect.addLuckVal(whichUnit,luckVal,0)
		endif
		if(luckDuring!=0)then
			call hattrEffect.addLuckDuring(whichUnit,luckDuring,0)
		endif
		if(huntAmplitudeVal!=0)then
			call hattrEffect.addHuntAmplitudeVal(whichUnit,huntAmplitudeVal,0)
		endif
		if(huntAmplitudeDuring!=0)then
			call hattrEffect.addHuntAmplitudeDuring(whichUnit,huntAmplitudeDuring,0)
		endif
		if(poisonVal!=0)then
			call hattrEffect.addPoisonVal(whichUnit,poisonVal,0)
		endif
		if(poisonDuring!=0)then
			call hattrEffect.addPoisonDuring(whichUnit,poisonDuring,0)
		endif
		if(fireVal!=0)then
			call hattrEffect.addFireVal(whichUnit,fireVal,0)
		endif
		if(fireDuring!=0)then
			call hattrEffect.addFireDuring(whichUnit,fireDuring,0)
		endif
		if(dryVal!=0)then
			call hattrEffect.addDryVal(whichUnit,dryVal,0)
		endif
		if(dryDuring!=0)then
			call hattrEffect.addDryDuring(whichUnit,dryDuring,0)
		endif
		if(freezeVal!=0)then
			call hattrEffect.addFreezeVal(whichUnit,freezeVal,0)
		endif
		if(freezeDuring!=0)then
			call hattrEffect.addFreezeDuring(whichUnit,freezeDuring,0)
		endif
		if(coldVal!=0)then
			call hattrEffect.addColdVal(whichUnit,coldVal,0)
		endif
		if(coldDuring!=0)then
			call hattrEffect.addColdDuring(whichUnit,coldDuring,0)
		endif
		if(bluntVal!=0)then
			call hattrEffect.addBluntVal(whichUnit,bluntVal,0)
		endif
		if(bluntDuring!=0)then
			call hattrEffect.addBluntDuring(whichUnit,bluntDuring,0)
		endif
		if(muggleVal!=0)then
			call hattrEffect.addMuggleVal(whichUnit,muggleVal,0)
		endif
		if(muggleDuring!=0)then
			call hattrEffect.addMuggleDuring(whichUnit,muggleDuring,0)
		endif
		if(corrosionVal!=0)then
			call hattrEffect.addCorrosionVal(whichUnit,corrosionVal,0)
		endif
		if(corrosionDuring!=0)then
			call hattrEffect.addCorrosionDuring(whichUnit,corrosionDuring,0)
		endif
		if(chaosVal!=0)then
			call hattrEffect.addChaosVal(whichUnit,chaosVal,0)
		endif
		if(chaosDuring!=0)then
			call hattrEffect.addChaosDuring(whichUnit,chaosDuring,0)
		endif
		if(twineVal!=0)then
			call hattrEffect.addTwineVal(whichUnit,twineVal,0)
		endif
		if(twineDuring!=0)then
			call hattrEffect.addTwineDuring(whichUnit,twineDuring,0)
		endif
		if(blindVal!=0)then
			call hattrEffect.addBlindVal(whichUnit,blindVal,0)
		endif
		if(blindDuring!=0)then
			call hattrEffect.addBlindDuring(whichUnit,blindDuring,0)
		endif
		if(tortuaVal!=0)then
			call hattrEffect.addTortuaVal(whichUnit,tortuaVal,0)
		endif
		if(tortuaDuring!=0)then
			call hattrEffect.addTortuaDuring(whichUnit,tortuaDuring,0)
		endif
		if(weakVal!=0)then
			call hattrEffect.addWeakVal(whichUnit,weakVal,0)
		endif
		if(weakDuring!=0)then
			call hattrEffect.addWeakDuring(whichUnit,weakDuring,0)
		endif
		if(astrictVal!=0)then
			call hattrEffect.addAstrictVal(whichUnit,astrictVal,0)
		endif
		if(astrictDuring!=0)then
			call hattrEffect.addAstrictDuring(whichUnit,astrictDuring,0)
		endif
		if(foolishVal!=0)then
			call hattrEffect.addFoolishVal(whichUnit,foolishVal,0)
		endif
		if(foolishDuring!=0)then
			call hattrEffect.addFoolishDuring(whichUnit,foolishDuring,0)
		endif
		if(dullVal!=0)then
			call hattrEffect.addDullVal(whichUnit,dullVal,0)
		endif
		if(dullDuring!=0)then
			call hattrEffect.addDullDuring(whichUnit,dullDuring,0)
		endif
		if(dirtVal!=0)then
			call hattrEffect.addDirtVal(whichUnit,dirtVal,0)
		endif
		if(dirtDuring!=0)then
			call hattrEffect.addDirtDuring(whichUnit,dirtDuring,0)
		endif
		if(swimOdds!=0)then
			call hattrEffect.addSwimOdds(whichUnit,swimOdds,0)
		endif
		if(swimDuring!=0)then
			call hattrEffect.addSwimDuring(whichUnit,swimDuring,0)
		endif
		if(heavyOdds!=0)then
			call hattrEffect.addHeavyOdds(whichUnit,heavyOdds,0)
		endif
		if(heavyVal!=0)then
			call hattrEffect.addHeavyVal(whichUnit,heavyVal,0)
		endif
		if(breakOdds!=0)then
			call hattrEffect.addBreakOdds(whichUnit,breakOdds,0)
		endif
		if(breakDuring!=0)then
			call hattrEffect.addBreakDuring(whichUnit,breakDuring,0)
		endif
		if(unluckVal!=0)then
			call hattrEffect.addUnluckVal(whichUnit,unluckVal,0)
		endif
		if(unluckDuring!=0)then
			call hattrEffect.addUnluckDuring(whichUnit,unluckDuring,0)
		endif
		if(silentOdds!=0)then
			call hattrEffect.addSilentOdds(whichUnit,silentOdds,0)
		endif
		if(silentDuring!=0)then
			call hattrEffect.addSilentDuring(whichUnit,silentDuring,0)
		endif
		if(unarmOdds!=0)then
			call hattrEffect.addUnarmOdds(whichUnit,unarmOdds,0)
		endif
		if(unarmDuring!=0)then
			call hattrEffect.addUnarmDuring(whichUnit,unarmDuring,0)
		endif
		if(fetterOdds!=0)then
			call hattrEffect.addFetterOdds(whichUnit,fetterOdds,0)
		endif
		if(fetterDuring!=0)then
			call hattrEffect.addFetterDuring(whichUnit,fetterDuring,0)
		endif
		if(bombVal!=0)then
			call hattrEffect.addBombVal(whichUnit,bombVal,0)
		endif
		if(bombModel!="")then
			call hattrEffect.setBombModel(whichUnit,bombModel)
		endif
		if(lightningChainVal!=0)then
			call hattrEffect.addLightningChainVal(whichUnit,lightningChainVal,0)
		endif
		if(lightningChainOdds!=0)then
			call hattrEffect.addLightningChainOdds(whichUnit,lightningChainOdds,0)
		endif
		if(lightningChainQty!=0)then
			call hattrEffect.addLightningChainQty(whichUnit,lightningChainQty,0)
		endif
		if(lightningChainReduce!=0)then
			call hattrEffect.addLightningChainReduce(whichUnit,lightningChainReduce,0)
		endif
		if(lightningChainModel!="")then
			call hattrEffect.setLightningChainModel(whichUnit,lightningChainModel)
		endif
		if(crackFlyVal!=0)then
			call hattrEffect.addCrackFlyVal(whichUnit,crackFlyVal,0)
		endif
		if(crackFlyOdds!=0)then
			call hattrEffect.addCrackFlyOdds(whichUnit,crackFlyOdds,0)
		endif
		if(crackFlyDistance!=0)then
			call hattrEffect.addCrackFlyDistance(whichUnit,crackFlyDistance,0)
		endif
		if(crackFlyHigh!=0)then
			call hattrEffect.addCrackFlyHigh(whichUnit,crackFlyHigh,0)
		endif
	endmethod

	//减少物品属性
	public static method subAttr takes integer item_id,real charges,unit whichUnit returns nothing
		local real goldRatio = LoadReal(hash_item, item_id, hk_goldRatio)*charges
		local real lumberRatio = LoadReal(hash_item, item_id, hk_lumberRatio)*charges
		local real expRatio = LoadReal(hash_item, item_id, hk_expRatio)*charges
		local real life = LoadReal(hash_item, item_id, hk_life)*charges
		local real mana = LoadReal(hash_item, item_id, hk_mana)*charges
		local real move = LoadReal(hash_item, item_id, hk_move)*charges
		local real defend  = LoadReal(hash_item, item_id, hk_defend )*charges
		local real attackSpeed = LoadReal(hash_item, item_id, hk_attackSpeed)*charges
		local real attackPhysical = LoadReal(hash_item, item_id, hk_attackPhysical)*charges
		local real attackMagic = LoadReal(hash_item, item_id, hk_attackMagic)*charges
		local real str = LoadReal(hash_item, item_id, hk_str)*charges
		local real agi = LoadReal(hash_item, item_id, hk_agi)*charges
		local real int = LoadReal(hash_item, item_id, hk_int)*charges
		local real strWhite = LoadReal(hash_item, item_id, hk_strWhite)*charges
		local real agiWhite = LoadReal(hash_item, item_id, hk_agiWhite)*charges
		local real intWhite = LoadReal(hash_item, item_id, hk_intWhite)*charges
		local real lifeBack = LoadReal(hash_item, item_id, hk_lifeBack)*charges
		local real lifeSource = LoadReal(hash_item, item_id, hk_lifeSource)*charges
		local real lifeSourceCurrent = LoadReal(hash_item, item_id, hk_lifeSourceCurrent)*charges
		local real manaBack = LoadReal(hash_item, item_id, hk_manaBack)*charges
		local real manaSource = LoadReal(hash_item, item_id, hk_manaSource)*charges
		local real manaSourceCurrent = LoadReal(hash_item, item_id, hk_manaSourceCurrent)*charges
		local real resistance = LoadReal(hash_item, item_id, hk_resistance)*charges
		local real toughness = LoadReal(hash_item, item_id, hk_toughness)*charges
		local real avoid = LoadReal(hash_item, item_id, hk_avoid)*charges
		local real aim = LoadReal(hash_item, item_id, hk_aim)*charges
		local real knocking = LoadReal(hash_item, item_id, hk_knocking)*charges
		local real violence = LoadReal(hash_item, item_id, hk_violence)*charges
		local real mortalOppose = LoadReal(hash_item, item_id, hk_mortalOppose)*charges
		local real punish = LoadReal(hash_item, item_id, hk_punish)*charges
		local real punishCurrent = LoadReal(hash_item, item_id, hk_punishCurrent)*charges
		local real punishOppose = LoadReal(hash_item, item_id, hk_punishOppose)*charges
		local real meditative = LoadReal(hash_item, item_id, hk_meditative)*charges
		local real help = LoadReal(hash_item, item_id, hk_help)*charges
		local real hemophagia = LoadReal(hash_item, item_id, hk_hemophagia)*charges
		local real hemophagiaSkill = LoadReal(hash_item, item_id, hk_hemophagiaSkill)*charges
		local real split = LoadReal(hash_item, item_id, hk_split)*charges
		local real splitRange = LoadReal(hash_item, item_id, hk_splitRange)*charges
		local real swimOppose = LoadReal(hash_item, item_id, hk_swimOppose)*charges
		local real luck = LoadReal(hash_item, item_id, hk_luck)*charges
		local real invincible = LoadReal(hash_item, item_id, hk_invincible)*charges
		local real weight = LoadReal(hash_item, item_id, hk_weight)*charges
		local real weightCurrent = LoadReal(hash_item, item_id, hk_weightCurrent)*charges
		local real huntAmplitude = LoadReal(hash_item, item_id, hk_huntAmplitude)*charges
		local real huntRebound = LoadReal(hash_item, item_id, hk_huntRebound)*charges
		local real cure = LoadReal(hash_item, item_id, hk_cure)*charges
		local real fire = LoadReal(hash_item, item_id, hk_fire)*charges
		local real soil = LoadReal(hash_item, item_id, hk_soil)*charges
		local real water = LoadReal(hash_item, item_id, hk_water)*charges
		local real ice = LoadReal(hash_item, item_id, hk_ice)*charges
		local real wind = LoadReal(hash_item, item_id, hk_wind)*charges
		local real light = LoadReal(hash_item, item_id, hk_light)*charges
		local real dark = LoadReal(hash_item, item_id, hk_dark)*charges
		local real wood = LoadReal(hash_item, item_id, hk_wood)*charges
		local real thunder = LoadReal(hash_item, item_id, hk_thunder)*charges
		local real poison = LoadReal(hash_item, item_id, hk_poison)*charges
		local real fireOppose = LoadReal(hash_item, item_id, hk_fireOppose)*charges
		local real soilOppose = LoadReal(hash_item, item_id, hk_soilOppose)*charges
		local real waterOppose = LoadReal(hash_item, item_id, hk_waterOppose)*charges
		local real iceOppose = LoadReal(hash_item, item_id, hk_iceOppose)*charges
		local real windOppose = LoadReal(hash_item, item_id, hk_windOppose)*charges
		local real lightOppose = LoadReal(hash_item, item_id, hk_lightOppose)*charges
		local real darkOppose = LoadReal(hash_item, item_id, hk_darkOppose)*charges
		local real woodOppose = LoadReal(hash_item, item_id, hk_woodOppose)*charges
		local real thunderOppose = LoadReal(hash_item, item_id, hk_thunderOppose)*charges
		local real poisonOppose = LoadReal(hash_item, item_id, hk_poisonOppose)*charges
		local real lifeBackVal = LoadReal(hash_item, item_id, hk_lifeBackVal)*charges
		local real lifeBackDuring = LoadReal(hash_item, item_id, hk_lifeBackDuring)*charges
		local real manaBackVal = LoadReal(hash_item, item_id, hk_manaBackVal)*charges
		local real manaBackDuring = LoadReal(hash_item, item_id, hk_manaBackDuring)*charges
		local real attackSpeedVal = LoadReal(hash_item, item_id, hk_attackSpeedVal)*charges
		local real attackSpeedDuring = LoadReal(hash_item, item_id, hk_attackSpeedDuring)*charges
		local real attackPhysicalVal = LoadReal(hash_item, item_id, hk_attackPhysicalVal)*charges
		local real attackPhysicalDuring = LoadReal(hash_item, item_id, hk_attackPhysicalDuring)*charges
		local real attackMagicVal = LoadReal(hash_item, item_id, hk_attackMagicVal)*charges
		local real attackMagicDuring = LoadReal(hash_item, item_id, hk_attackMagicDuring)*charges
		local real moveVal = LoadReal(hash_item, item_id, hk_moveVal)*charges
		local real moveDuring = LoadReal(hash_item, item_id, hk_moveDuring)*charges
		local real aimVal = LoadReal(hash_item, item_id, hk_aimVal)*charges
		local real aimDuring = LoadReal(hash_item, item_id, hk_aimDuring)*charges
		local real strVal = LoadReal(hash_item, item_id, hk_strVal)*charges
		local real strDuring = LoadReal(hash_item, item_id, hk_strDuring)*charges
		local real agiVal = LoadReal(hash_item, item_id, hk_agiVal)*charges
		local real agiDuring = LoadReal(hash_item, item_id, hk_agiDuring)*charges
		local real intVal = LoadReal(hash_item, item_id, hk_intVal)*charges
		local real intDuring = LoadReal(hash_item, item_id, hk_intDuring)*charges
		local real knockingVal = LoadReal(hash_item, item_id, hk_knockingVal)*charges
		local real knockingDuring = LoadReal(hash_item, item_id, hk_knockingDuring)*charges
		local real violenceVal = LoadReal(hash_item, item_id, hk_violenceVal)*charges
		local real violenceDuring = LoadReal(hash_item, item_id, hk_violenceDuring)*charges
		local real hemophagiaVal = LoadReal(hash_item, item_id, hk_hemophagiaVal)*charges
		local real hemophagiaDuring = LoadReal(hash_item, item_id, hk_hemophagiaDuring)*charges
		local real hemophagiaSkillVal = LoadReal(hash_item, item_id, hk_hemophagiaSkillVal)*charges
		local real hemophagiaSkillDuring = LoadReal(hash_item, item_id, hk_hemophagiaSkillDuring)*charges
		local real splitVal = LoadReal(hash_item, item_id, hk_splitVal)*charges
		local real splitDuring = LoadReal(hash_item, item_id, hk_splitDuring)*charges
		local real luckVal = LoadReal(hash_item, item_id, hk_luckVal)*charges
		local real luckDuring = LoadReal(hash_item, item_id, hk_luckDuring)*charges
		local real huntAmplitudeVal = LoadReal(hash_item, item_id, hk_huntAmplitudeVal)*charges
		local real huntAmplitudeDuring = LoadReal(hash_item, item_id, hk_huntAmplitudeDuring)*charges
		local real poisonVal = LoadReal(hash_item, item_id, hk_poisonVal)*charges
		local real poisonDuring = LoadReal(hash_item, item_id, hk_poisonDuring)*charges
		local real fireVal = LoadReal(hash_item, item_id, hk_fireVal)*charges
		local real fireDuring = LoadReal(hash_item, item_id, hk_fireDuring)*charges
		local real dryVal = LoadReal(hash_item, item_id, hk_dryVal)*charges
		local real dryDuring = LoadReal(hash_item, item_id, hk_dryDuring)*charges
		local real freezeVal = LoadReal(hash_item, item_id, hk_freezeVal)*charges
		local real freezeDuring = LoadReal(hash_item, item_id, hk_freezeDuring)*charges
		local real coldVal = LoadReal(hash_item, item_id, hk_coldVal)*charges
		local real coldDuring = LoadReal(hash_item, item_id, hk_coldDuring)*charges
		local real bluntVal = LoadReal(hash_item, item_id, hk_bluntVal)*charges
		local real bluntDuring = LoadReal(hash_item, item_id, hk_bluntDuring)*charges
		local real muggleVal = LoadReal(hash_item, item_id, hk_muggleVal)*charges
		local real muggleDuring = LoadReal(hash_item, item_id, hk_muggleDuring)*charges
		local real corrosionVal = LoadReal(hash_item, item_id, hk_corrosionVal)*charges
		local real corrosionDuring = LoadReal(hash_item, item_id, hk_corrosionDuring)*charges
		local real chaosVal = LoadReal(hash_item, item_id, hk_chaosVal)*charges
		local real chaosDuring = LoadReal(hash_item, item_id, hk_chaosDuring)*charges
		local real twineVal = LoadReal(hash_item, item_id, hk_twineVal)*charges
		local real twineDuring = LoadReal(hash_item, item_id, hk_twineDuring)*charges
		local real blindVal = LoadReal(hash_item, item_id, hk_blindVal)*charges
		local real blindDuring = LoadReal(hash_item, item_id, hk_blindDuring)*charges
		local real tortuaVal = LoadReal(hash_item, item_id, hk_tortuaVal)*charges
		local real tortuaDuring = LoadReal(hash_item, item_id, hk_tortuaDuring)*charges
		local real weakVal = LoadReal(hash_item, item_id, hk_weakVal)*charges
		local real weakDuring = LoadReal(hash_item, item_id, hk_weakDuring)*charges
		local real astrictVal = LoadReal(hash_item, item_id, hk_astrictVal)*charges
		local real astrictDuring = LoadReal(hash_item, item_id, hk_astrictDuring)*charges
		local real foolishVal = LoadReal(hash_item, item_id, hk_foolishVal)*charges
		local real foolishDuring = LoadReal(hash_item, item_id, hk_foolishDuring)*charges
		local real dullVal = LoadReal(hash_item, item_id, hk_dullVal)*charges
		local real dullDuring = LoadReal(hash_item, item_id, hk_dullDuring)*charges
		local real dirtVal = LoadReal(hash_item, item_id, hk_dirtVal)*charges
		local real dirtDuring = LoadReal(hash_item, item_id, hk_dirtDuring)*charges
		local real swimOdds = LoadReal(hash_item, item_id, hk_swimOdds)*charges
		local real swimDuring = LoadReal(hash_item, item_id, hk_swimDuring)*charges
		local real heavyOdds = LoadReal(hash_item, item_id, hk_heavyOdds)*charges
		local real heavyVal = LoadReal(hash_item, item_id, hk_heavyVal)*charges
		local real breakOdds = LoadReal(hash_item, item_id, hk_breakOdds)*charges
		local real breakDuring = LoadReal(hash_item, item_id, hk_breakDuring)*charges
		local real unluckVal = LoadReal(hash_item, item_id, hk_unluckVal)*charges
		local real unluckDuring = LoadReal(hash_item, item_id, hk_unluckDuring)*charges
		local real silentOdds = LoadReal(hash_item, item_id, hk_silentOdds)*charges
		local real silentDuring = LoadReal(hash_item, item_id, hk_silentDuring)*charges
		local real unarmOdds = LoadReal(hash_item, item_id, hk_unarmOdds)*charges
		local real unarmDuring = LoadReal(hash_item, item_id, hk_unarmDuring)*charges
		local real fetterOdds = LoadReal(hash_item, item_id, hk_fetterOdds)*charges
		local real fetterDuring = LoadReal(hash_item, item_id, hk_fetterDuring)*charges
		local real bombVal = LoadReal(hash_item, item_id, hk_bombVal)*charges
		local string bombModel = LoadStr(hash_item, item_id, hk_bombModel)
		local real lightningChainVal = LoadReal(hash_item, item_id, hk_lightningChainVal)*charges
		local real lightningChainOdds = LoadReal(hash_item, item_id, hk_lightningChainOdds)*charges
		local real lightningChainQty = LoadReal(hash_item, item_id, hk_lightningChainQty)*charges
		local real lightningChainReduce = LoadReal(hash_item, item_id, hk_lightningChainReduce)*charges
		local string lightningChainModel = LoadStr(hash_item, item_id, hk_lightningChainModel)
		local real crackFlyVal = LoadReal(hash_item, item_id, hk_crackFlyVal)*charges
		local real crackFlyOdds = LoadReal(hash_item, item_id, hk_crackFlyOdds)*charges
		local real crackFlyDistance = LoadReal(hash_item, item_id, hk_crackFlyDistance)*charges
		local real crackFlyHigh = LoadReal(hash_item, item_id, hk_crackFlyHigh)*charges
		if(goldRatio!=0)then
			call hplayer.subGoldRatio(GetOwningPlayer(whichUnit),goldRatio,0)
		endif
		if(lumberRatio!=0)then
			call hplayer.subLumberRatio(GetOwningPlayer(whichUnit),lumberRatio,0)
		endif
		if(expRatio!=0)then
			call hplayer.subExpRatio(GetOwningPlayer(whichUnit),expRatio,0)
		endif
		if(life!=0)then
			call hattr.subLife(whichUnit,life,0)
		endif
		if(mana!=0)then
			call hattr.subMana(whichUnit,mana,0)
		endif
		if(move!=0)then
			call hattr.subMove(whichUnit,move,0)
		endif
		if(defend !=0)then
			call hattr.subDefend (whichUnit,defend ,0)
		endif
		if(attackSpeed!=0)then
			call hattr.subAttackSpeed(whichUnit,attackSpeed,0)
		endif
		if(attackPhysical!=0)then
			call hattr.subAttackPhysical(whichUnit,attackPhysical,0)
		endif
		if(attackMagic!=0)then
			call hattr.subAttackMagic(whichUnit,attackMagic,0)
		endif
		if(str!=0)then
			call hattr.subStr(whichUnit,str,0)
		endif
		if(agi!=0)then
			call hattr.subAgi(whichUnit,agi,0)
		endif
		if(int!=0)then
			call hattr.subInt(whichUnit,int,0)
		endif
		if(strWhite!=0)then
			call hattr.subStrWhite(whichUnit,strWhite,0)
		endif
		if(agiWhite!=0)then
			call hattr.subAgiWhite(whichUnit,agiWhite,0)
		endif
		if(intWhite!=0)then
			call hattr.subIntWhite(whichUnit,intWhite,0)
		endif
		if(lifeBack!=0)then
			call hattr.subLifeBack(whichUnit,lifeBack,0)
		endif
		if(lifeSource!=0)then
			call hattr.subLifeSource(whichUnit,lifeSource,0)
		endif
		if(lifeSourceCurrent!=0)then
			call hattr.subLifeSourceCurrent(whichUnit,lifeSourceCurrent,0)
		endif
		if(manaBack!=0)then
			call hattr.subManaBack(whichUnit,manaBack,0)
		endif
		if(manaSource!=0)then
			call hattr.subManaSource(whichUnit,manaSource,0)
		endif
		if(manaSourceCurrent!=0)then
			call hattr.subManaSourceCurrent(whichUnit,manaSourceCurrent,0)
		endif
		if(resistance!=0)then
			call hattr.subResistance(whichUnit,resistance,0)
		endif
		if(toughness!=0)then
			call hattr.subToughness(whichUnit,toughness,0)
		endif
		if(avoid!=0)then
			call hattr.subAvoid(whichUnit,avoid,0)
		endif
		if(aim!=0)then
			call hattr.subAim(whichUnit,aim,0)
		endif
		if(knocking!=0)then
			call hattr.subKnocking(whichUnit,knocking,0)
		endif
		if(violence!=0)then
			call hattr.subViolence(whichUnit,violence,0)
		endif
		if(mortalOppose!=0)then
			call hattr.subMortalOppose(whichUnit,mortalOppose,0)
		endif
		if(punish!=0)then
			call hattr.subPunish(whichUnit,punish,0)
		endif
		if(punishCurrent!=0)then
			call hattr.subPunishCurrent(whichUnit,punishCurrent,0)
		endif
		if(punishOppose!=0)then
			call hattr.subPunishOppose(whichUnit,punishOppose,0)
		endif
		if(meditative!=0)then
			call hattr.subMeditative(whichUnit,meditative,0)
		endif
		if(help!=0)then
			call hattr.subHelp(whichUnit,help,0)
		endif
		if(hemophagia!=0)then
			call hattr.subHemophagia(whichUnit,hemophagia,0)
		endif
		if(hemophagiaSkill!=0)then
			call hattr.subHemophagiaSkill(whichUnit,hemophagiaSkill,0)
		endif
		if(split!=0)then
			call hattr.subSplit(whichUnit,split,0)
		endif
		if(splitRange!=0)then
			call hattr.subSplitRange(whichUnit,splitRange,0)
		endif
		if(swimOppose!=0)then
			call hattr.subSwimOppose(whichUnit,swimOppose,0)
		endif
		if(luck!=0)then
			call hattr.subLuck(whichUnit,luck,0)
		endif
		if(invincible!=0)then
			call hattr.subInvincible(whichUnit,invincible,0)
		endif
		if(weight!=0)then
			call hattr.subWeight(whichUnit,weight,0)
		endif
		if(weightCurrent!=0)then
			call hattr.subWeightCurrent(whichUnit,weightCurrent,0)
		endif
		if(huntAmplitude!=0)then
			call hattr.subHuntAmplitude(whichUnit,huntAmplitude,0)
		endif
		if(huntRebound!=0)then
			call hattr.subHuntRebound(whichUnit,huntRebound,0)
		endif
		if(cure!=0)then
			call hattr.subCure(whichUnit,cure,0)
		endif
		if(fire!=0)then
			call hattrNatural.subFire(whichUnit,fire,0)
		endif
		if(soil!=0)then
			call hattrNatural.subSoil(whichUnit,soil,0)
		endif
		if(water!=0)then
			call hattrNatural.subWater(whichUnit,water,0)
		endif
		if(ice!=0)then
			call hattrNatural.subIce(whichUnit,ice,0)
		endif
		if(wind!=0)then
			call hattrNatural.subWind(whichUnit,wind,0)
		endif
		if(light!=0)then
			call hattrNatural.subLight(whichUnit,light,0)
		endif
		if(dark!=0)then
			call hattrNatural.subDark(whichUnit,dark,0)
		endif
		if(wood!=0)then
			call hattrNatural.subWood(whichUnit,wood,0)
		endif
		if(thunder!=0)then
			call hattrNatural.subThunder(whichUnit,thunder,0)
		endif
		if(poison!=0)then
			call hattrNatural.subPoison(whichUnit,poison,0)
		endif
		if(fireOppose!=0)then
			call hattrNatural.subFireOppose(whichUnit,fireOppose,0)
		endif
		if(soilOppose!=0)then
			call hattrNatural.subSoilOppose(whichUnit,soilOppose,0)
		endif
		if(waterOppose!=0)then
			call hattrNatural.subWaterOppose(whichUnit,waterOppose,0)
		endif
		if(iceOppose!=0)then
			call hattrNatural.subIceOppose(whichUnit,iceOppose,0)
		endif
		if(windOppose!=0)then
			call hattrNatural.subWindOppose(whichUnit,windOppose,0)
		endif
		if(lightOppose!=0)then
			call hattrNatural.subLightOppose(whichUnit,lightOppose,0)
		endif
		if(darkOppose!=0)then
			call hattrNatural.subDarkOppose(whichUnit,darkOppose,0)
		endif
		if(woodOppose!=0)then
			call hattrNatural.subWoodOppose(whichUnit,woodOppose,0)
		endif
		if(thunderOppose!=0)then
			call hattrNatural.subThunderOppose(whichUnit,thunderOppose,0)
		endif
		if(poisonOppose!=0)then
			call hattrNatural.subPoisonOppose(whichUnit,poisonOppose,0)
		endif
		if(lifeBackVal!=0)then
			call hattrEffect.subLifeBackVal(whichUnit,lifeBackVal,0)
		endif
		if(lifeBackDuring!=0)then
			call hattrEffect.subLifeBackDuring(whichUnit,lifeBackDuring,0)
		endif
		if(manaBackVal!=0)then
			call hattrEffect.subManaBackVal(whichUnit,manaBackVal,0)
		endif
		if(manaBackDuring!=0)then
			call hattrEffect.subManaBackDuring(whichUnit,manaBackDuring,0)
		endif
		if(attackSpeedVal!=0)then
			call hattrEffect.subAttackSpeedVal(whichUnit,attackSpeedVal,0)
		endif
		if(attackSpeedDuring!=0)then
			call hattrEffect.subAttackSpeedDuring(whichUnit,attackSpeedDuring,0)
		endif
		if(attackPhysicalVal!=0)then
			call hattrEffect.subAttackPhysicalVal(whichUnit,attackPhysicalVal,0)
		endif
		if(attackPhysicalDuring!=0)then
			call hattrEffect.subAttackPhysicalDuring(whichUnit,attackPhysicalDuring,0)
		endif
		if(attackMagicVal!=0)then
			call hattrEffect.subAttackMagicVal(whichUnit,attackMagicVal,0)
		endif
		if(attackMagicDuring!=0)then
			call hattrEffect.subAttackMagicDuring(whichUnit,attackMagicDuring,0)
		endif
		if(moveVal!=0)then
			call hattrEffect.subMoveVal(whichUnit,moveVal,0)
		endif
		if(moveDuring!=0)then
			call hattrEffect.subMoveDuring(whichUnit,moveDuring,0)
		endif
		if(aimVal!=0)then
			call hattrEffect.subAimVal(whichUnit,aimVal,0)
		endif
		if(aimDuring!=0)then
			call hattrEffect.subAimDuring(whichUnit,aimDuring,0)
		endif
		if(strVal!=0)then
			call hattrEffect.subStrVal(whichUnit,strVal,0)
		endif
		if(strDuring!=0)then
			call hattrEffect.subStrDuring(whichUnit,strDuring,0)
		endif
		if(agiVal!=0)then
			call hattrEffect.subAgiVal(whichUnit,agiVal,0)
		endif
		if(agiDuring!=0)then
			call hattrEffect.subAgiDuring(whichUnit,agiDuring,0)
		endif
		if(intVal!=0)then
			call hattrEffect.subIntVal(whichUnit,intVal,0)
		endif
		if(intDuring!=0)then
			call hattrEffect.subIntDuring(whichUnit,intDuring,0)
		endif
		if(knockingVal!=0)then
			call hattrEffect.subKnockingVal(whichUnit,knockingVal,0)
		endif
		if(knockingDuring!=0)then
			call hattrEffect.subKnockingDuring(whichUnit,knockingDuring,0)
		endif
		if(violenceVal!=0)then
			call hattrEffect.subViolenceVal(whichUnit,violenceVal,0)
		endif
		if(violenceDuring!=0)then
			call hattrEffect.subViolenceDuring(whichUnit,violenceDuring,0)
		endif
		if(hemophagiaVal!=0)then
			call hattrEffect.subHemophagiaVal(whichUnit,hemophagiaVal,0)
		endif
		if(hemophagiaDuring!=0)then
			call hattrEffect.subHemophagiaDuring(whichUnit,hemophagiaDuring,0)
		endif
		if(hemophagiaSkillVal!=0)then
			call hattrEffect.subHemophagiaSkillVal(whichUnit,hemophagiaSkillVal,0)
		endif
		if(hemophagiaSkillDuring!=0)then
			call hattrEffect.subHemophagiaSkillDuring(whichUnit,hemophagiaSkillDuring,0)
		endif
		if(splitVal!=0)then
			call hattrEffect.subSplitVal(whichUnit,splitVal,0)
		endif
		if(splitDuring!=0)then
			call hattrEffect.subSplitDuring(whichUnit,splitDuring,0)
		endif
		if(luckVal!=0)then
			call hattrEffect.subLuckVal(whichUnit,luckVal,0)
		endif
		if(luckDuring!=0)then
			call hattrEffect.subLuckDuring(whichUnit,luckDuring,0)
		endif
		if(huntAmplitudeVal!=0)then
			call hattrEffect.subHuntAmplitudeVal(whichUnit,huntAmplitudeVal,0)
		endif
		if(huntAmplitudeDuring!=0)then
			call hattrEffect.subHuntAmplitudeDuring(whichUnit,huntAmplitudeDuring,0)
		endif
		if(poisonVal!=0)then
			call hattrEffect.subPoisonVal(whichUnit,poisonVal,0)
		endif
		if(poisonDuring!=0)then
			call hattrEffect.subPoisonDuring(whichUnit,poisonDuring,0)
		endif
		if(fireVal!=0)then
			call hattrEffect.subFireVal(whichUnit,fireVal,0)
		endif
		if(fireDuring!=0)then
			call hattrEffect.subFireDuring(whichUnit,fireDuring,0)
		endif
		if(dryVal!=0)then
			call hattrEffect.subDryVal(whichUnit,dryVal,0)
		endif
		if(dryDuring!=0)then
			call hattrEffect.subDryDuring(whichUnit,dryDuring,0)
		endif
		if(freezeVal!=0)then
			call hattrEffect.subFreezeVal(whichUnit,freezeVal,0)
		endif
		if(freezeDuring!=0)then
			call hattrEffect.subFreezeDuring(whichUnit,freezeDuring,0)
		endif
		if(coldVal!=0)then
			call hattrEffect.subColdVal(whichUnit,coldVal,0)
		endif
		if(coldDuring!=0)then
			call hattrEffect.subColdDuring(whichUnit,coldDuring,0)
		endif
		if(bluntVal!=0)then
			call hattrEffect.subBluntVal(whichUnit,bluntVal,0)
		endif
		if(bluntDuring!=0)then
			call hattrEffect.subBluntDuring(whichUnit,bluntDuring,0)
		endif
		if(muggleVal!=0)then
			call hattrEffect.subMuggleVal(whichUnit,muggleVal,0)
		endif
		if(muggleDuring!=0)then
			call hattrEffect.subMuggleDuring(whichUnit,muggleDuring,0)
		endif
		if(corrosionVal!=0)then
			call hattrEffect.subCorrosionVal(whichUnit,corrosionVal,0)
		endif
		if(corrosionDuring!=0)then
			call hattrEffect.subCorrosionDuring(whichUnit,corrosionDuring,0)
		endif
		if(chaosVal!=0)then
			call hattrEffect.subChaosVal(whichUnit,chaosVal,0)
		endif
		if(chaosDuring!=0)then
			call hattrEffect.subChaosDuring(whichUnit,chaosDuring,0)
		endif
		if(twineVal!=0)then
			call hattrEffect.subTwineVal(whichUnit,twineVal,0)
		endif
		if(twineDuring!=0)then
			call hattrEffect.subTwineDuring(whichUnit,twineDuring,0)
		endif
		if(blindVal!=0)then
			call hattrEffect.subBlindVal(whichUnit,blindVal,0)
		endif
		if(blindDuring!=0)then
			call hattrEffect.subBlindDuring(whichUnit,blindDuring,0)
		endif
		if(tortuaVal!=0)then
			call hattrEffect.subTortuaVal(whichUnit,tortuaVal,0)
		endif
		if(tortuaDuring!=0)then
			call hattrEffect.subTortuaDuring(whichUnit,tortuaDuring,0)
		endif
		if(weakVal!=0)then
			call hattrEffect.subWeakVal(whichUnit,weakVal,0)
		endif
		if(weakDuring!=0)then
			call hattrEffect.subWeakDuring(whichUnit,weakDuring,0)
		endif
		if(astrictVal!=0)then
			call hattrEffect.subAstrictVal(whichUnit,astrictVal,0)
		endif
		if(astrictDuring!=0)then
			call hattrEffect.subAstrictDuring(whichUnit,astrictDuring,0)
		endif
		if(foolishVal!=0)then
			call hattrEffect.subFoolishVal(whichUnit,foolishVal,0)
		endif
		if(foolishDuring!=0)then
			call hattrEffect.subFoolishDuring(whichUnit,foolishDuring,0)
		endif
		if(dullVal!=0)then
			call hattrEffect.subDullVal(whichUnit,dullVal,0)
		endif
		if(dullDuring!=0)then
			call hattrEffect.subDullDuring(whichUnit,dullDuring,0)
		endif
		if(dirtVal!=0)then
			call hattrEffect.subDirtVal(whichUnit,dirtVal,0)
		endif
		if(dirtDuring!=0)then
			call hattrEffect.subDirtDuring(whichUnit,dirtDuring,0)
		endif
		if(swimOdds!=0)then
			call hattrEffect.subSwimOdds(whichUnit,swimOdds,0)
		endif
		if(swimDuring!=0)then
			call hattrEffect.subSwimDuring(whichUnit,swimDuring,0)
		endif
		if(heavyOdds!=0)then
			call hattrEffect.subHeavyOdds(whichUnit,heavyOdds,0)
		endif
		if(heavyVal!=0)then
			call hattrEffect.subHeavyVal(whichUnit,heavyVal,0)
		endif
		if(breakOdds!=0)then
			call hattrEffect.subBreakOdds(whichUnit,breakOdds,0)
		endif
		if(breakDuring!=0)then
			call hattrEffect.subBreakDuring(whichUnit,breakDuring,0)
		endif
		if(unluckVal!=0)then
			call hattrEffect.subUnluckVal(whichUnit,unluckVal,0)
		endif
		if(unluckDuring!=0)then
			call hattrEffect.subUnluckDuring(whichUnit,unluckDuring,0)
		endif
		if(silentOdds!=0)then
			call hattrEffect.subSilentOdds(whichUnit,silentOdds,0)
		endif
		if(silentDuring!=0)then
			call hattrEffect.subSilentDuring(whichUnit,silentDuring,0)
		endif
		if(unarmOdds!=0)then
			call hattrEffect.subUnarmOdds(whichUnit,unarmOdds,0)
		endif
		if(unarmDuring!=0)then
			call hattrEffect.subUnarmDuring(whichUnit,unarmDuring,0)
		endif
		if(fetterOdds!=0)then
			call hattrEffect.subFetterOdds(whichUnit,fetterOdds,0)
		endif
		if(fetterDuring!=0)then
			call hattrEffect.subFetterDuring(whichUnit,fetterDuring,0)
		endif
		if(bombVal!=0)then
			call hattrEffect.subBombVal(whichUnit,bombVal,0)
		endif
		if(lightningChainVal!=0)then
			call hattrEffect.subLightningChainVal(whichUnit,lightningChainVal,0)
		endif
		if(lightningChainOdds!=0)then
			call hattrEffect.subLightningChainOdds(whichUnit,lightningChainOdds,0)
		endif
		if(lightningChainQty!=0)then
			call hattrEffect.subLightningChainQty(whichUnit,lightningChainQty,0)
		endif
		if(lightningChainReduce!=0)then
			call hattrEffect.subLightningChainReduce(whichUnit,lightningChainReduce,0)
		endif
		if(crackFlyVal!=0)then
			call hattrEffect.subCrackFlyVal(whichUnit,crackFlyVal,0)
		endif
		if(crackFlyOdds!=0)then
			call hattrEffect.subCrackFlyOdds(whichUnit,crackFlyOdds,0)
		endif
		if(crackFlyDistance!=0)then
			call hattrEffect.subCrackFlyDistance(whichUnit,crackFlyDistance,0)
		endif
		if(crackFlyHigh!=0)then
			call hattrEffect.subCrackFlyHigh(whichUnit,crackFlyHigh,0)
		endif
	endmethod

	//获取物品ID名字
	public static method getNameById takes integer itid returns string
		return GetObjectName(itid)
	endmethod

	//获取物品图标（需要在format时设定路径）
	public static method getIcon takes integer itid returns string
		return LoadStr(hash_item, itid, hk_item_icon)
	endmethod

	//获取物品ID是否自动使用
	public static method getIsPowerup takes integer itid returns boolean
		return LoadBoolean(hash_item, itid, hk_item_is_powerup)
	endmethod

	//获取物品ID等级
	public static method getLevel takes integer itid returns integer
		return LoadInteger(hash_item, itid, hk_item_level)
	endmethod

	//获取物品ID黄金
	public static method getGold takes integer itid returns integer
		return LoadInteger(hash_item, itid, hk_item_gold)
	endmethod

	//获取物品ID木头
	public static method getLumber takes integer itid returns integer
		return LoadInteger(hash_item, itid, hk_item_lumber)
	endmethod

	//获取物品ID叠加数
	public static method getOverlay takes integer itid returns integer
		return LoadInteger(hash_item, itid, hk_item_overlay)
	endmethod

	//获取物品ID重量
	public static method getWeight takes integer itid returns real
		return LoadReal(hash_item, itid, hk_item_weight)
	endmethod

	//获取物品ID战力
	public static method getCombatEffectiveness takes integer itid returns integer
		return LoadInteger(hash_item, itid, hk_item_combat_effectiveness)
	endmethod

	/*
	 * 创建物品给单位(内部)
	 * itemid 物品ID
	 * charges 使用次数
	 * whichUnit 哪个单位
	 * isMix 设定是否合成（true则触发事件）
	 */
	private static method toUnitPrivate takes integer itemid,integer charges,unit whichUnit,boolean isMix returns nothing
		local integer remainCharges = charges
		local integer i = 0
		local item it = null
		local integer itCharges = 0
		local integer overlay = getOverlay(itemid)
		local real weight = 0
		local integer canGetQty = 0
		local integer notGetQty = 0
		//判断物品是否自动使用，自动使用的物品不会检测叠加和合成，而是直接执行属性分析
		if(getIsPowerup(itemid) == true)then
			call addAttr(itemid,charges,whichUnit)
			return
		endif
		//检测重量,没空间就丢在地上
		if(getWeight(itemid)>0)then
			set canGetQty = R2I((hattr.getWeight(whichUnit) - hattr.getWeightCurrent(whichUnit)) / getWeight(itemid)) //算出以剩下的背包空间还能放多少件
			if(canGetQty>charges)then
				set canGetQty = charges
			endif
			set notGetQty = charges - canGetQty
			//拿到的计算中来那个
			if(canGetQty>0)then
				set weight = hattr.getWeightCurrent(whichUnit) + getWeight(itemid) * I2R(canGetQty) //计算出最终重量
				call hattr.setWeightCurrent(whichUnit,weight,0)
			endif
			//拿不到的扔在地上
			if(notGetQty>0)then
				set it = CreateItem(itemid, GetUnitX(whichUnit),GetUnitY(whichUnit))
				call SetItemCharges(it,notGetQty)
				call hmsg.style(hmsg.ttg2Unit(whichUnit,"背包负重不足",6.00,"ffff80",0,2.50,50.00) ,"scale",0,0.05)
				//如果一件都拿不到，后面不执行
				if(notGetQty>=charges)then
					return
				endif
			endif
		endif
		//执行叠加
		set i = 5
        loop
            exitwhen i < 0
            set it = UnitItemInSlot(whichUnit,i)
            if ( it!=null and itemid == GetItemTypeId(it)) then
                //如果第i格物品和获得的一致
                //如果有极限值 并且原有的物品未达上限
                if(overlay>0 and GetItemCharges(it) != overlay) then
                    if((remainCharges+GetItemCharges(it))<= overlay) then
                        //条件：如果新物品加旧物品使用次数不大于极限值
                        //使旧物品使用次数增加，新物品数量清0
						call addAttr(itemid,remainCharges,whichUnit)
                        call SetItemCharges(it,GetItemCharges(it)+remainCharges) 
                        set remainCharges = 0
                    else
                        //否则，如果使用次数大于极限值,旧物品次数满载，新物品数量减少
						call addAttr(itemid,overlay-GetItemCharges(it),whichUnit)
                        set remainCharges = GetItemCharges(it)+remainCharges-overlay
						call SetItemCharges(it,overlay)
                    endif
                    call DoNothing() YDNL exitwhen true//(  )
                endif
            endif
            set i = i - 1
        endloop
		//执行合成
		set remainCharges = hitemMix.execByItem(itemid,remainCharges,whichUnit)
		//end处理
		if(remainCharges>0)then
			//建在地上
			set it = CreateItem(itemid, GetUnitX(whichUnit),GetUnitY(whichUnit))
			call SetItemCharges(it,remainCharges)
			if(isMix == true)then
				//@触发 合成物品 事件
				set hevtBean = hEvtBean.create()
				set hevtBean.triggerKey = "itemMix"
				set hevtBean.triggerUnit = whichUnit
				set hevtBean.triggerItem = it
				call hevt.triggerEvent(hevtBean)
				call hevtBean.destroy()
			endif
			if(getEmptySlot(whichUnit)>=1)then
				//有格子则扔到单位上，并分析属性
				call UnitAddItem(whichUnit,it)
				call addAttr(itemid,remainCharges,whichUnit)
				//@触发 获得物品 事件
				set hevtBean = hEvtBean.create()
				set hevtBean.triggerKey = "itemGet"
				set hevtBean.triggerUnit = whichUnit
				set hevtBean.triggerItem = it
				call hevt.triggerEvent(hevtBean)
				call hevtBean.destroy()
			endif
		endif
	endmethod

	/*
	 * 创建非合成物品给单位
	 * itemid 物品ID
	 * charges 使用次数
	 * whichUnit 哪个单位
	 */
	public static method toUnit takes integer itemid,integer charges,unit whichUnit returns nothing
		call toUnitPrivate(itemid,charges,whichUnit,false)
	endmethod

	/*
	 * 创建合成物品给单位（会触发合成事件）
	 * itemid 物品ID
	 * charges 使用次数
	 * whichUnit 哪个单位
	 */
	public static method toUnitMix takes integer itemid,integer charges,unit whichUnit returns nothing
		call toUnitPrivate(itemid,charges,whichUnit,true)
	endmethod

	//捡起物品(检测)
	private static method itemPickupCheck takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local integer during = htime.getInteger(t,0)
		local item it = htime.getItem(t,1)
		local unit u = htime.getUnit(t,2)
		local integer itid = 0
		local integer charges = 0
		if(during>200 or it==null or his.death(u) or LoadInteger(hash_item,GetHandleId(u),StringHash("_ITEMPICKUPCHECK_"))!=GetHandleId(it))then
			call htime.delTimer(t)
			set it = null
			set u = null
			return
		endif
		call htime.setInteger(t,0,during+1)
		if(hcamera.model=="zoomin")then
			if(hlogic.getDistanceBetweenXY(GetItemX(it),GetItemY(it),GetUnitX(u),GetUnitY(u))>125)then
				return
			endif
		elseif(hlogic.getDistanceBetweenXY(GetItemX(it),GetItemY(it),GetUnitX(u),GetUnitY(u))>250)then
			return
		endif
		call htime.delTimer(t)
		//先删除物品,在创建
		set itid = GetItemTypeId(it)
		set charges = GetItemCharges(it)
		call RemoveItem(it)
		set it = null
		call toUnit(itid,charges,u)
		set u = null
	endmethod

	//捡起物品
	private static method itemPickupFalse takes nothing returns nothing
		local unit u = GetTriggerUnit()
		call SaveInteger(hash_item,GetHandleId(u),StringHash("_ITEMPICKUPCHECK_"),0)
		set u = null
	endmethod

	//捡起物品
	private static method itemPickup takes nothing returns nothing
		local unit u = GetTriggerUnit()
		local item it = GetOrderTargetItem()
		local integer itid = GetItemTypeId(it)
		local integer charges = 0
		local timer t = null
		if(isFormat(itid)!=true)then
			return
		endif
		call SaveInteger(hash_item,GetHandleId(u),StringHash("_ITEMPICKUPCHECK_"),0)
		if(it!=null and GetIssuedOrderId() == OrderId("smart"))then
			set charges = GetItemCharges(it)
			if(hcamera.model=="zoomin")then
				if(hlogic.getDistanceBetweenXY(GetItemX(it),GetItemY(it),GetUnitX(u),GetUnitY(u))>75)then
					call SaveInteger(hash_item,GetHandleId(u),StringHash("_ITEMPICKUPCHECK_"),GetHandleId(it))
					set t = htime.setInterval(0.10,function thistype.itemPickupCheck)
					call htime.setInteger(t,0,0)
					call htime.setItem(t,1,it)
					call htime.setUnit(t,2,u)
					return
				endif
			elseif(hlogic.getDistanceBetweenXY(GetItemX(it),GetItemY(it),GetUnitX(u),GetUnitY(u))>150)then
				call SaveInteger(hash_item,GetHandleId(u),StringHash("_ITEMPICKUPCHECK_"),GetHandleId(it))
				set t = htime.setInterval(0.1,function thistype.itemPickupCheck)
				call htime.setInteger(t,0,0)
				call htime.setItem(t,1,it)
				call htime.setUnit(t,2,u)
				return
			endif
			//先删除物品,在创建
			call RemoveItem(it)
			set it = null
			call toUnit(itid,charges,u)
		endif
	endmethod

	//丢弃物品
	private static method itemDrop takes nothing returns nothing
		local unit u = GetTriggerUnit()
		local item it = GetManipulatedItem()
		local real weight = 0
		local string orderid = OrderId2StringBJ(GetUnitCurrentOrder(u))
		if(it!=null and isFormat(GetItemTypeId(it))==true and IsItemOwned(it) and orderid=="dropitem")then
			call subAttr(GetItemTypeId(it),GetItemCharges(it),u)
			set weight = hattr.getWeightCurrent(u) - getWeight(GetItemTypeId(it)) * I2R(GetItemCharges(it))
			call hattr.setWeightCurrent(u,weight,0)
			//@触发 丢弃物品 事件
			set hevtBean = hEvtBean.create()
			set hevtBean.triggerKey = "itemDrop"
			set hevtBean.triggerUnit = u
			set hevtBean.triggerItem = it
			call hevt.triggerEvent(hevtBean)
			call hevtBean.destroy()
		endif
	endmethod

	//售卖物品
	private static method itemPawn takes nothing returns nothing
		local unit u = GetTriggerUnit()
		local item it = GetSoldItem()
		local integer itid = GetItemTypeId(it)
		local integer charges = GetItemCharges(it)
		local integer gold = getGold(itid)*charges
		local integer lumber = getLumber(itid)*charges
		local real sellRadio = hplayer.getSellRatio(GetOwningPlayer(u))
		if(it!=null)then
			if(isFormat(GetItemTypeId(it))==true and sellRadio > 0)then
				call haward.forUnit(u,0,R2I(I2R(gold)*sellRadio*0.01),R2I(I2R(lumber)*sellRadio*0.01))
			endif
			//@触发 售卖物品 事件
			set hevtBean = hEvtBean.create()
			set hevtBean.triggerKey = "itemPawn"
			set hevtBean.triggerUnit = u
			set hevtBean.triggerItem = it
			call hevt.triggerEvent(hevtBean)
			call hevtBean.destroy()
		endif
	endmethod

	//拆成单品
	private static method itemSeparateSimple takes item itSeparate,unit u returns nothing
		local integer itid = GetItemTypeId(itSeparate)
		local integer charges = GetItemCharges(itSeparate)
		local real x = 0
		local real y = 0
		local real weight = 0
		local item it = null
		local integer i = 0
		if(IsItemOwned(itSeparate) == true)then
			set x = GetUnitX(u)
			set y = GetUnitY(u)
			set weight = hattr.getWeightCurrent(u) - getWeight(itid) * I2R(charges)
			call hattr.setWeightCurrent(u,weight,0)
		else
			set x = GetItemX(itSeparate)
			set y = GetItemY(itSeparate)
		endif
		//@触发 拆分物品 事件(多件拆分为单件)
		set hevtBean = hEvtBean.create()
		set hevtBean.triggerKey = "itemSeparate"
		set hevtBean.triggerUnit = u
		set hevtBean.id = itid
		set hevtBean.type = "simple"
		call hevt.triggerEvent(hevtBean)
		call hevtBean.destroy()
		if(IsItemOwned(itSeparate) == true)then
			set weight = hattr.getWeightCurrent(u) - getWeight(itid)*I2R(charges)
			call hattr.setWeightCurrent(u,weight,0)
		endif
		call RemoveItem(itSeparate)
		set i = charges
		loop
			exitwhen i <= 0
				set it = CreateItem(itid,x,y)
				call SetItemCharges(it,1)
			set i = i-1
		endloop
		call hmsg.echoTo(GetOwningPlayer(u),"已拆分成 |cffffff80"+I2S(charges)+" 件单品|r",0)
		set it = null
	endmethod

	//合成品拆分
	private static method itemSeparateMulti takes item itSeparate,integer formula,unit u returns nothing
		local integer itid = 0
		local string msg = ""
		local integer formulaFlagmentQty = 0
		local integer i = 0
		local real x = 0
		local real y = 0
		local integer formulaNeedType = 0
		local integer formulaNeedQty = 0
		local item it = null
		local real weight = 0
		if(formula>0 and itSeparate!=null and u!=null)then
			set itid = GetItemTypeId(itSeparate)
			//@触发 拆分物品 事件(合成拆分)
			set hevtBean = hEvtBean.create()
			set hevtBean.triggerKey = "itemSeparate"
			set hevtBean.triggerUnit = u
			set hevtBean.id = itid
			set hevtBean.type = "mixed"
			call hevt.triggerEvent(hevtBean)
			call hevtBean.destroy()

			if(IsItemOwned(itSeparate) == true)then
				set x = GetUnitX(u)
				set y = GetUnitY(u)
				set weight = hattr.getWeightCurrent(u) - getWeight(itid) * I2R(GetItemCharges(itSeparate))
				call hattr.setWeightCurrent(u,weight,0)
			else
				set x = GetItemX(itSeparate)
				set y = GetItemY(itSeparate)
			endif
			set formulaFlagmentQty = hitemMix.getFormulaFlagmentQty(itid,formula)
			set i = formulaFlagmentQty
			set msg = "已拆分成 "
			loop
				exitwhen i <= 0
					set formulaNeedType = hitemMix.getFormulaFlagmentNeedType(itid,formula,i)
					set formulaNeedQty = hitemMix.getFormulaFlagmentNeedQty(itid,formula,i)
					if(formulaNeedQty>0)then
						set it = CreateItem(formulaNeedType,x,y)
						call SetItemCharges(it,formulaNeedQty)
						if(i == 1)then
							set msg = msg+"|cffffff80 "+GetItemName(it)+"x"+I2S(formulaNeedQty)+" |r"
						else
							set msg = msg+"|cffffff80 "+GetItemName(it)+"x"+I2S(formulaNeedQty)+" |r + "
						endif
					endif
				set i = i-1
			endloop
			if(formulaFlagmentQty == 1)then
				call itemSeparateSimple(it,u)
			endif
			call RemoveItem(itSeparate)
			call hmsg.echoTo(GetOwningPlayer(u),msg,0)
		endif
	endmethod

	//对话框拆分物品
	private static method itemSeparateDialog takes nothing returns nothing
		local dialog d = GetClickedDialog()
		local button b = GetClickedButton()
		local item it = LoadItemHandle(hash_item,GetHandleId(b),1)
		local integer formula = LoadInteger(hash_item,GetHandleId(b),2)
		local unit u = LoadUnitHandle(hash_item,GetHandleId(b),3)
		call itemSeparateMulti(it,formula,u)
		call DialogClear( d )
		call DialogDestroy( d )
		call DisableTrigger(GetTriggeringTrigger())
		call DestroyTrigger(GetTriggeringTrigger())
		set d = null
	endmethod

	//拆分物品
	private static method itemSeparate takes nothing returns nothing
		local unit u = GetTriggerUnit()
		local item it = GetSpellTargetItem()
		local integer itid = 0
		local integer charges = 0
		local integer formulaQty = 0
		local integer formulaFlagmentQty = 0
		local integer formulaNeedType = 0
		local integer formulaNeedQty = 0
		local integer i = 0
		local integer j = 0
		local string msg = ""
		local dialog d = null
		local button b = null
		local trigger dtg = null
		local real weight = 0
		if(it!=null and GetSpellAbilityId()==ITEM_ABILITY_SEPARATE )then
			if(isFormat(GetItemTypeId(it))!=true)then
				call hmsg.echoTo(GetOwningPlayer(u),"|cffff8080物品不在hJass系统内|r",0)
				return
			endif
			call IssueImmediateOrder(u,"stop")
			set itid = GetItemTypeId(it)
			set charges = GetItemCharges(it)
			if(charges>1)then
				call itemSeparateSimple(it,u)
			elseif(charges==1)then
				set formulaQty = hitemMix.getFormulaQty(itid)
				if(formulaQty == 1)then
					call itemSeparateMulti(it,1,u)
				elseif(formulaQty > 1)then
					set msg = "拆分："+GetItemName(it)
					set d = DialogCreate()
					call DialogSetMessage( d, msg )
					set j = formulaQty
					loop
						exitwhen j <= 0
							set formulaFlagmentQty = hitemMix.getFormulaFlagmentQty(itid,j)
							set i = formulaFlagmentQty
							set msg = ""
							loop
								exitwhen i <= 0
									set formulaNeedType = hitemMix.getFormulaFlagmentNeedType(itid,j,i)
									set formulaNeedQty = hitemMix.getFormulaFlagmentNeedQty(itid,j,i)
									if(formulaNeedType>=1)then
										if(i == 1)then
											set msg = msg+getNameById(formulaNeedType)+" x"+I2S(formulaNeedQty)
										else
											set msg = msg+getNameById(formulaNeedType)+" x"+I2S(formulaNeedQty)+"+"
										endif
									endif
								set i = i-1
							endloop
							set b = DialogAddButton(d,msg,0)
							call SaveItemHandle(hash_item,GetHandleId(b),1,it)
							call SaveInteger(hash_item,GetHandleId(b),2,j)
							call SaveUnitHandle(hash_item,GetHandleId(b),3,u)
						set j = j-1
					endloop
					set b = DialogAddButton(d,"取消 ( ESC )",512)
					call SaveItemHandle(hash_item,GetHandleId(b),1,null)
					call SaveInteger(hash_item,GetHandleId(b),2,0)
					call SaveUnitHandle(hash_item,GetHandleId(b),3,null)
					set dtg = CreateTrigger()
					call TriggerAddAction(dtg, function thistype.itemSeparateDialog)
					call TriggerRegisterDialogEvent( dtg , d )
					call DialogDisplay( GetOwningPlayer(u),d, true )
				else
					call hmsg.echoTo(GetOwningPlayer(u),"|cffff8080已不可拆分|r",0)
				endif
			endif
		endif
		set it = null
	endmethod

	//初始化单位，绑定事件等
	public static method initUnit takes unit whichUnit returns nothing
		call TriggerRegisterUnitEvent( ITEM_TRIGGER_PICKUP,whichUnit,EVENT_UNIT_ISSUED_TARGET_ORDER )
		call TriggerRegisterUnitEvent( ITEM_TRIGGER_PICKUP_FALSE, whichUnit, EVENT_UNIT_ISSUED_ORDER )
    	call TriggerRegisterUnitEvent( ITEM_TRIGGER_PICKUP_FALSE, whichUnit, EVENT_UNIT_ISSUED_POINT_ORDER )
		call TriggerRegisterUnitEvent( ITEM_TRIGGER_DROP, whichUnit, EVENT_UNIT_DROP_ITEM )
		call TriggerRegisterUnitEvent( ITEM_TRIGGER_PAWN, whichUnit, EVENT_UNIT_PAWN_ITEM )
		call TriggerRegisterUnitEvent( ITEM_TRIGGER_SEPARATE, whichUnit, EVENT_UNIT_SPELL_EFFECT )
	endmethod

	//初始化
	public static method initSet takes nothing returns nothing
		set ITEM_TRIGGER_PICKUP = CreateTrigger()
		set ITEM_TRIGGER_PICKUP_FALSE = CreateTrigger()
		set ITEM_TRIGGER_DROP = CreateTrigger()
		set ITEM_TRIGGER_PAWN = CreateTrigger()
		set ITEM_TRIGGER_SEPARATE = CreateTrigger()
		call TriggerAddAction(ITEM_TRIGGER_PICKUP, function thistype.itemPickup)
		call TriggerAddAction(ITEM_TRIGGER_PICKUP_FALSE, function thistype.itemPickupFalse)
		call TriggerAddAction(ITEM_TRIGGER_DROP, function thistype.itemDrop)
		call TriggerAddAction(ITEM_TRIGGER_PAWN, function thistype.itemPawn)
		call TriggerAddAction(ITEM_TRIGGER_SEPARATE, function thistype.itemSeparate)
	endmethod

endstruct
