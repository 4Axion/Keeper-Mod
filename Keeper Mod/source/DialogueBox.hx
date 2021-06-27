package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	public static var box:FlxSprite;
	public static var bbox:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;
	var fswagDialogue:FlxTypeText;
	var nar:FlxTypeText;

	var dropText:FlxText;
	var fdropText:FlxText;
	var narDrop:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;
	var portraitRightAlt:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public static var posm:String = "0,0";
	//public static var upos:Array<Float> = [(Std.parseFloat(poslist[]))]; //diaPos[1]))];
	//var pos:Array<String> = ['1','2','1','2','1','2']; //upos[0].split(",");
	

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		bbox = new FlxSprite(-20, 45);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
			case 'pet':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('portraits/DiaCool');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 60, false);
				box.animation.addByPrefix('normal', 'speech bubble normal', 60, true);
				bbox.frames = Paths.getSparrowAtlas('portraits/DiaCool');
				bbox.animation.addByPrefix('normalOpen', 'InvertOpen', 60, false);
				bbox.animation.addByPrefix('normal', 'Invert', 60, true);
				case 'lost':
					hasDialog = true;
					box.frames = Paths.getSparrowAtlas('portraits/DiaCool');
					box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 60, false);
					box.animation.addByPrefix('normal', 'speech bubble normal', 60, true);
					bbox.frames = Paths.getSparrowAtlas('portraits/DiaCool');
					bbox.animation.addByPrefix('normalOpen', 'InvertOpen', 60, false);
					bbox.animation.addByPrefix('normal', 'Invert', 60, true);
					case 'isolation':
						hasDialog = true;
						box.frames = Paths.getSparrowAtlas('portraits/DiaCool');
						box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 60, false);
						box.animation.addByPrefix('normal', 'speech bubble normal', 60, true);
						bbox.frames = Paths.getSparrowAtlas('portraits/DiaCool');
						bbox.animation.addByPrefix('normalOpen', 'InvertOpen', 60, false);
						bbox.animation.addByPrefix('normal', 'Invert', 60, true);
						case 'keeper':
							hasDialog = true;
							box.frames = Paths.getSparrowAtlas('portraits/DiaCool');
							box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 60, false);
							box.animation.addByPrefix('normal', 'speech bubble normal', 60, true);
							bbox.frames = Paths.getSparrowAtlas('portraits/DiaCool');
							bbox.animation.addByPrefix('normalOpen', 'InvertOpen', 60, false);
							bbox.animation.addByPrefix('normal', 'Invert', 60, true);
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
		{
			trace("fuck you no dialogue");
			return;
		}
		portraitLeft = new FlxSprite(-20, 40);
		portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
		portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitRight = new FlxSprite(0, 40);
		portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
		portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.screenCenter(X);
		bbox.setGraphicSize(Std.int(bbox.width * PlayState.daPixelZoom * 0.9));
		bbox.screenCenter(X);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		
		if(PlayState.SONG.song.toLowerCase() == 'pet' || PlayState.SONG.song.toLowerCase() == 'lost' || PlayState.SONG.song.toLowerCase() == 'isolation' || PlayState.SONG.song.toLowerCase() == 'keeper')
		{
			portraitLeft = new FlxSprite(Std.parseFloat(PlayState.diaPos.split(',')[0]),Std.parseFloat(PlayState.diaPos.split(',')[1]));
			portraitLeft.frames = Paths.getSparrowAtlas('portraits/Keeper');
			portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 60, false);
			portraitLeft.setGraphicSize(Std.int(portraitLeft.width));
			portraitLeft.updateHitbox();
			portraitLeft.scrollFactor.set();
			add(portraitLeft);
			portraitLeft.visible = false;
	
			portraitRight = new FlxSprite(Std.parseFloat(PlayState.diaPos.split(',')[2]),Std.parseFloat(PlayState.diaPos.split(',')[3]));
			portraitRight.frames = Paths.getSparrowAtlas('portraits/SlimeBF');
			portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 60, false);
			portraitRight.setGraphicSize(Std.int(portraitRight.width));
			portraitRight.updateHitbox();
			portraitRight.scrollFactor.set();
			add(portraitRight);
			portraitRight.visible = false;

			portraitRightAlt = new FlxSprite(Std.parseFloat(PlayState.diaPos.split(',')[4]),Std.parseFloat(PlayState.diaPos.split(',')[5]));
			portraitRightAlt.frames = Paths.getSparrowAtlas('portraits/SlimeBFC');
			portraitRightAlt.animation.addByPrefix('enter', 'Boyfriend portrait enter', 60, false);
			portraitRightAlt.setGraphicSize(Std.int(portraitRightAlt.width));
			portraitRightAlt.updateHitbox();
			portraitRightAlt.scrollFactor.set();
			add(portraitRightAlt);
			portraitRightAlt.visible = false;
			box.setGraphicSize(Std.int(box.width));
			box.x = Std.parseFloat(PlayState.diaPos.split(',')[6]);
			box.y = Std.parseFloat(PlayState.diaPos.split(',')[7]);
			bbox.setGraphicSize(Std.int(bbox.width));
			bbox.x = Std.parseFloat(PlayState.diaPos.split(',')[6]);
			bbox.y = Std.parseFloat(PlayState.diaPos.split(',')[7]);

			swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
			swagDialogue.font = 'Pixel Arial 11 Bold';
			swagDialogue.color = 0xBFFF00;
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('keeperText'), 0.6)];

			dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
			dropText.font = 'Pixel Arial 11 Bold';
			dropText.color = 0x008000;
		}
		box.animation.play('normalOpen');
		bbox.animation.play('normalOpen');

		box.updateHitbox();
		add(box);
		bbox.visible = false;
		bbox.updateHitbox();
		add(bbox);
		add(swagDialogue);
		add(dropText);
		box.x = Std.parseFloat(PlayState.diaPos.split(',')[6]);
		box.y = Std.parseFloat(PlayState.diaPos.split(',')[7]);
		bbox.x = Std.parseFloat(PlayState.diaPos.split(',')[6]);
		bbox.y = Std.parseFloat(PlayState.diaPos.split(',')[7]);

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
		add(handSelect);
		trace(PlayState.diaPos.split(',')[1]);

		if (!talkingRight)
		{
			// box.flipX = true;
		}

		fswagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		fswagDialogue.font = 'Pixel Arial 11 Bold';
		fswagDialogue.color = 0x2bc3e9;
		fswagDialogue.sounds = [FlxG.sound.load(Paths.sound('bfText'), 0.6)];
		add(fswagDialogue);

		fdropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		fdropText.font = 'Pixel Arial 11 Bold';
		fdropText.color = 0x052a33;
		add(fdropText);

		nar = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		nar.font = 'Pixel Arial 11 Bold';
		nar.color = 0x000000;
		nar.sounds = [FlxG.sound.load(Paths.sound('narText'), 0.6)];
		add(nar);

		narDrop = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		narDrop.font = 'Pixel Arial 11 Bold';
		narDrop.color = 0x676767;
		add(narDrop);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;
	var diaSkip:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			fswagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
			fdropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;
		fdropText.text = fswagDialogue.text;
		narDrop.text = nar.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				bbox.animation.play('normal');
				dialogueOpened = true;
			}
		}
		if (bbox.animation.curAnim != null)
		{
			if (bbox.animation.curAnim.name == 'normalOpen' && bbox.animation.curAnim.finished)
			{
				bbox.animation.play('normal');
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true || diaSkip == true)
		{
			remove(dialogue);
			diaSkip = false;
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bbox.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						portraitRightAlt.visible = false;
						swagDialogue.alpha -= 1 / 5;
						fswagDialogue.alpha -= 1 / 5;
						nar.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
						fdropText.alpha = fswagDialogue.alpha;
						narDrop.alpha = nar.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;


		switch (curCharacter)
		{
			case 'dad':
				fswagDialogue.visible = false;
				fdropText.visible = false;
				swagDialogue.visible = true;
				box.visible = true;
				bbox.visible = false;
				dropText.visible = true;
			swagDialogue.resetText(dialogueList[0]);
			swagDialogue.start(0.04, true);
				portraitRight.visible = false;
				nar.visible = false;
				narDrop.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'bf':
				swagDialogue.visible = false;
				dropText.visible = false;
				fswagDialogue.visible = true;
				fdropText.visible = true;
				fswagDialogue.resetText(dialogueList[0]);
				fswagDialogue.start(0.04, true);
				box.visible = true;
				bbox.visible = false;
				portraitLeft.visible = false;
				nar.visible = false;
				narDrop.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
			case 'bfc':
				swagDialogue.visible = false;
				dropText.visible = false;
				fswagDialogue.visible = true;
				fdropText.visible = true;
				fswagDialogue.resetText(dialogueList[0]);
				fswagDialogue.start(0.04, true);
				portraitLeft.visible = false;
				portraitRight.visible = false;
				box.visible = true;
				bbox.visible = false;
				nar.visible = false;
				narDrop.visible = false;
				if (!portraitRightAlt.visible)
				{
					portraitRightAlt.visible = true;
					portraitRightAlt.animation.play('enter');
				}
			case 'myDad':
				swagDialogue.visible = false;
				dropText.visible = false;
				box.visible = false;
				bbox.visible = true;
				fswagDialogue.visible = false;
				fdropText.visible = false;
				nar.visible = true;
				narDrop.visible = true;
				nar.resetText(dialogueList[0]);
				nar.start(0.04, true);
				portraitLeft.visible = false;
				portraitRight.visible = false;
			case 'fadetoblack':
				diaSkip = true;
				FlxG.camera.fade(FlxColor.BLACK, 3);
			case 'endsong':
				PlayState.songEnd = true;
				diaSkip = true;
			case 'playmusic':
				FlxG.sound.music.fadeIn(2, FlxG.sound.music.volume * 0.6);
				FlxG.sound.playMusic(Paths.music(dialogueList[0]));
				diaSkip = true;
			case 'comment':
				diaSkip = true;
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
