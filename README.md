# hwealnegn-MPCS51030-Winter-2015-Assignment-5
Grade: 10/10

- Great job overall!

- You should use properties instead of instance variables, e.g.
{
AVAudioPlayer *_soundEffect;
}
should instead look more like:
@property (strong, nonatomic) AVAudioPlayer *soundEffectl

- Keep as many properties private as possible