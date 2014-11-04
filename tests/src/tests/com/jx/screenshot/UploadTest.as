package tests.com.jx.screenshot
{
	import com.jx.screenshot.Upload;

	public class UploadTest
	{
		
		[Test]
		public function PNGExtension():void
		{
			new Upload("", Upload.PNG_EXTENSION);
		}
		
		[Test]
		public function JPEGExtension():void
		{
			new Upload("", Upload.JPEG_EXTENSION);
		}
		
		[Test(expects="ArgumentError")]
		public function unsupportedExtension():void
		{
			new Upload("", "unsupported");
		}
		
	}
}