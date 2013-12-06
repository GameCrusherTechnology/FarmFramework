package gameconfig
{
	public class Configrations
	{
		public function Configrations()
		{
		}
		//配置
		public static const DATABASE_URL:String = "";
		public static const GATEWAY:String = "http://localhost/NewFarmServer/data/gateway.php";
//		public static const GATEWAY:String = "http://192.241.208.85/MyPoolServer/www/amf/gateway.php";
		//拖拽 判断
		public static const CLICK_EPSILON:int = 50;
		public static const GRID_WIDTH:Number = 40;
		public static const GRID_HEIGHT:Number= 40;
		
		public static var ViewPortWidth:Number;
		public static var ViewPortHeight:Number;
		public static var ViewScale:Number = 1;
		
		
		//map
		public static const INIT_Tile:int = 20;
		public static const Tile_Width:int = 60;
		public static const Tile_Height:int= 30;
		
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
		
		//一次加速 化肥 时间
		public static const SPEED_TIME:int = 30;
		public static const SPEED_ITEMID:String = "20001";
		
		//修改名称 
		public static const CHANGE_NAME_COST:int = 10;
		public static const CHANGE_SEX_COST:int = 10;
		
		//action
		public static const ADD_FIELD:int = 1;
		public static const PLANT:int = 2;
		public static const SPEED:int = 3;
		public static const HARVEST:int = 4;
		public static const MOVE:int = 5;
		public static const SELL:int = 6;
		
		
		//npc
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
			return int(Math.pow(grade,2)*10);
		}
		//task 价格
		
		//treasure 价格
		public static const LITTLECOIN:String = "littlecoin";
		public static const LARGECOIN:String = "largecoin";
		public static const LITTLEGEM:String = "littlegem";
		public static const LARGEGEM:String = "largegem";
		
		public static const treasures:Object ={
			"littlecoin":[1000,10],
			"largecoin":[100000,1000],
			"littlegem":[20,1],
			"largegem":[2000,100]
		};
		
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
		
	}
}