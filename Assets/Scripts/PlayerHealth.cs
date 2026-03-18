using UnityEngine;

public class PlayerHealth : MonoBehaviour
{
    public int maxHP = 3;
    public float currentHP;
    public float damageImmortalTime = 2f;

    public System.Action onHealthChanged;

    private float lastDamageTime = -Mathf.Infinity;

    void Start()
    {
        currentHP = maxHP;
        onHealthChanged?.Invoke();
    }

    public void TakeDamage(float damage)
    {
        if (Time.time < lastDamageTime + damageImmortalTime)
        {
            return;
        }

        lastDamageTime = Time.time;
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