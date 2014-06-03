package gameconfig
{
	import flash.net.URLLoader;
	
	import controller.SpecController;
	
	import model.gameSpec.ItemSpec;
	
	
	public class LanguageController
	{
		private static var _instance:LanguageController;
		public static function getInstance():LanguageController{
			if(!_instance){
				_instance = new LanguageController;
			}
			return _instance;
		}
		public function LanguageController(){
			
		}
		private var resourcesLoader:URLLoader;
		
		private var dictLanguage:Object = {};
		public function set languageXML(xml:XML):void
		{
			var xmlList:XMLList =  xml.children();
			for each(var subXML1:XML in xmlList)
			{
				var key:String = String(subXML1.@key);
				var value:String = String(subXML1.@value);
				dictLanguage[key]=value;
			}
		}
		
		public function getString(key:String):String
		{
			if(!dictLanguage[key]){
				trace("no language : " + key);
				return key;
			}
			return dictLanguage[key];
		}
		
		public function getTitle(itemid:String,level:int=0):String
		{
			var str:String;
			var spec:ItemSpec = SpecController.instance.getItemSpec(itemid);
			str = spec.name;
			var title :String = Configrations.TITLE_NAME[level];
			str = str+" "+getString(title);
			return str;
		}
		
	}
}