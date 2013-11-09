package gameconfig
{
	public class Configrations
	{
		public function Configrations()
		{
		}
		//配置
		public static const DATABASE_URL:String = "";
		public static const GATEWAY:String = "http://192.168.1.103/MyPoolServer/www/amf/gateway.php";
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
		
	}
}