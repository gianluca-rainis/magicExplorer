using UnityEngine;

public class SettingsPanel : MonoBehaviour
{
    public RectTransform panel;
    public float speed = 10f;

    private Vector2 hiddenPosition;
    private Vector2 shownPosition;
    private bool isOpen = false;

    void Start()
    {
        shownPosition = panel.anchoredPosition;
        hiddenPosition = new Vector2(shownPosition.x, shownPosition.y + panel.rect.height);
        panel.anchoredPosition = hiddenPosition;
    }

    void Update()
    {
        if (isOpen)
        {
            panel.anchoredPosition = Vector2.Lerp(panel.anchoredPosition, shownPosition, Time.unscaledDeltaTime * speed);
        }
        else
        {
            panel.anchoredPosition = Vector2.Lerp(panel.anchoredPosition, hiddenPosition, Time.unscaledDeltaTime * speed);
        }
    }

    public void ToggleMenu()
    {
        isOpen = !isOpen;
    }

    public void CloseMenu()
    {
        isOpen = false;
    }
}