package service.command
{
	import logic.GameController;
	import logic.rules.player.LocalPlayer;

	public class AbstractCommand
	{
		public function AbstractCommand(key:String,callback:Function,params:Object=null)
		{
			Command.execute(key,callback,params);
		}
		
		protected function get localplayer():LocalPlayer
		{
			return GameController.getInstance().localPlayer;
		}
	}
}