package backends;

class TxtReader {
	public static function readTxtFile(attackFile:String):Array<String> {
		var curTextFile:String = 'assets/data/attacks/${attackFile}.txt';
		var ArrayReturn:Array<String> = [];
		for (attack in CoolUtil.coolTextFile(curTextFile))
		{
			if(attack.trim().length < 1) continue;

			//Okunabilir formatı kullanılabilecek bir koda çevir
			if (attack.contains('Delay: ')) attack = attack.replace('Delay: ', '');
			if (attack.contains(' || Image: ')) attack = attack.replace(' || Image: ', '|');
			if (attack.contains(' || StartX: ')) attack = attack.replace(' || StartX: ', '|');
			if (attack.contains(' || StartY: ')) attack = attack.replace(' || StartY: ', '|');
			if (attack.contains(' || EndX: ')) attack = attack.replace(' || EndX: ', '|');
			if (attack.contains(' || EndY: ')) attack = attack.replace(' || EndY: ', '|');
			if (attack.contains(' || Scale: ')) attack = attack.replace(' || Scale: ', '|');
			if (attack.contains(' || Angle: ')) attack = attack.replace(' || Angle: ', '|');
			if (attack.contains(' || Speed: ')) attack = attack.replace(' || Speed: ', '|');
			if (attack.contains(' || Color: ')) attack = attack.replace(' || Color: ', '|');

			ArrayReturn.push(attack);
		}
		return ArrayReturn;
	}
}