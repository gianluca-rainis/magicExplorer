using UnityEngine;

public class EnemyHealth : MonoBehaviour
{
    public int maxHP = 3;
    private int currentHP;

    void Start()
    {
        currentHP = maxHP;
    }

    public void TakeDamage(int amount)
    {
        currentHP -= amount;

        if (currentHP <= 0)
        {
            Die();
        }
    }

    void Die()
    {
        Destroy(gameObject);
    }
}