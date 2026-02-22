using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.InputSystem;
public class PauseMenuPanel : MonoBehaviour
{
    public GameObject pauseMenuPanel;
    public SettingsPanel settingsPanel;
    private bool isPaused = false;

    public void Start()
    {
        pauseMenuPanel.SetActive(false);
        Time.timeScale = 1f;
    }

    public void Update()
    {
        if (Keyboard.current.escapeKey.wasPressedThisFrame)
        {
            if (isPaused)
            {
                ResumeGame();
            }
            else
            {
                PauseGame();
            }
        }
    }

    public void PauseGame()
    {
        pauseMenuPanel.SetActive(true);
        Time.timeScale = 0f;
        isPaused = true;
    }

    public void ResumeGame()
    {
        if (settingsPanel != null)
        {
            settingsPanel.CloseMenu();
        }

        pauseMenuPanel.SetActive(false);
        Time.timeScale = 1f;
        isPaused = false;
    }

    public void OnResumePressed()
    {
        ResumeGame();
    }

    public void QuitPressed()
    {
        SceneManager.LoadScene("TitleScreen");
    }
}