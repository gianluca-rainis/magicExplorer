using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.InputSystem;
using TMPro;

public class PauseMenuPanel : MonoBehaviour
{
    public GameObject pauseMenuPanel;
    public SettingsPanel settingsPanel;
    public TMP_Text fireboltlevelText;
    public TMP_Text airwalllevelText;
    public TMP_Text watertraplevelText;
    private bool isPaused = false;

    public void Start()
    {
        pauseMenuPanel.SetActive(false);
        Time.timeScale = 1f;
    }

    public void Update()
    {
        UpdateSelectedSpellLevelText();

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

    public void UpdateSelectedSpellLevelText(SpellBase selectedSpell = null)
    {
        if (fireboltlevelText == null || airwalllevelText == null || watertraplevelText == null || selectedSpell == null)
        {
            return;
        }

        if (selectedSpell is FireBolt)
        {
            fireboltlevelText.text = "Level " + selectedSpell.level;
        }
        else if (selectedSpell is AirWall)
        {
            airwalllevelText.text = "Level " + selectedSpell.level;
        }
        else if (selectedSpell is WaterTrap)
        {
            watertraplevelText.text = "Level " + selectedSpell.level;
        }
    }
}