package controller
{
	import flash.net.URLLoader;
	import flash.utils.Dictionary;
	
	import model.gameSpec.AchieveItemSpec;
	import model.gameSpec.CropSpec;
	import model.gameSpec.ItemSpec;
	
	public class SpecController
	{
		
		private var resourcesLoader:URLLoader;
		private static var control:SpecController;
		public static function get instance():SpecController
		{
			if(!control){
				control = new SpecController();
			}
 			return control;
		}
		public function SpecController()
		{
		}
		private var _itemMap:Dictionary;
		public function initXml(_xml:XML):void
		{
			var group_xml:XML;
			var item_xml:XML;
			var item:ItemSpec;
			var group_id:String;
			_itemMap = new Dictionary;
			for each(group_xml in _xml.Group)
			{
				group_id = group_xml.@id;
				_itemMap[group_id] = {};
				for each(item_xml in group_xml[group_id])
				{
					item = applyPropertiesFromXML(item_xml,group_id);
					item.group_id=group_id;
					_itemMap[group_id][item_xml.@item_id]=item;
				}
			}
			trace("initxml");
		}
		private function applyPropertiesFromXML(xml:XML,groupId:String):ItemSpec{
			var index:int =0 ;
			var xmlList:XMLList = xml.@*;
			var prop:String;
			var value:String;
			var groudCls:* = getSpecCls(groupId);
			var arg1:Object={};
			while (index < xmlList.length()) {
				prop=xmlList[index].name();
				value=xmlList[index].toString();
				try {
					if(value=="true"){
						arg1[prop]=true;
					}else if(value == "false"){
						arg1[prop]=false;
					}else if(parseInt(value).toString()==value){
						arg1[prop]=parseInt(value);
					}else if(parseFloat(value).toString()==value){
						arg1[prop]=parseFloat(value);
					}else{
						arg1[prop] =value;
					}
				} catch(e:Error) {
					
				}
				index++;
			}
			return new groudCls(arg1);
		}
		
		private function getSpecCls(name:String):Class
		{
			switch(name){
				case "Crop":
					return CropSpec;
				case "Item":
					return ItemSpec;
				case "AchieveItem":
					return AchieveItemSpec;
			}
			return ItemSpec;
		}
		public function getGroup(groupid:String):Object
		{
			var groupDic:Object;
			try{
				groupDic = _itemMap[groupid];
			}catch(e:Error){
				trace("error ---- no this + groupid : " +groupid);
			}
			return groupDic;
		}
		private function getGroupById(id:String):String
		{
			var group:String;
			var itemid:int = int(id);
			var type:int = Math.floor(itemid/10000);
			switch(type){
				case 1:
					group = "Crop"
					break;
				case 2:
					group = "Item"
					break;
				case 3:
					group = "AchieveItem"
					break;
				
					
			}
			return group;
		}
		public function getItemSpec(id:String):ItemSpec
		{
			var item:ItemSpec;
			var groupId:String = getGroupById(id);
			try{
				item = _itemMap[groupId][id];
			}catch(e:Error){
				trace("error ---- no this item item id :"+id +"group_id : " +groupId);
			}
			return item;
		}
	}
}