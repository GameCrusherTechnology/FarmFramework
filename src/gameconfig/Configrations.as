package gameconfig
{
	import controller.SpecController;
	
	import model.gameSpec.ItemSpec;

	public class Configrations
	{
		public function Configrations()
		{
		}
		//配置
		public static var PLATFORM:String = "PC";
		public static var Language:String = "en";
		public static var VERSION:String = "1.0.0";
		public static const DATABASE_URL:String = "";
//		public static const GATEWAY:String = "http://192.168.1.102/NewFarmServer/data/gateway.php";
//		public static const GATEWAY:String = "http://192.241.208.85/NewFarmServer/data/gateway.php";
		public static const GATEWAY:String = "http://sunnyfarm.gamecrusher.net/NewFarmServer/data/gateway.php";
		//拖拽 判断
		public static const CLICK_EPSILON:int = 50;
		public static const GRID_WIDTH:Number = 40;
		public static const GRID_HEIGHT:Number= 40;
		
		public static var ViewPortWidth:Number;
		public static var ViewPortHeight:Number;
		public static var ViewScale:Number = 1;
		
		
		//map
		public static const INIT_Tile:int = 14;
		public static const Tile_Width:int = 50;
		public static const Tile_Height:int= 25;
		
		//profile
		public static const CHARACTER_BOY:int = 0;
		public static const CHARACTER_GIRL:int = 1;
		public static const TITLE_NAME:Array = ["master","master1","master2","master3","master4"];
		
		//task
		public static const ORDER_CD:int = 8*60*60;
		public static const ORDER_EXPIRED:int = 12*60*60;
		
		public static const REWARD_COIN:int = 1;
		public static const REWARD_EXP:int = 2;
		public static const REWARD_LOVE:int = 3;
		
		//entity
		public static const ENTITY_DEFAULT:int = 0;
		public static const ENTITY_WILD:int = 1;
		
		
		//一次加速 化肥 时间
		public static const SPEED_TIME:int = 30;
		public static const SPEED_ITEMID:String = "20001";
		public static const SKILL_CD :int = 8*60*60;
		public static const HELP_CD :int = 24*60*60;
		public static function getSkillCDPrice(left:int):int
		{
			var price :int = 1;
			var p:Number = Math.ceil(left /3600);
			if(p<0){
				p = 8;
			}
			price = p;
			return price;
			
		}
		
		//修改名称 
		public static const CHANGE_NAME_COST:int = 2;
		public static const CHANGE_SEX_COST:int = 2;
		
		//action
		public static const ADD_FIELD:int = 1;
		public static const PLANT:int = 2;
		public static const SPEED:int = 3;
		public static const HARVEST:int = 4;
		public static const MOVE:int = 5;
		public static const SELL:int = 6;
		
		
		//npc
		public static const NPC_NONE:int=0;
		public static const NPC_MALE:int=1;
		public static const NPC_FEMALE:int=2;
		
		//购买方式
		public static const METHOD_COIN :int= 1;
		public static const METHOD_MONEY :int= 2;
		
		//mess type
		public static const MESSTYPE_MES:int = 0;
		public static const MESSTYPE_INVITE:int = 1;
		public static const MESSTYPE_HELP:int = 2;
		public static const MESSTYPE_ORDER:int = 3;
		//等级 经验值 换算
		public static function expToGrade(exp:Number):int{
			return int (Math.sqrt(exp/10));
		}
		public static function gradeToExp(grade:int):Number{
			return int(Math.pow(grade,2)*10);
		}
		
		public static function gradeToLove(grade:int):Number{
			var need:Number;
			need = Math.pow(grade+1,2)*10 - Math.pow(grade,2)*10;
			return need;
		}
		//task 价格
		//fac
		public static const Factory_Tile:int = 5;
		private static var _totalFacTile:int = 0;
		public static function getFacTotalTile():int
		{
			if(_totalFacTile == 0 ){
				var group:Object = SpecController.instance.getGroup("Extend");
				var arr:Array = [];
				for each (var itemspec:ItemSpec in group){
					if(int(int(itemspec.item_id)/1000) == 42){
						arr.push(itemspec);
					}
				}
				
				_totalFacTile = Factory_Tile + arr.length;
			}

			 return _totalFacTile;
		}
		//treasure 价格
		public static const LITTLECOIN:String = "littleFarmCoin";
		public static const LARGECOIN:String = "largeFarmCoin";
		public static const LITTLEGEM:String = "littleFarmGem";
		public static const LARGEGEM:String = "largeFarmGem";
		public static function get91Money(id:String):int
		{
			if(id == "littleFarmGem"){
				return 10;
			}else{
				return 50;
			}
		}
		public static const treasures:Object ={
			"littleFarmCoin":[10000,10],
			"largeFarmCoin":[100000,100],
			"littleFarmGem":[200,2],
			"largeFarmGem":[1100,10]
		};
		public static var treasuresActivity:Object ;
		
		public static function getAchieveId(id:String,type:String):String
		{
			var achieveid :String;
			if(type == "harvestCrop"){
				achieveid = String(int(id)+20000);
			}else{
				achieveid = String(int(id)+20000);
			}
			return achieveid;
		}
		
		public static function getTotalAchievePoint(achieveStr:String):int
		{
			var count:int ;
			if(achieveStr){
				var achArr:Array = achieveStr.split("|");
				for each(var str:String in achArr){
					var index:int;
					for(index;index<str.length;index++){
						count += int(str.charAt(index));
					}
				}
			}
			return count;
		}
		
		public static function isPackaged(spec:ItemSpec):Boolean
		{
			return int(int(spec.item_id)/1000)==25;
		}
		//analytic id
		public static const ANALYTIC_BUY:String = "10000";
		public static const ANALYTIC_BUY_NOT_VALIABLE:String = "10001";
		public static const ANALYTIC_BUY_ERROR:String = "10002";
		public static const ANALYTIC_BUY_SUC:String = "10003";
		
		
		public static function get isLocalTest():Boolean
		{
			return GATEWAY =="http://192.168.1.102/NewFarmServer/data/gateway.php";
		}
		
		public static function get isCN():Boolean
		{
			return Configrations.Language == "zh-CN"||Configrations.Language =="zh-TW";
		}
		public static const Languages:Array  = ["en","zh-CN","de","ru","tr","zh-TW"];
	}
}