using UnityEngine;
using UnityEngine.SceneManagement;

public class TitleScreen : MonoBehaviour
{
    public void StartPressed()
    {
        SceneManager.LoadScene("FirstLevel");
    }

    public void QuitPressed()
    {
        Application.Quit();
    }
}