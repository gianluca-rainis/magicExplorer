using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.InputSystem;

public class GameOver : MonoBehaviour
{
    public void Update()
    {
        bool keyboardInput = Keyboard.current != null && Keyboard.current.anyKey.wasPressedThisFrame;
        bool controllerInput = Gamepad.current != null && (
            Gamepad.current.buttonNorth.wasPressedThisFrame || 
            Gamepad.current.buttonSouth.wasPressedThisFrame || 
            Gamepad.current.buttonEast.wasPressedThisFrame || 
            Gamepad.current.buttonWest.wasPressedThisFrame || 
            Gamepad.current.startButton.wasPressedThisFrame || 
            Gamepad.current.selectButton.wasPressedThisFrame
        );

        if (keyboardInput || controllerInput)
        {
            SceneManager.LoadScene("FirstLevel");
        }
    }
}