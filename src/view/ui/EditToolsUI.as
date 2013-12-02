package view.ui
{
	import controller.UiController;
	
	import gameconfig.LanguageController;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	import view.render.EditToolsRender;

	public class EditToolsUI extends Sprite
	{
		private var isOpened:Boolean = false;
		private var renderGap:Number = 20;
		
		public function EditToolsUI()
		{
		}
		public function show(isOpen:Boolean = false):void
		{
			destroy();
			var data:Object;
			var render:EditToolsRender;
			var leftPoint:Number = 0;
			var renderArr:Array = isOpen?openedList:closedList;
			for each(data in renderArr){
				render = new EditToolsRender(data);
				addChild(render);
				render.x = leftPoint;
				leftPoint +=(render.width + renderGap);
			}
		}
		
		private const openedList:Array = 
			[
				{ label: LanguageController.getInstance().getString("cancel"), texture: "rightArrowIcon",type:UiController.TOOL_CANCEL},
				{ label: LanguageController.getInstance().getString("plow"), texture: "plowIcon",type:UiController.TOOL_ADDFEILD},
				{ label: LanguageController.getInstance().getString("move"), texture: "moveIcon",type:UiController.TOOL_MOVE},
				{ label: LanguageController.getInstance().getString("sell"), texture: "sellIcon",type:UiController.TOOL_SELL}
			];
		private const closedList:Array = 
			[
				{ label: LanguageController.getInstance().getString("edit"), texture: "editIcon"},
			];
		
		private function destroy():void
		{
			var displayObj:DisplayObject;
			while(numChildren>0){
				displayObj = getChildAt(0);
				if(displayObj is EditToolsRender){
					(displayObj as EditToolsRender).destroy();
				}
				removeChild(displayObj);
			}
		}
	}
}