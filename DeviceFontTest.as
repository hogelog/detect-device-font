// forked from kinaba1's flash on 2011-5-24
package {
    import flash.text.TextFieldAutoSize;
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.text.Font;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.system.Capabilities;
    import flash.utils.Dictionary;
    public class DeviceFontTest extends Sprite {
        private const TEXT:String = "あのイーハトーヴォのすきとおった風、";
        public function DeviceFontTest() {
            var availableFontsBitmapData:Dictionary = new Dictionary();
            for each (var font:Font in Font.enumerateFonts(true)) {
                availableFontsBitmapData[font.fontName] = toBitmapData(toTextField(font.fontName, TEXT));
            }

            var deviceFonts:Array = ["_sans", "_serif", "_typewriter", "_ゴシック", "_明朝", "_等幅"];
            var y:int = 0;
            for each (var fontName:String in deviceFonts) {
                var data:BitmapData = toBitmapData(toTextField(fontName, TEXT));
                var realFontName:String = findFont(availableFontsBitmapData, data);
                var text:String = fontName + " = " + (realFontName =! null ? realFontName : fontName); 
                var field:TextField = toTextField(fontName, text);
                field.x = 0;
                field.y = y;
                addChild(field);
                y += field.height;
            }
        }
        private function findFont(fontDictionary:Dictionary, search:BitmapData):String {
            for (var fontName:String in fontDictionary) {
                if (equalBitmapData(search, fontDictionary[fontName]))
                    return fontName;
            }
            return null;
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
