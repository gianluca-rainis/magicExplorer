using UnityEngine;
using UnityEngine.UI;
using System.Collections.Generic;
using Unity.VisualScripting;

public class HealthSystem : MonoBehaviour
{
    public PlayerHealth playerHealth;
    public GameObject heartPrefab;
    public Sprite fullHeartSprite;
    public Sprite halfHeartSprite;
    public Sprite emptyHeartSprite;

    private List<Image> heartImages = new List<Image>();

    void Start()
    {
        CreateHearts();
        playerHealth.onHealthChanged += UpdateHearts;
        UpdateHearts();
    }

    void CreateHearts()
    {
        for (int i = 0; i < playerHealth.maxHP; i++)
        {
            GameObject heart = Instantiate(heartPrefab, transform);
            Image heartImage = heart.GetComponent<Image>();
            heartImages.Add(heartImage);
        }
    }

    void UpdateHearts()
    {
        for (int i = 0; i < heartImages.Count; i++)
        {
            if (playerHealth.currentHP >= i+1)
            {
                heartImages[i].sprite = fullHeartSprite;
            }
            else if (playerHealth.currentHP > i && playerHealth.currentHP < i+1)
            {
                heartImages[i].sprite = halfHeartSprite;
            }
            else
            {
                heartImages[i].sprite = emptyHeartSprite;
            }
        }
    }
}