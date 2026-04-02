using UnityEngine;
using UnityEngine.UI;

public class MusicController : MonoBehaviour
{
    private const string VolumePrefKey = "MusicVolume";
    private const string TrackPrefKey = "MusicTrackIndex";

    public AudioSource musicSource;
    public Slider volumeSlider;
    public AudioClip[] music;
    private int currentSceneIndex = 0;

    void Start()
    {
        float initialVolume = PlayerPrefs.GetFloat(VolumePrefKey, musicSource != null ? musicSource.volume : 1f);
        int savedTrackIndex = PlayerPrefs.GetInt(TrackPrefKey, currentSceneIndex);

        if (music != null && music.Length > 0)
        {
            currentSceneIndex = Mathf.Clamp(savedTrackIndex, 0, music.Length - 1);
        }
        else
        {
            currentSceneIndex = 0;
        }

        if (musicSource != null)
        {
            musicSource.volume = initialVolume;
        }

        if (volumeSlider != null)
        {
            volumeSlider.SetValueWithoutNotify(initialVolume);
            volumeSlider.onValueChanged.AddListener(ChangeVolume);
        }

        PlayMusic(currentSceneIndex);
    }

    private void OnDestroy()
    {
        if (volumeSlider != null)
        {
            volumeSlider.onValueChanged.RemoveListener(ChangeVolume);
        }
    }

    void ChangeVolume(float value)
    {
        if (musicSource != null)
        {
            musicSource.volume = value;
        }

        PlayerPrefs.SetFloat(VolumePrefKey, value);
        PlayerPrefs.Save();
    }

    public void PlayMusic(int sceneIndex)
    {
        if (musicSource == null || music == null || sceneIndex < 0 || sceneIndex >= music.Length) {
            return;
        }

        currentSceneIndex = sceneIndex;
        PlayerPrefs.SetInt(TrackPrefKey, currentSceneIndex);
        PlayerPrefs.Save();

        musicSource.clip = music[sceneIndex];
        musicSource.Play();
    }

    public void SelectTrack(int index)
    {
        PlayMusic(index);
    }
}