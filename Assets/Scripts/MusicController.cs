using UnityEngine;
using UnityEngine.UI;

public class MusicController : MonoBehaviour
{
    public AudioSource musicSource;
    public Slider volumeSlider;
    public AudioClip[] music;
    private int currentSceneIndex = 0;

    void Start()
    {
        volumeSlider.value = musicSource.volume;
        volumeSlider.onValueChanged.AddListener(ChangeVolume);

        PlayMusic(currentSceneIndex);
    }

    void ChangeVolume(float value)
    {
        musicSource.volume = value;
    }

    public void PlayMusic(int sceneIndex)
    {
        if (sceneIndex < 0 || sceneIndex >= music.Length) {
            return;
        }

        currentSceneIndex = sceneIndex;

        musicSource.clip = music[sceneIndex];
        musicSource.Play();
    }

    public void SelectTrack(int index)
    {
        PlayMusic(index);
    }
}