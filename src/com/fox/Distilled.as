/*
* ...
* @author SecretFox
*/
import com.GameInterface.DistributedValueBase;
import com.GameInterface.Inventory;
import com.GameInterface.InventoryItem;
import flash.filters.DropShadowFilter;
import mx.utils.Delegate;
 
class com.fox.Distilled 
{
	public static function main(swfRoot:MovieClip):Void
	{
		var s_app:Distilled = new Distilled(swfRoot);
		swfRoot.onLoad = function(){s_app.OnLoad()};
	}

	public function Distilled() { }
	
	public function OnLoad()
	{
		if ( !_global.com.Components.ItemComponent.prototype.SetData){
			setTimeout(Delegate.create(this, OnLoad), 100);
			return;
		}
		if ( _global.com.Components.ItemComponent.DistillateHook)
		{
			return;
		}

		var org = _global.com.Components.ItemComponent.prototype.SetData;
		var f:Function = function(newData:InventoryItem, iconLoadDelay:Number, firstRun:Boolean)
		{
			if ( !firstRun ) {
				org.apply(this, arguments);
			}
			if ( newData.m_RealType >= 30151 && newData.m_RealType <= 30154 && newData.m_XP)
			{
				var XPTest:MovieClip = this["XPText"];
				if (!XPTest)
				{
					XPTest = this.createEmptyMovieClip("XPText", this.getNextHighestDepth());
					var text:TextField = XPTest.createTextField("text", XPTest.getNextHighestDepth(), 0, this.m_Background._height-18, this.m_Background._width, 1);
					text.autoSize = "center";
					var format:TextFormat = new TextFormat("_StandardFont", 14, 0xFFFFFF, true);
					text.setTextFormat(format);
					text.setNewTextFormat(format);
					text.filters = [new DropShadowFilter(0, 0, 0x000000, 0.8, 1, 1, 255, 1, false, false, false)];
					text.selectable = false;
				}
				
				if ( newData.m_XP <= DistributedValueBase.GetDValue("distilled_low"))
				{
					TextField(XPTest.text).textColor = 0xFB0006;
				}
				else
				{
					TextField(XPTest.text).textColor = 0xFFFFFF;
				}
				if ( newData.m_XP < 1000)
				{
					XPTest.text.text = newData.m_XP;
				}
				else
				{
					XPTest.text.text = Math.round(newData.m_XP / 1000 * 10 ) / 10 + "k";
				}
			}
			else
			{
				MovieClip(this["XPText"]).removeMovieClip();
			}
		}
		_global.com.Components.ItemComponent.prototype.SetData = f;
		
		var backpack:Inventory = _root.backpack2.m_Inventory;
		for (var box in _root.backpack2.m_IconBoxes)
		{
			for (var x in _root.backpack2.m_IconBoxes[box]["m_ItemSlots"])
			{
				for (var y in _root.backpack2.m_IconBoxes[box]["m_ItemSlots"][x])
				{
					var itemSlot = _root.backpack2.m_IconBoxes[box]["m_ItemSlots"][x][y];
					itemSlot["m_SlotMC"]["item"]["SetData"](itemSlot.m_ItemData, undefined, true);
				}
			}
		}
		_global.com.Components.ItemComponent.DistillateHook = true;
	}
}