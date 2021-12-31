import java.nio.file.FileSystems;

public class Thread1 extends Thread{
	FilePlayer fp;
	String folderLocation = "";
	
	public Thread1() {
		fp = new FilePlayer();
		
		folderLocation = FileSystems.getDefault().getPath(new String()).toAbsolutePath() + "/src/Sounds/";
	}
	
	@Override
	public void run() {
		delay(300);
		fp.play(folderLocation + "do.wav"); // play do sound
		
		delay(900);
		fp.play(folderLocation + "mi.wav"); // play mi sound
		
		delay(1500);
		fp.play(folderLocation + "sol.wav"); // play sol sound

		delay(2100);
		fp.play(folderLocation + "si.wav"); // play si sound

		delay(2400);
		fp.play(folderLocation + "do-octave.wav"); // play do_octave sound

	}

	private void delay(int millis) {
		try {
			Thread1.sleep(millis);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
}
