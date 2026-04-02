using UnityEngine;
using UnityEngine.UI;
using System.Collections.Generic;

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
        playerHealth.onHealthChanged += UpdateHearts;
        UpdateHearts();
    }

    private void OnDestroy()
    {
        if (playerHealth != null)
        {
            playerHealth.onHealthChanged -= UpdateHearts;
        }
    }

    private void EnsureHeartCount()
    {
        if (playerHealth == null)
        {
            return;
        }

        while (heartImages.Count < playerHealth.maxHP)
        {
            GameObject heart = Instantiate(heartPrefab, transform);
            Image heartImage = heart.GetComponent<Image>();
            heartImages.Add(heartImage);
        }

        while (heartImages.Count > playerHealth.maxHP)
        {
            int lastIndex = heartImages.Count - 1;
            Image lastHeart = heartImages[lastIndex];

            if (lastHeart != null)
            {
                Destroy(lastHeart.gameObject);
            }

            heartImages.RemoveAt(lastIndex);
        }
    }

    void UpdateHearts()
    {
        EnsureHeartCount();

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