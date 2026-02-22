using UnityEngine;

public class PlayerHealth : MonoBehaviour
{
    public int maxHP = 3;
    public float currentHP;

    public System.Action onHealthChanged;

    void Start()
    {
        currentHP = maxHP;
        onHealthChanged?.Invoke();
    }

    public void TakeDamage(float damage)
    {
        currentHP -= damage;

        if (currentHP < 0)
        {
            currentHP = 0;
        }

        onHealthChanged?.Invoke();
    }

    public void Heal(float amount)
    {
        currentHP += amount;

        if (currentHP > maxHP)
        {
            currentHP = maxHP;
        }

        onHealthChanged?.Invoke();
    }
}