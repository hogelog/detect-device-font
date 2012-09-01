// forked from kinaba1's flash on 2011-5-24
package {
    import flash.text.TextFieldAutoSize;
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.text.Font;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.Dictionary;
    import mx.events.ScrollEvent;
    import mx.events.ScrollEventDirection;
    public class DeviceFontTest extends Sprite {
        public function DeviceFontTest() {
            var text:String = "";
            text += showDetectedFonts(["_sans", "_serif", "_typewriter"], "ABCDEabcde01234");
            text += showDetectedFonts(["_ゴシック", "_明朝", "_等幅"], "祇辻飴葛蛸鯖鰯噌庖箸");
            drawText("_sans", text, 0);
        }
        private function showDetectedFonts(deviceFonts:Array, sampleText:String):String {
            var availableFontsBitmapData:Dictionary = new Dictionary();
            for each (var font:Font in Font.enumerateFonts(true)) {
                availableFontsBitmapData[font.fontName] = toBitmapData(toTextField(font.fontName, sampleText));
            }

            var text:String = "";
            var y:int = 0;
            for each (var fontName:String in deviceFonts) {
                var data:BitmapData = toBitmapData(toTextField(fontName, sampleText));
                text += "\n" + fontName + ": ";
                for each(var realFontName:String in findRealFonts(availableFontsBitmapData, data)) {
                    text += "\n    " + realFontName;
                }
            }
            return text;
        }
        private function drawText(fontName:String, text:String, y:int):int {
            var field:TextField = toTextField(fontName, text);
            field.x = 0;
            field.y = y;
            field.multiline = true;
            addChild(field);
            y += field.height;
            return y;
        }
        private function findRealFonts(fontDictionary:Dictionary, search:BitmapData):Array {
            var fonts:Array = [];
            for (var fontName:String in fontDictionary) {
                if (equalBitmapData(search, fontDictionary[fontName]))
                    fonts.push(fontName);
            }
            return fonts;
        }
        private function toTextField(fontName:String, text:String):TextField {
            var field:TextField = new TextField();
            var myFormat:TextFormat = new TextFormat();
            myFormat.size = 20;
            myFormat.font = fontName;
            field.autoSize = TextFieldAutoSize.LEFT;
            field.defaultTextFormat = myFormat;
            field.text = text;
            return field;
        }
        private function toBitmapData(field:TextField):BitmapData {
            var bitmapData:BitmapData = new BitmapData(field.width, field.height);
            bitmapData.draw(field);
            return bitmapData;
        }
        private function equalBitmapData(data1:BitmapData, data2:BitmapData):Boolean {
            if (!data1.rect.equals(data2.rect)) 
                return false;
            
            var width:int = data1.width;
            var height:int = data1.height;
            for (var x:int = 0; x < width; ++x) {
                for (var y:int = 0; y < height; ++y) {
                    var p1:int = data1.getPixel(x, y);
                    var p2:int = data2.getPixel(x, y);
                    if (p1 != p2)
                        return false;
                }
            }
            return true;
        }
    }
}
