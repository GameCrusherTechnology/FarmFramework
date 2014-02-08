package view.render
{
	import controller.FieldController;
	import controller.GameController;
	import controller.SpecController;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import gameconfig.Configrations;
	
	import model.OwnedItem;
	import model.gameSpec.ItemSpec;
	import model.player.GamePlayer;
	import model.player.PlayerChangeEvents;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.VAlign;
	
	public class PackageListRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		public function PackageListRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		public var item_id:String;
		override public function set data(value:Object):void
		{
			super.data = value;
			if(value){
				item_id =(value as OwnedItem).itemid;
				if(container){
					if(container.parent){
						container.parent.removeChild(container);
					}
				}
				configLayout();
				player.addEventListener(PlayerChangeEvents.ITEM_CHANGE,onPlayerChange);
			}
		}
		private function configLayout():void
		{
			var renderwidth:Number = width;
			var renderheight:Number = height;
			this.isSelected = true;
			container = new Sprite;
			addChild(container);
			
			var spec:ItemSpec = SpecController.instance.getItemSpec(item_id);
			var icon:Image= new Image(Game.assets.getTexture(spec.name + "Icon"));
			icon.height = renderheight*0.8;
			icon.scaleX = icon.scaleY;
			icon.x = renderwidth/2 - icon.width/2;
			icon.y = renderheight*0.2;
			container.addChild(icon);
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderheight,spec.cname,0x000000,25,true);
			nameText.vAlign = VAlign.TOP;
			container.addChild(nameText);
			nameText.y = 0 ;
			
			
			var ownedItem:OwnedItem = GameController.instance.localPlayer.getOwnedItem(item_id);
			countText = FieldController.createSingleLineDynamicField(300,30*scale,"×"+ownedItem.count,0x000000,20,true);
			countText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(countText);
			countText.x = renderwidth -countText.width;
			countText.y = renderheight - countText.height;
			
		}
		private var countText:TextField;
		private function onPlayerChange():void
		{
			var ownedItem:OwnedItem = GameController.instance.localPlayer.getOwnedItem(item_id);
			countText.text = "×"+ownedItem.count;
		}
		
		private function get player():GamePlayer
		{
			return GameController.instance.localPlayer;
		}
		override public function dispose():void
		{
			player.removeEventListener(PlayerChangeEvents.ITEM_CHANGE,onPlayerChange);
			super.dispose();
		}
	}
}


