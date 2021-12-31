import java.nio.file.FileSystems;

public class Thread2 extends Thread{
	FilePlayer fp;
	String folderLocation = "";
	
	public Thread2() {
		fp = new FilePlayer();
		
		folderLocation = FileSystems.getDefault().getPath(new String()).toAbsolutePath() + "/src/Sounds/";
	}
	
	@Override
	public void run() {
		delay(600);
		fp.play(folderLocation + "re.wav"); // play re sound
		
		delay(1200);
		fp.play(folderLocation + "fa.wav"); // play fa sound
		
		delay(1800);
		fp.play(folderLocation + "la.wav"); // play la sound

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
